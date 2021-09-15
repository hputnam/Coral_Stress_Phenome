#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu

export PATH="$PATH:/home/timothy/programs/ncbi-blast-2.10.1+/bin"

QUERY="Trinity.fasta"
DB="host_db/Host_DB.trans.fna"
OUT="$QUERY.blastn_HostDB.outfmt6"

NCPUS=24

#### Start Script
run_cmd "blastn -query $QUERY -db $DB -out $OUT -num_threads $NCPUS -outfmt \"6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen\""

