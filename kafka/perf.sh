#!/bin/bash
#
# gmzabos     17.01.2020
#
# Configure & run kafka-producer-perf-test

###################
# Set Variables
###################

TOPIC=""
RECORDNUM=""
RECORDSIZ=""
THROUGHPUT=""
CONFIG="perf.sh.properties"

###################
# Run perf test
###################

kafka-producer-perf-test --topic $TOPIC --num-records $RECORDNUM --producer.config $CONFIG --print-metrics --record-size $RECORDSIZ --throughput $THROUGHPUT
