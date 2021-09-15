#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu

SAMPLES="samples_10TP_data.txt"
REF="Montipora_capitata_HIv1.assembly.fasta"
STAR_DB="../databases/STAR"
NCPUS=8
NPARALLEL=10

RNAseq_short_variant_analysis() {
	export PATH="$PATH:/home/timothy/programs/STAR-2.7.8a/bin/Linux_x86_64_static"
	export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
	export PATH="$PATH:/home/timothy/programs/rgsam/bin"
	export PATH="$PATH:/home/timothy/programs/samtools-1.11/bin"
	
	NCPUS="${1}"; shift
	REF="${1}"; shift
	STAR_DB="${1}"; shift
	SAMPLE="${1}"; shift
	
	OUT=$(echo "$SAMPLE" | awk -F'\t' '{print $2}')
	R1=$(echo "$SAMPLE"  | awk -F'\t' '{print $3}')
	R2=$(echo "$SAMPLE"  | awk -F'\t' '{print $4}')
	
	exec 1> "${OUT}.log.$(date +%s)" 2>&1
	
	# Workflow based on
	# https://evodify.com/genomic-variant-calling-pipeline/
	# https://evodify.com/gatk-in-non-model-organism/
	
	
	
	## 01 - StarAlign
	# Align RNAseq reads to genome using STAR aligner. 
	# Use the 2-pass mode becuase it can make the exon-intron junctions slightly more accurate. 
	# See: https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf
	log "Step 1 - StarAlign"
	if [ ! -f "${OUT}.STAR.done" ];
	then
		run_cmd "STAR \
			--genomeDir ${STAR_DB} \
			--runThreadN ${NCPUS} \
			--readFilesIn ${R1} ${R2} \
			--readFilesCommand \"gunzip -c\" \
			--sjdbOverhang 149 \
			--outSAMtype BAM SortedByCoordinate \
			--twopassMode Basic \
			--outFileNamePrefix ${OUT}.STAR." && \
		run_cmd "touch ${OUT}.STAR.done"
	else
		log "         - Already Fishied!"
	fi
	echo -e '\n\n\n\n\n'
	
	
	
	## 02 - FastqToSam + collect_RG + MergeBamAlignment
	# Need to add read group info to aligned reads + run the MergeBamAlignment command.
	# The MergeBamAlignment is technically not required if we can add read groups another way but it also 
	# filters the alinged read (e.g. removes secondary alignments) so would be hard to replicate this step
	# exactly using other tools (i.e. easier to to just use it then replace it).
	
	# Convert paired-fastq to BAM file (sorted by read name); no read group info added yet.
	log "Step 2.1 - FastqToSam"
	if [ ! -f "${OUT}.FastqToSam.done" ];
	then
		run_cmd "gatk FastqToSam \
				--FASTQ ${R1} \
				--FASTQ2 ${R2} \
				--OUTPUT ${OUT}.FastqToSam.unmapped.bam \
				--SAMPLE_NAME ${OUT}" && \
		run_cmd "touch ${OUT}.FastqToSam.done"
	else
		log "         - Already Fishied!"
	fi
	
	# Extract read group info for read names then annotate unaligned bam file with this read group info.
	# See: https://github.com/djhshih/rgsam
	log "Step 2.2 - collect_RG"
        if [ ! -f "${OUT}.collect_RG.done" ];
        then
                run_cmd "samtools view ${OUT}.FastqToSam.unmapped.bam \
				| rgsam collect --format sam --qnformat illumina-1.8 -s ${OUT} -o ${OUT}.collect_RG.txt" && \
		run_cmd "samtools view -h ${OUT}.FastqToSam.unmapped.bam \
				| rgsam tag --qnformat illumina-1.8 -r ${OUT}.collect_RG.txt \
				| samtools view -b - \
				> ${OUT}.FastqToSam.unmapped.rg.bam" && \
		run_cmd "touch ${OUT}.collect_RG.done"
        else
                log "         - Already Fishied!"
        fi
	
	# Merge unalinged bam file (now with read group info) with aligned bam file (read group info from unalinged bam is transfered to aligned bam).
	log "Step 2.3 - MergeBamAlignment"
	if [ ! -f "${OUT}.MergeBamAlignment.done" ];
        then
                run_cmd "gatk MergeBamAlignment \
					--REFERENCE_SEQUENCE ${REF} \
					--UNMAPPED_BAM ${OUT}.FastqToSam.unmapped.rg.bam \
					--ALIGNED_BAM ${OUT}.STAR.Aligned.sortedByCoord.out.bam \
					--OUTPUT ${OUT}.MergeBamAlignment.merged.bam \
					--INCLUDE_SECONDARY_ALIGNMENTS false \
					--VALIDATION_STRINGENCY SILENT" && \
		run_cmd "touch ${OUT}.MergeBamAlignment.done"
        else
                log "         - Already Fishied!"
        fi
	echo -e '\n\n\n\n\n'
	
	
	
	## 03 - MarkDuplicates
	log "Step 3 - MarkDuplicates"
	if [ ! -f "${OUT}.MarkDuplicates.done" ];
	then
		run_cmd "gatk MarkDuplicates \
					--INPUT ${OUT}.MergeBamAlignment.merged.bam \
					--OUTPUT ${OUT}.MarkDuplicates.dedupped.bam \
					--CREATE_INDEX true \
					--VALIDATION_STRINGENCY SILENT \
					--METRICS_FILE ${OUT}.MarkDuplicates.metrics" && \
		run_cmd "touch ${OUT}.MarkDuplicates.done"
	else
		log "         - Already Fishied!"
	fi
	echo -e '\n\n\n\n\n'
	
	
	
	## 04 - SplitNCigarReads
	log "Step 4 - SplitNCigarReads"
	if [ ! -f "${OUT}.SplitNCigarReads.done" ];
	then
		run_cmd "gatk SplitNCigarReads \
					-R ${REF} \
					-I ${OUT}.MarkDuplicates.dedupped.bam \
					-O ${OUT}.SplitNCigarReads.split.bam" && \
		run_cmd "touch ${OUT}.SplitNCigarReads.done"
	else
		log "         - Already Fishied!"
	fi
	echo -e '\n\n\n\n\n'
	
	
	
	# Steps 5 & 6 are part of the GATK "Best Practices" guide but can't really be undertaken with non-model genomes.
	# These steps require "known sites", i.e. sites where we known beforehand that SNP/indels occure.
	# This information isnt avaliable for non-model systems and since this is required (as sites not in this list 
	# are considered putative errors that need to be corrected) they have to be skipped. 
	
	## 05 - BaseRecalibrator
	#log "Step 5 - BaseRecalibrator"
	#if [ ! -f "${OUT}.BaseRecalibrator.done" ];
	#then
	#	run_cmd "gatk BaseRecalibrator \
	#				--reference ${REF} \
	#				--input ${OUT}.SplitNCigarReads.split.bam \
	#				--known-sites ${KNOWN_SITES} \
	#				--use-original-qualities \
	#				--output ${OUT}.BaseRecalibrator.recal_data.csv" && \
	#	run_cmd "touch ${OUT}.BaseRecalibrator.done"
	#else
	#	log "         - Already Fishied!"
	#fi
	#echo -e '\n\n\n\n\n'
	
	
	
	## 06 - ApplyBQSR
	#log "Step 6 - ApplyBQSR"
	#if [ ! -f "${OUT}.ApplyBQSR.done" ];
	#then
	#	run_cmd "gatk ApplyBQSR \
	#				--add-output-sam-program-record 
	#				--reference ${REF} \
	#				--input ${OUT}.SplitNCigarReads.split.bam \
	#				--output ${OUT}.aligned.duplicates_marked.recalibrated.bam \
	#				--use-original-qualities \
	#				--bqsr-recal-file ${OUT}.BaseRecalibrator.recal_data.csv" && \
	#	run_cmd "touch ${OUT}.ApplyBQSR.done"
	#else
	#	log "         - Already Fishied!"
	#fi
	#echo -e '\n\n\n\n\n'
	
	
	
	## 07 - ScatterIntervalList
	#
	# In this step they took a precomputed interval list (function gtfToCallingIntervals) and 
	# split it into x parts so they could run the HaplotypeCaller step in parallel. 
	# In our case, we wont be using an interval list and will just be running HaplotypeCaller as a single job. 
	#
	#log "Step 7 - IntervalList"
        #if [ ! -f "${OUT}.ScatterIntervalList.done" ];
        #then
        #        run_cmd "gatk BedToIntervalList  \
	#			--INPUT ${BED} \
	#			--OUTPUT ${OUT}.IntervalList.txt \
	#			--SEQUENCE_DICTIONARY ${REF_DICT}" && \
        #        run_cmd "touch ${OUT}.ScatterIntervalList.done"
        #else
        #        log "         - Already Fishied!"
        #fi
        #echo -e '\n\n\n\n\n'
	
	
	
	## 08 - HaplotypeCaller
	# Ignore flags:
	#    -L ${interval_list}	Want to call variants from the whole genome
	#    --dbsnp ${dbSNP_vcf}	Dont have a preexisting database of SNPs avaliable
	#    --standard-min-confidence-threshold-for-calling 20		When running in '-ERC GVCF' mode, the confidence threshold is automatically set to 0.
	#
	# Assumes:
	#	--sample-ploidy 2 (default)
	#	--heterozygosity 0.001 (deafult; dont have prior info to update this with)
	log "Step 5 - HaplotypeCaller"
	if [ ! -f "${OUT}.HaplotypeCaller.done" ];
	then
		run_cmd "gatk HaplotypeCaller \
			--reference ${REF} \
			--input ${OUT}.SplitNCigarReads.split.bam \
			--output ${OUT}.HaplotypeCaller.g.vcf.gz \
			-dont-use-soft-clipped-bases \
			-ERC GVCF" && \
		run_cmd "touch ${OUT}.HaplotypeCaller.done"
	else
		log "         - Already Fishied!"
	fi
	echo -e '\n\n\n\n\n'
	
	
	
	## 09 - MergeVCFs
	# Dont need becuase we are dont run HaplotypeCaller in parallel
	#log "Step 9 - MergeVCFs"
        #if [ ! -f "${OUT}.MergeVCFs.done" ];
        #then
        #        run_cmd "gatk MergeVCFs \
	#			--INPUT *input_vcfs* \
	#			--OUTPUT All_combined.vcf.gz" && \
        #        run_cmd "touch ${OUT}.MergeVCFs.done"
        #else
        #        log "         - Already Fishied!"
        #fi
        #echo -e '\n\n\n\n\n'
	
	
	
	## 10 - VariantFiltration
	# Done run this step in this script. 
	# We will merge the results of HaplotypeCaller using GenotypeGVCFs into a combined file.
	# We can them filter that file however we want.
	# 
	#log "Step 10 - VariantFiltration"
        #if [ ! -f "${OUT}.VariantFiltration.done" ];
        #then
        #        run_cmd "gatk VariantFiltration \
	#			--R ${REF} \
	#			--V ${input_vcf} \
	#			--window 35 \
	#			--cluster 3 \
	#			--filter-name "FS" \
	#			--filter "FS > 30.0" \
	#			--filter-name "QD" \
	#			--filter "QD < 2.0" \
	#			-O ${OUT}.variant_filtered.vcf.gz" && \
        #        run_cmd "touch ${OUT}.VariantFiltration.done"
        #else
        #        log "         - Already Fishied!"
        #fi
        #echo -e '\n\n\n\n\n'
}


export -f RNAseq_short_variant_analysis
parallel -j $NPARALLEL RNAseq_short_variant_analysis "$NCPUS" "$REF" "$STAR_DB" :::: "$SAMPLES"
log "Parallel finished with exit status: $?"

echo -e "## Done running!"

