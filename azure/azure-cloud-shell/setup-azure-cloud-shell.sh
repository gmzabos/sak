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

#########################################
# Setting up work environment
#########################################
if test -d "$BINDIR"; then
    echo "$BINDIR already exists - skip creation"
    else
    mkdir $BINDIR
fi

if test -d "$CODEDIR"; then
    echo "$CODEDIR already exists - skip creation"
    else
    mkdir $CODEDIR
fi

if test -f "$KUBECONF"; then
    echo "$KUBECONF already exists - skip creation"
    else
    mkdir ~/.kube
    touch $KUBECONF
fi

#########################################
# Setting up kubernetes tools
#########################################
cd $CODEDIR
git clone https://github.com/ahmetb/kubectx

if test -f $BINDIR/kubectx; then
    echo "$BINDIR/kubectx already exists - skip copy"
    else
    cd $CODEDIR/kubectx
    cp kubectx $BINDIR
fi

if test -f $BINDIR/kubens; then
    echo "$BINDIR/kubens already exists - skip copy"
    else
    cd $CODEDIR/kubectx
    cp kubens $BINDIR
fi

cd $CODEDIR
rm -rf kubectx

cd $BINDIR
wget https://github.com/derailed/k9s/releases/download/v0.26.3/k9s_Linux_x86_64.tar.gz
gunzip k9s_Linux_x86_64.tar.gz
tar xvf k9s_Linux_x86_64.tar
rm k9s_Linux_x86_64.tar