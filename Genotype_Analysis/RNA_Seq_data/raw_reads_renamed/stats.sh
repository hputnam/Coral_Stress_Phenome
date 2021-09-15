#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu


#### Start Script
~/programs/bbmap/statswrapper.sh *.gz > read_stats.txt 2>&1


