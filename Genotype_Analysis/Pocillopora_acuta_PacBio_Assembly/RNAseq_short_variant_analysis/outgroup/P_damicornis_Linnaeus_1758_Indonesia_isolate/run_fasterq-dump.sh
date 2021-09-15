#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu

export PATH="$PATH:/home/timothy/programs/sratoolkit.2.9.6-1-centos_linux64/bin"
export PATH="$PATH:/home/timothy/programs/bbmap"

SRR=$(cut -f1 SraRunInfo.txt)
OUTDIR="fastq"
NCPUS=6

#### Start Script
mkdir -p "$OUTDIR"
for ID in $SRR;
do
	run_cmd "fasterq-dump --outdir $OUTDIR --threads $NCPUS --split-3 --skip-technical --progress $ID" && \
	run_cmd "reformat.sh deleteinput=f verifypaired=t trimreaddescription=t addslash=t spaceslash=f in=$OUTDIR/${ID}_1.fastq in2=$OUTDIR/${ID}_2.fastq out=$OUTDIR/${ID}_R1.fastq.gz out2=$OUTDIR/${ID}_R2.fastq.gz"
done


