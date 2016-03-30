#!/bin/sh
#
#
# Copyright (c) 2001, 2010, Oracle and/or its affiliates. All rights reserved.  

#
# shutdown of MPI conforming with the Grid Engine
# Parallel Environment interface
#
# Just remove machine-file that was written by startmpi.sh
#
rm $TMPDIR/machines

rshcmd=rsh
case "$ARC" in
   hp|hp10|hp11|hp11-64) rshcmd=remsh ;;
   *) ;;
esac
rm $TMPDIR/$rshcmd

exit 0
