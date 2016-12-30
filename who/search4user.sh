#!/usr/bin/bash
#
# gzabos        06.12.2016
#
# Checking if user is logged in on remote machine
#
# Prerequisites: one file, remote machines are listed one per line
#

#########################################
# Set Variables
#########################################
FILE=''
LOGINUSER=''

#########################################
# Looking for ...
#########################################
for HOST in `cat $FILE` 
do
  echo "Looking for *** $LOGINUSER *** on $HOST"
  ssh -l root $HOST "who | grep -i $LOGINUSER"
done

