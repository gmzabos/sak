#!/bin/bash
#
# gzabos	22.02.2016
#
# Clear 'E' state of grindengine queue(s)
#

#########################################
# Set Variables
#########################################
QS='test.q'
HOST=`hostname | awk -F. '{print $1}'`
HOSTQ=`qstat -f | grep  .q@$HOST | awk -F@ '{print $1}'`
ERROR='E'
CHECK=$(qstat -f | grep -i $QS | awk '{ print $6 }')

#########################################
# Check queues for 'E' state
#########################################

if [ "$CHECK" = $ERROR ]
	then
		qmod -c $QS
		echo "-- E state cleared --"
	else
		echo "-- test.q OK --"
fi
