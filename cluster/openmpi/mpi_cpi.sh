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
#$ -v MPIR_HOME
# ---------------------------

#
# needs in 
#   $NSLOTS          
#       the number of tasks to be used
#   $TMPDIR/machines 
#       a valid machine file to be passed to mpirun 

echo "Got $NSLOTS slots."

$MPIR_HOME/util/mpirun -np $NSLOTS -machinefile $TMPDIR/machines $MPIR_HOME/examples/basic/cpi
