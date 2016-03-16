#!/usr/bin/bash
#
# gzabos	16.03.2016
#
# Simple script just wasting time on a compute cluster
#
# Usage: sleeper.sh [time]]
#	 default for time is 60 seconds

#########################################
# Set Variables
#########################################
seconds=60

#########################################
# Let#s waste some compute time
#########################################

echo -e "I am wasting compute time on host: `hostname`"
echo -e "Sleeping now: `date`"

if [ $# -ge 1 ]; then
	seconds=$1
fi
sleep $seconds

echo -e "Wake up - now it is: `date`"
