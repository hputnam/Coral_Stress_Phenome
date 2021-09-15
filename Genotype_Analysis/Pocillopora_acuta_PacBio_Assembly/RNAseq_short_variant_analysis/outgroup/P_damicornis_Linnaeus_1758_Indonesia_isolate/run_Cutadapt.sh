#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate cutadapt29; set -eu

SRR=$(cut -f1 SraRunInfo.txt)
INDIR="fastq"
OUTDIR="trimmed"
NCPUS=24

#### Start Script
# Same as for 10TP samples but swapped --nextseq-trim for -q
# Adapter (PE_Adapt2: ACACTCTTTCCCTACACGACGCTCTTCCGATCT) retrieved from 10.1007/978-1-62703-122-6_1
mkdir -p "$OUTDIR"
for ID in $SRR;
do
	run_cmd "cutadapt -q 10 --minimum-length 25 --cores $NCPUS -a GATCGGAAGAGCGGTTCAGCAGGAATGCCGAG -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA -o ${OUTDIR}/${ID}_R1_Trimmed.fastq.gz -p ${OUTDIR}/${ID}_R2_Trimmed.fastq.gz ${INDIR}/${ID}_R1.fastq.gz ${INDIR}/${ID}_R2.fastq.gz > ${INDIR}/${ID}.cutadapt.log 2>&1"
done



