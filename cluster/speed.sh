#!/usr/bin/bash
#
# gzabos	27.04.2016
#
# Simple script just wasting time on a compute cluster
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#

#########################################
# Set Variables
#########################################

#########################################
# Let#s waste some compute time
#########################################

echo -e "I am wasting compute time on host: `hostname`"
echo -e "Sleeping now: `date`"

openssl speed

echo -e "Wake up - now it is: `date`"
