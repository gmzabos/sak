#!/bin/sh
#
#
# Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.  

#
# preparation of the mpi machine file
#
# usage: startmpi.sh [options] <pe_hostfile>
#
#        options are: 
#                     -catch_hostname 
#                      force use of hostname wrapper in $TMPDIR when starting mpirun   
#                     -catch_rsh
#                      force use of rsh wrapper in $TMPDIR when starting mpirun   
#                     -unique
#                      generate a machinefile where each hostname appears only once
#                      This is needed to setup a multithreaded mpi application
#

PeHostfile2MachineFile()
{
   cat $1 | while read line; do
      # echo $line
      host=`echo $line|cut -f1 -d" "|cut -f1 -d"."`
      nslots=`echo $line|cut -f2 -d" "`
      i=1
      while [ $i -le $nslots ]; do
         # add here code to map regular hostnames into ATM hostnames
         echo $host
         i=`expr $i + 1`
      done
   done
}


#
# startup of MPI conforming with the Grid Engine
# Parallel Environment interface
#
# on success the job will find a machine-file in $TMPDIR/machines
# 

# useful to control parameters passed to us  
echo $*

# parse options
catch_rsh=0
catch_hostname=0
unique=0
while [ "$1" != "" ]; do
   case "$1" in
      -catch_rsh)
         catch_rsh=1
         ;;
      -catch_hostname)
         catch_hostname=1
         ;;
      -unique)
         unique=1
         ;;
      *)
         break;
         ;;
   esac
   shift
done

me=`basename $0`

# test number of args
if [ $# -ne 1 ]; then
   echo "$me: got wrong number of arguments" >&2
   exit 1
fi

# get arguments
pe_hostfile=$1

# ensure pe_hostfile is readable
if [ ! -r $pe_hostfile ]; then
   echo "$me: can't read $pe_hostfile" >&2
   exit 1
fi

# create machine-file
# remove column with number of slots per queue
# mpi does not support them in this form
machines="$TMPDIR/machines"

if [ $unique = 1 ]; then
   PeHostfile2MachineFile $pe_hostfile | uniq >> $machines
else
   PeHostfile2MachineFile $pe_hostfile >> $machines
fi

# trace machines file
cat $machines

#
# Make script wrapper for 'rsh' available in jobs tmp dir
#
if [ $catch_rsh = 1 ]; then
   rsh_wrapper=$SGE_ROOT/mpi/rsh
   if [ ! -x $rsh_wrapper ]; then
      echo "$me: can't execute $rsh_wrapper" >&2
      echo "     maybe it resides at a file system not available at this machine" >&2
      exit 1
   fi

   rshcmd=rsh
   case "$ARC" in
      hp|hp10|hp11|hp11-64) rshcmd=remsh ;;
      *) ;;
   esac
   # note: This could also be done using rcp, ftp or s.th.
   #       else. We use a symbolic link since it is the
   #       cheapest in case of a shared filesystem
   #
   ln -s $rsh_wrapper $TMPDIR/$rshcmd
fi

#
# Make script wrapper for 'hostname' available in jobs tmp dir
#
if [ $catch_hostname = 1 ]; then
   hostname_wrapper=$SGE_ROOT/mpi/hostname
   if [ ! -x $hostname_wrapper ]; then
      echo "$me: can't execute $hostname_wrapper" >&2
      echo "     maybe it resides at a file system not available at this machine" >&2
      exit 1
   fi

   # note: This could also be done using rcp, ftp or s.th.
   #       else. We use a symbolic link since it is the
   #       cheapest in case of a shared filesystem
   #
   ln -s $hostname_wrapper $TMPDIR/hostname
fi

# signal success to caller
exit 0
