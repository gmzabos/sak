#!/bin/bash

for f in $( ls  /tmp/krb5cc* 2> /dev/null )
do
        OWNER=$( ls -l $f | awk '{print $3}' )
        GROUP=$( ls -l $f | awk '{print $4}' )
        EXPIRE=$( date -d "( klist -c $f | grep krbtgt | awk '{print $3, $4}' )" +%s )
        if [ $( expr $EXPIRE - $( date +%s ) ) -le 360 ]
        then
                kinit -R -c $f
                chown $OWNER:$GROUP $f
        fi
done
