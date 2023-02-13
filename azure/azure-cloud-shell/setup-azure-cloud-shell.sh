#!/usr/bin/bash
#
# gmzabos        14.09.2022
#
# Setup my favorite tools in Azure Cloud Shell
#
# Prerequisites: ---

#########################################
# Set Variables
#########################################
BINDIR=~/bin
CODEDIR=~/code
KUBECONF=~/.kube/config
K9SVERSION=v0.27.3
KOTSVERSION=v1.86.0

#########################################
# Setting up work environment
#########################################
if test -d "$BINDIR"; then
    echo "$BINDIR already exists - skip creation"
    else
    echo "Creating --- $BINDIR"
    mkdir $BINDIR
fi

if test -d "$CODEDIR"; then
    echo "$CODEDIR already exists - skip creation"
    else
    echo "Creating --- $CODEDIR"
    mkdir $CODEDIR
fi

if test -f "$KUBECONF"; then
    echo "$KUBECONF already exists - skip creation"
    else
    echo "Creating --- $KUBECONF"
    mkdir ~/.kube
    touch $KUBECONF
    chmod 600 $KUBECONF
fi

#########################################
# Setting up kubernetes tools
#########################################
cd $CODEDIR
git clone -q https://github.com/ahmetb/kubectx

if test -f $BINDIR/kubectx; then
    echo "$BINDIR/kubectx already exists - skip creation"
    else
    echo "Adding --- kubectx"
    cd $CODEDIR/kubectx
    cp kubectx $BINDIR
fi

if test -f $BINDIR/kubens; then
    echo "$BINDIR/kubens already exists - skip creation"
    else
    echo "Adding --- kubens"
    cd $CODEDIR/kubectx
    cp kubens $BINDIR
fi

cd $CODEDIR
rm -rf kubectx

if test -f $BINDIR/k9s; then
    echo "$BINDIR/k9s already exists - skip creation"
    else
    echo "Adding --- k9s"
    cd $BINDIR
    wget -q https://github.com/derailed/k9s/releases/download/$K9SVERSION/k9s_Linux_amd64.tar.gz
    gunzip k9s_Linux_amd64.tar.gz
    tar xf k9s_Linux_amd64.tar
    rm k9s_Linux_amd64.tar
fi

if test -f $BINDIR/kubectl-kots; then
    echo "$BINDIR/kubectl-kots already exists - skip creation"
    else
    echo "Adding --- kubectl-kots"
    cd $BINDIR
    wget -q https://github.com/replicatedhq/kots/releases/download/$KOTSVERSION/kots_linux_amd64.tar.gz
    gunzip kots_linux_amd64.tar.gz
    tar xf kots_linux_amd64.tar
    rm kots_linux_amd64.tar
fi
