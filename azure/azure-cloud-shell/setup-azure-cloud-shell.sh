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
KUBECONF=~/.kube/conf
K9SVERSION=v0.26.3

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
fi

#########################################
# Setting up kubernetes tools
#########################################
cd $CODEDIR
git clone https://github.com/ahmetb/kubectx

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
    wget https://github.com/derailed/k9s/releases/download/$K9SVERSION/k9s_Linux_x86_64.tar.gz
    gunzip k9s_Linux_x86_64.tar.gz
    tar xvf k9s_Linux_x86_64.tar
    rm k9s_Linux_x86_64.tar
fi