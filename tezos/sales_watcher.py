# sales_watcher_24h_once_seller_pretty.py
from __future__ import annotations
import os, sys, time, signal, argparse
from typing import Any, Dict, Optional, Sequence, Tuple
from datetime import datetime, timedelta, timezone

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

OBJKT_GQL = os.environ.get("OBJKT_GQL", "https://data.objkt.com/v3/graphql")
USER_AGENT = os.environ.get("USER_AGENT", "objkt-sales-watcher/1.5-seller-pretty")

DEFAULT_SALE_TYPES: Sequence[str] = (
    "list_buy",
    "offer_accept",
    "english_auction_settle",
    "dutch_auction_buy",
)

class GQLClient:
    def __init__(self, endpoint: str = OBJKT_GQL):
        self.endpoint = endpoint
        self.session = requests.Session()
        retry = Retry(total=5, backoff_factor=0.5,
                      status_forcelist=(429,500,502,503,504),
                      allowed_methods=frozenset(["POST"]),
                      respect_retry_after_header=True)
        adapter = HTTPAdapter(max_retries=retry)
        self.session.mount("https://", adapter)
        self.headers = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "User-Agent": USER_AGENT,
        }
    def query(self, query: str, variables: Dict[str, Any]) -> Dict[str, Any]:
        r = self.session.post(self.endpoint, json={"query": query,"variables":variables}, headers=self.headers, timeout=25)
        data = r.json() if r.content else {}
        if r.status_code >= 400 or "errors" in data:
            raise RuntimeError(f"GraphQL error: HTTP {r.status_code} {data.get('errors')}")
        return data.get("data", {})

SALE_QUERY = """
query SalesSince(
  $limit: Int!,
  $cursor_id: bigint!,
  $since: timestamptz!,
  $sale_types: [marketplace_event_type!],
  $fa_contract: String,
  $seller: String,
  $token_contract: String,
  $token_id: String
) {
  event(
    where: {
      id: { _gt: $cursor_id }
      timestamp: { _gte: $since }
      %(where_extra)s
    }
    order_by: { id: asc }
    limit: $limit
  ) {
    id
    marketplace_event_type
    price_xtz
    timestamp
    creator_address
    recipient_address
    fa_contract
    token {
      token_id
      name
      fa { contract name }
    }
  }
}
"""

def build_where_extra(use_types, fa_contract, seller, token_tuple) -> str:
    parts=[]
    if use_types:
        parts.append("marketplace_event_type: { _in: $sale_types }")
    if fa_contract:
        parts.append("fa_contract: { _eq: $fa_contract }")
    if seller:
        parts.append("creator_address: { _eq: $seller }")   # nur Verkäufe deiner Wallet
    if token_tuple:
        parts.append("token: { fa_contract:{_eq:$token_contract}, token_id:{_eq:$token_id} }")
    return (",\n      ").join(parts)

def build_query(use_types, fa_contract, seller, token_tuple) -> str:
    return SALE_QUERY % {"where_extra": build_where_extra(use_types,fa_contract,seller,token_tuple)}

def _iso_utc(dt: datetime) -> str:
    return dt.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00","Z")

# -------- hübsche Tezos-Formatierung -----------------------------------------

def format_xtz(value: Any, max_decimals: int = 6) -> str:
    """
    Formatiert XTZ-Beträge „menschlich“:
    - Tausendertrennzeichen (schmales Leerzeichen)
    - bis zu max_decimals Nachkommastellen, ohne unnötige Nullen
    - Währungssymbol ꜩ
    """
    if value is None:
        return "—"
    try:
        v = float(value)
    except (TypeError, ValueError):
        return str(value)

    # auf feste Nachkommastellen runden, danach Nullen abschneiden
    s = f"{v:.{max_decimals}f}".rstrip("0").rstrip(".")
    # Tausendertrennzeichen im Ganzzahlteil einfügen
    if "." in s:
        ip, fp = s.split(".", 1)
    else:
        ip, fp = s, ""
    ip_grouped = f"{int(ip):,}".replace(",", " ")  # schmales geschütztes Leerzeichen
    if fp:
        s = f"{ip_grouped}.{fp}"
    else:
        s = ip_grouped
    return f"{s} ꜩ"

# -----------------------------------------------------------------------------

def pretty(ev: Dict[str,Any]) -> str:
    t=ev.get("timestamp"); ty=ev.get("marketplace_event_type")
    px=ev.get("price_xtz"); px_str = format_xtz(px)
    tok=ev.get("token") or {}; name=tok.get("name"); tid=tok.get("token_id"); fa=(tok.get("fa") or {}).get("contract")
    buyer=ev.get("recipient_address"); seller=ev.get("creator_address")
    return f"[{t}] {ty:22s} {px_str:>14}  {fa}#{tid} “{name}”  seller={seller} → buyer={buyer}"

def stream_sales(client:GQLClient, start_id:int, since:str, sale_types, fa_contract, seller, token_tuple, limit_per_page:int, poll_seconds:float, once:bool):
    cursor=int(start_id); query=build_query(sale_types,fa_contract,seller,token_tuple)
    def vars_for(cid:int): 
        v={"limit":int(limit_per_page),"cursor_id":cid,"since":since}
        if sale_types: v["sale_types"]=list(sale_types)
        if fa_contract: v["fa_contract"]=fa_contract
        if seller: v["seller"]=seller
        if token_tuple: v["token_contract"],v["token_id"]=token_tuple
        return v
    while True:
        data=client.query(query,vars_for(cursor))
        items=data.get("event",[])
        if items:
            for ev in items:
                cursor=int(ev["id"])
                yield ev
        if once: break
        if not items: time.sleep(poll_seconds)

def main():
    parser=argparse.ArgumentParser(description="Watch objkt.com sales (only my wallet as seller) with pretty XTZ output")
    parser.add_argument("--start-id",type=int,default=0)
    parser.add_argument("--limit",type=int,default=200)
    parser.add_argument("--poll",type=float,default=10.0)
    parser.add_argument("--fa"); parser.add_argument("--token")
    parser.add_argument("--types",help="comma-separated marketplace_event_type values")
    parser.add_argument("--since-hours",type=int,default=24)
    parser.add_argument("--since-iso")
    parser.add_argument("--once",action="store_true",help="fetch once and exit")
    parser.add_argument("--seller",required=True,help="wallet address (tz1/2/3...) that must be seller")
    args=parser.parse_args()

    token_tuple=None
    if args.token:
        kt1,tid=args.token.split(":",1); token_tuple=(kt1,tid)
    sale_types=tuple(s.strip() for s in args.types.split(",")) if args.types else DEFAULT_SALE_TYPES

    since=args.since_iso or _iso_utc(datetime.now(timezone.utc)-timedelta(hours=args.since_hours))
    client=GQLClient()
    print(f"Fetching sales (seller={args.seller}) since {since} … once={args.once}")
    for ev in stream_sales(client,args.start_id,since,sale_types,args.fa,args.seller,token_tuple,args.limit,args.poll,args.once):
        print(pretty(ev),flush=True)

if __name__=="__main__":
    signal.signal(signal.SIGINT,lambda *_: sys.exit(0))
    main()
