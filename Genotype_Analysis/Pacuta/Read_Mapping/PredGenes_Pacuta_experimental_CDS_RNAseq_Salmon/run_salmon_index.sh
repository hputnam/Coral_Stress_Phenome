#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu


export PATH=$PATH:~/programs/salmon-1.1.0_linux_x86_64/bin
NCPUS=12

TRANSCRIPTS="Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna"
KMER=31
TYPE="puff"
INDEX="$TRANSCRIPTS.salmon_$TYPE.$KMER.idx"

#### Start Script
run_cmd "salmon index --transcripts $TRANSCRIPTS --index $INDEX --kmerLen $KMER --threads $NCPUS"


