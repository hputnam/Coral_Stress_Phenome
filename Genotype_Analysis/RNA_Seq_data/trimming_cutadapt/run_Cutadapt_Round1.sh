#!/bin/bash
#SBATCH --partition=main 			# Partition (job queue) 
#SBATCH --no-requeue				# Do not re-run job if preempted
#SBATCH --export=ALL 				# Do not export current env to compute nodes
#SBATCH --nodes=1 				# Number of nodes 
#SBATCH --ntasks=1 				# Number of tasks (usually = cores) on each node
#SBATCH --cpus-per-task=4 			# Cores per task (>1 if multithread tasks)
#SBATCH --output=%x.slurm_out.%j-%2t.%a 	# STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=10G 				# Real memory (RAM) per node required (MB) 
#SBATCH --time=24:00:00 			# Total run time limit (HH:MM:SS) 
#SBATCH --job-name=MC_PA_TSDE_Cutadapt_Round1	# Replace with your jobname
#SBATCH --array=1-251				# Specify array range


#### Pre-run setup
#set -e
source ~/slurm_config/slurm_config
prerun_info # Print info
cd $SLURM_SUBMIT_DIR

module load python/3.5.2
PYTHON=`which python3`
CUTADAPT=~/.local/bin/cutadapt


#### Load list of commands/files into array
index=0
while read line ; do
	index=$(($index+1))
	filearray[$index]="$line"
done < prefixes4samples.txt

SAMPLE_PREFIX=${filearray[$SLURM_ARRAY_TASK_ID]}
echo "Sample Prefix: $SAMPLE_PREFIX"


#### Start Script
run_cmd "srun $PYTHON $CUTADAPT --nextseq-trim 10 --minimum-length 25 --cores $SLURM_CPUS_PER_TASK \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA \
-o ${SAMPLE_PREFIX}_R1_TrimmingRound1.fastq.gz -p ${SAMPLE_PREFIX}_R2_TrimmingRound1.fastq.gz \
${SAMPLE_PREFIX}_R1.fastq.gz ${SAMPLE_PREFIX}_R2.fastq.gz > ${SAMPLE_PREFIX}.cutadapt_round1.log 2>&1"



#### Post-run info
postrun_info # Print info


