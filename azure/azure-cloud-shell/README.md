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

#### Setting up .kube/config
The `~/.kube/config` file is the default file used by `kubectl` to store information of k8s clusters. (More on [kubeconfig files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/))

With Azure CLI k8s clusters can be easily added to your `~/.kube/config` using this syntax:
- `az aks get-credentials --resource-group <resource group> --name <cluster name>`

As an example, this might look like this:
- `az aks get-credentials --resource-group k8s-rg --name k8sakscluster`
