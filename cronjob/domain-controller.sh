#!/usr/bin/bash
#
# gzabos        22.08.2016
#
# Checking the current MS AD domain controller on a linux box
#
# Prerequisites: yum install adcli
#

#########################################
# Set Variables
#########################################
DOMAIN="example.com"
FILE="dc-result.txt"
TIMES=2000
ZZZ=300
START=0
HOSTNAME=`hostname`
MAILRELAY='smtp=smtp://example.com'
CONTACTS='user@example.com'

#########################################
# Delete old result file, we don't need it
#########################################

rm -f $FILE

#########################################
# Read MS AD information
#########################################

echo -e "Start: `date`" > dc-result.txt

while [ $START -lt $TIMES ]; 
do
	adcli info $DOMAIN | grep -e 'domain-controller =' | gawk '{ print strftime("[%Y-%m-%d_%H:%M:%S]"), $3 }' >> $FILE
	let START=START+1
	sleep $ZZZ
done

echo -e "End: `date`" >> dc-result.txt

#########################################
# Send notification
#########################################

echo " " | mailx -a $FILE -s "*** ${HOSTNAME} MS AD DC check ***" -S $MAILRELAY $CONTACTS
