### setup-azure-cloud-shell.sh
`setup-azure-cloud-shell.sh` sets up basic tools for k8s in your Azure Cloud Shell environment.

#### Installation
- `git clone https://github.com/TiGital-DigBB/azure-tools.git`
- `cd azure-tools`
- `chmod 700 setup-azure-cloud-shell.sh`
- `./setup-azure-cloud-shell.sh`

`setup-azure-cloud-shell.sh` will create:
- `~/bin` directory
- `~/code` directory
- `~/.kube/conf` file

`setup-azure-cloud-shell.sh` will install into `~/bin`:
- `kubens`
- `kubectx`
- `k9s`