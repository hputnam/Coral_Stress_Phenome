#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py38; set -eu


export TRINITY_HOME=/home/timothy/programs/trinityrnaseq-v2.11.0
export PATH=$PATH:$TRINITY_HOME
export PATH=$PATH:/home/timothy/programs/bowtie2-2.3.5.1-linux-x86_64
export PATH=$PATH:/home/timothy/programs/jellyfish-2.3.0/bin
export PATH=$PATH:~/programs/salmon-1.1.0_linux_x86_64/bin
export PATH=$PATH:~/programs/samtools-1.11/bin
NCPUS=48


#### Start Script
run_cmd "Trinity --seqType fq --max_memory 400G --samples_file samples.txt --SS_lib_type RF --CPU $NCPUS"


