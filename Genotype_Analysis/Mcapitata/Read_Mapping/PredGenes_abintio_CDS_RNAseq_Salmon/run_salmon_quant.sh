#!/bin/bash
#SBATCH --partition=main 			# Partition (job queue) 
#SBATCH --no-requeue				# Do not re-run job if preempted
#SBATCH --export=ALL 				# Export current environment variables to the launched application
#SBATCH --nodes=1 				# Number of nodes 
#SBATCH --ntasks=1 				# Number of tasks (usually = cores) on each node
#SBATCH --cpus-per-task=24 			# Cores per task (>1 if multithread tasks)
#SBATCH --output=%x.slurm_out.%j-%2t.%a 	# STDOUT output file (will also contain STDERR if --error is not specified)
#SBATCH --mem=24G 				# Real memory (RAM) per node required (MB) 
#SBATCH --time=72:00:00 			# Total run time limit (HH:MM:SS) 
#SBATCH --job-name=Salmon_quant			# Replace with your jobname


#### Pre-run setup
source ~/slurm_config/slurm_config
prerun_info # Print info
cd $SLURM_SUBMIT_DIR

module load samtools/1.8-gc563
export PATH=$PATH:~/PROGRAMS/salmon-1.1.0_linux_x86_64/bin

## Index info
TRANSCRIPTS=Mcap.mRNA.fa
KMER=31
TYPE="puff"
INDEX=$TRANSCRIPTS.salmon_$TYPE.$KMER.idx
## Read orientation
# I = inward
# S = stranded
# R = read 1 (or single-end read) comes from the reverse strand
LIB_TYPE="ISR"

# cat /scratch/ts942/DATABASES/genome_data/Montipora_capitata_Genome/databases/Mcap.genes.gff3 | awk -F'\t' '$3=="transcript" {print $9}' | sed -e 's/ID=//' -e 's/;geneID=/\t/' > trans2gene_mapping.txt
GENEMAP=trans2gene_mapping.txt

#### Start Script
while read LINE;
do
	R1=$(echo $LINE | awk '{print $3}')
	R2=$(echo $LINE | awk '{print $4}')
	OUTPUT=$(echo $LINE | awk '{print $2}')
	run_cmd "salmon quant --validateMappings --seqBias --gcBias --index $INDEX --libType $LIB_TYPE --geneMap $GENEMAP --mates1 $R1 --mates2 $R2 --output $OUTPUT --threads $SLURM_CPUS_PER_TASK"
done < samples_Mcapitata.txt

#### Post-run info
postrun_info # Print info


