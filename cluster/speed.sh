#!/usr/bin/bash
#
# gzabos	27.04.2016
#
# Simple script just wasting time on a compute cluster
#
#$ -cwd
#$ -j y
#$ -o speed.o
#$ -e speed.e
#$ -q test.q

#########################################
# Set Variables
#########################################

#########################################
# Let#s waste some compute time
#########################################

echo -e "[I] am wasting compute time on host: `hostname`"
echo -e "[S]tarting now: `date`"

/usr/bin/openssl speed

echo -e "[E]nded now: `date`"
