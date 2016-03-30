#!/bin/csh -f
#
#
# Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.  

# ---------------------------
# our name 
#$ -N MPI_Job
#
# pe request
#$ -pe mpi 2-8
#
# MPIR_HOME from submitting environment
#$ -v MPIR_HOME=/vol2/tools/mpi/mpich,SGE_QMASTER_PORT
# ---------------------------

#
# needs in 
#   $NSLOTS          
#       the number of tasks to be used
#   $TMPDIR/machines 
#       a valid machiche file to be passed to mpirun 

echo "Got $NSLOTS slots."

# enables $TMPDIR/rsh to catch rsh calls if available
set path=($TMPDIR $path)

( echo 100 ; echo 100 ) | $MPIR_HOME/lib/sun4/ch_p4/mpirun -np $NSLOTS -machinefile $TMPDIR/machines $MPIR_HOME/examples/contrib/life/life 
