### setup-azure-cloud-shell.sh
`setup-azure-cloud-shell.sh` sets up basic tools for k8s in your Azure Cloud Shell environment.

#### Installation
- Acess your Azure Cloud Shell environment
- `git clone https://github.com/gmzabos/sak.git`
- `cd sak/azure/azure-cloud-shell`
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