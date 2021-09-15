#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu


#### Start Script

## Function to align paired reads using HISAT2 and extract just the pairs (not unpaired or single reads) where both mates are unmapped. 
#
# samtools -f12 (extract reads that are unmapped and mate is unmapped; https://stackoverflow.com/questions/63157073/extracting-unmapped-reads-where-both-mates-are-unmapped-using-samtools)
# repair.sh 	(use this tool to split read pairs into seperate files. Have to use this becuase reformat.sh gives weird errors saying that the raids are not paired/interleaved correctly 
# 			[repair.sh however, does not find any problems with the input so unsure why reformat.sh does not work correctly])
map_using_hisat2() {
	LINE="$@"
        SAMPLE_ID=$(echo "$LINE" | awk '{print $2}')
        R1=$(echo "$LINE" | awk '{print $3}')
        R2=$(echo "$LINE" | awk '{print $4}')
        OUT="$SAMPLE_ID.HISAT2_RNAseq_mapping"
	
        # Print all info to log file
        exec 1> "${OUT}.log" 2>&1
	
	#### Pre-run setup
	source ~/scripts/script_setup.sh
	set +eu; conda activate py27; set -eu
	
	export PATH=$PATH:~/programs/hisat2-2.2.1
	export PATH=$PATH:~/programs/samtools-1.11/bin
	export PATH=$PATH:~/programs/bbmap
	
	export NCPUS=20
	export REF="Pocillopora_acuta_genome_v1.fasta"
	
	log "Running sample $SAMPLE_ID"
	run_cmd "hisat2 -q --phred33 --dta --rf --very-sensitive -x $REF -1 $R1 -2 $R2 --threads $NCPUS 2> $OUT.hisat2_mapping.stats | samtools sort -@ $NCPUS -T $OUT.tmp -o $OUT.coordSorted.bam -"
	run_cmd "samtools view -f12 $OUT.coordSorted.bam | repair.sh in=stdin.sam out=$OUT.coordSorted.unmapped_pairs_R1.fastq.gz out2=$OUT.coordSorted.unmapped_pairs_R2.fastq.gz outs=$OUT.coordSorted.unmapped_pairs_Single.fastq.gz"
	run_cmd "reformat.sh verifypaired=t in=$OUT.coordSorted.unmapped_pairs_R1.fastq.gz in2=$OUT.coordSorted.unmapped_pairs_R2.fastq.gz"
	log "Done mapping!"
}


export -f map_using_hisat2
parallel -j 4 map_using_hisat2 :::: samples_Pacuta.txt
log "Parallel finished with exit status: $?"



