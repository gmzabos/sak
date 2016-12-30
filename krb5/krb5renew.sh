#!/bin/bash
#
# gzabos        22.02.2016
#
# Renew krb5 ticket
#

#########################################
# Set Variables
#########################################

#########################################
#
#########################################

for i in $( ls  /tmp/krb5cc* 2> /dev/null )
do
        OWNER=$( ls -l $i | awk '{print $3}' )
        GROUP=$( ls -l $i | awk '{print $4}' )
        EXPIRE=$( date -d "( klist -c $i | grep krbtgt | awk '{print $3, $4}' )" +%s )
        if [ $( expr $EXPIRE - $( date +%s ) ) -le 360 ]
        then
                kinit -R -c $i
                chown $OWNER:$GROUP $i
        fi
done
