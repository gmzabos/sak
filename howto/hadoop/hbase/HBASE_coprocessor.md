# Howto: Remove coprocessor table attributes
Coprocessors like [Apache Phoenix](http://phoenix.apache.org/) can add extra functionality to your HBase installation. In this case the Apache Phoenix .jar file is added to the basic HBase installation path on every HBase RegionServer and is used for **fast** SQL like queries. (For more info on coprocessors, please check the [HBase documentation](http://hbase.apache.org/book.html#cp))

As soon as you create a table or a view with and active coprocessor this adds (extra) table attributes. At some point you might decide that you don't want to use the coprocessor any longer, but the extra table attributes are still there. If you setup a workflow where you use [ExportSnapshot](https://hbase.apache.org/apidocs/org/apache/hadoop/hbase/snapshot/ExportSnapshot.html) to move snapshots to another cluster, where this coprocessor isn't available, the import via ``clone_snapshot`` and/or ``restore_snapshot`` will fail. Another result is the table being 'stuck'.

This article describes how to get rid of a stuck table. This has been tested on HBase running from the Cloudera distribution version 5.16.1 & 6.3.4, but following this example should work on any other distribution.

## Deactivate HBase sanity checks which are ACTIVE by default
- Make an entry in the ``snippets for hbase-site.xml`` to set ``hbase.table.sanity.checks`` to ``false``
- Restart the HBase service
 
## Check & remove the extra table attributes from `hbase shell`
- Login to `hbase shell` as the **hbase** user
- the example uses a `DataCollection` table in the `Test` namespace
```
describe 'Test:DataCollection'
disable 'Test:DataCollection'
alter 'Test:DataCollection', METHOD => 'table_att_unset',NAME => 'coprocessor$1'
alter 'Test:DataCollection', METHOD => 'table_att_unset',NAME => 'coprocessor$2'
alter 'Test:DataCollection', METHOD => 'table_att_unset',NAME => 'coprocessor$3'
alter 'Test:DataCollection', METHOD => 'table_att_unset',NAME => 'coprocessor$4'
alter 'Test:DataCollection', METHOD => 'table_att_unset',NAME => 'coprocessor$5'
enable 'Test:DataCollection'
```
- from ``hbase shell`` check the table state
```
get 'hbase:meta', 'Test:DataCollection', 'table:state'
```
- possible table states:
```
\x08\x00 (Enabled)
\x08\x01 (Disabled)
\x08\x02 (Disabling)
\x08\x03 (Enabling)
```
- change the table state, ending up with a disabled table
```
put 'hbase:meta', 'Test:DataCollection', 'table:state',"\b\0"
put 'hbase:meta', 'Test:DataCollection', 'table:state',"\b\1"
```
- do a final check of the table state, it should be disabled
```
get 'hbase:meta', 'Test:DataCollection', 'table:state'
```

## Activate sanity checks, bringing it back to the default configuration
- Remove the entry in the ``snippets for hbase-site.xml`` to set ``hbase.table.sanity.checks`` back to default
- Restart the HBase service
 
## Drop the stuck table
- Login to the ``hbase shell`` as the **hbase** user
```
drop 'Test:DataCollection'
```
- check the HBase directory in HDFS if gone
```
hdfs dfs -ls /hbase/data/Test
```
- check the HBase znode in Zookeeper if gone
```
hbase zkcli
ls /hbase/table
```
- run ``hbase hbck`` and check if your tables are in ``Status: OK``
```
hbase hbck
```