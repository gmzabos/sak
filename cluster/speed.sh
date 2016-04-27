#!/usr/bin/bash
#
# gzabos	27.04.2016
#
# Simple script just wasting time on a compute cluster
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -o speed.o
#$ -e speed.e

#########################################
# Set Variables
#########################################

#########################################
# Let#s waste some compute time
#########################################

echo -e "I am wasting compute time on host: `hostname`"
echo -e "Start: `date`"

openssl speed

echo -e "End: `date`"
