#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu

export PATH=$PATH:/home/timothy/programs/samtools-1.11/bin
NCPUS=6

#### Start Script
SAM_FILES=$(awk -F'\t' '{printf " %s.HISAT2_RNAseq_mapping.coordSorted.bam", $2}' samples_Mcapitata.txt)
echo "Files to merge: $SAM_FILES"

run_cmd "samtools merge -@ $NCPUS -r All_combined.HISAT2_RNAseq_mapping.coordSorted.bam $SAM_FILES"
run_cmd "samtools index -@ $NCPUS All_combined.HISAT2_RNAseq_mapping.coordSorted.bam"


