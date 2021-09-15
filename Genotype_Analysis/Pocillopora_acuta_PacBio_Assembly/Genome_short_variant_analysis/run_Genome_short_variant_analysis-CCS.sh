#!/usr/bin/env bash

# Print all info to log file
exec 1> "${0}.log.$(date +%s)" 2>&1

#### Pre-run setup
source ~/scripts/script_setup.sh
set +eu; conda activate py27; set -eu

export PATH="$PATH:/home/timothy/programs/minimap2-2.20_x64-linux"
export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
export PATH="$PATH:/home/timothy/programs/rgsam/bin"
export PATH="$PATH:/home/timothy/programs/samtools-1.11/bin"
TMP_DIR="/scratch/timothy/tmp"

## INPUT:
##	- Fastq read files
##	- uBAM file of (unaligned) reads with read-group info added

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
NCPUS=36

OUT="P2185"
BAM="P2185.ccs.ReadNameSorted.bam"
R1="P2185.ccs.fastq"
#R2=""

# Workflow based on
# https://evodify.com/genomic-variant-calling-pipeline/
# https://evodify.com/gatk-in-non-model-organism/
#
# Plus:
# https://gatk.broadinstitute.org/hc/en-us/articles/360035535912-Data-pre-processing-for-variant-discovery



## 01 - Minimap2Align
# Align RNAseq reads to genome using Minimap2 aligner. 
# See: https://github.com/lh3/minimap2
#
# 4 for unmapped
# 256 for secondary alignment
# 260 = both unmapper or secondary alignments
#
log "Step 1 - Minimap2Align"
if [ ! -f "${OUT}.Minimap2.done" ];
then
	run_cmd "minimap2 -t ${NCPUS} -ayYL --MD --eqx -x map-hifi -R '@RG\\tID:510e6176\\tPL:PACBIO\\tDS:READTYPE=CCS;BINDINGKIT=101-789-500;SEQUENCINGKIT=101-826-100;BASECALLERVERSION=5.0.0;FRAMERATEHZ=100.000000\\tLB:P2185\\tPU:m64224e_210510_082903\\tSM:P2185\\tPM:SEQUELII\\tCM:S/P4-C2/5.0-8M' ${REF} ${R1} \
		| samtools view -b -F 260 - \
		| samtools sort -@ ${NCPUS} -T ${OUT}.tmp -o ${OUT}.Minimap2.coordSorted.bam -" && \
	run_cmd "samtools index ${OUT}.Minimap2.coordSorted.bam" && \
	run_cmd "touch ${OUT}.Minimap2.done"
else
	log "         - Already Fishied!"
fi
echo -e '\n\n\n\n\n'


## 01.5 - Filter aligned reads
# Remove reads with very long (>10 Kbp) inserts that causes HaplotypeCaller to fail without an error message.
# return: mapped reads, with valid CIGAR strings, and that have inserts < 10Kbp
log "Step 2 - FilterAlignedReads"
if [ ! -f "${OUT}.filter_bam.done" ];
then
	run_cmd "gatk FilterSamReads -I ${OUT}.Minimap2.coordSorted.bam -O ${OUT}.Minimap2.coordSorted.filtered.bam --JAVASCRIPT_FILE script.js --FILTER includeJavascript --CREATE_INDEX --COMPRESSION_LEVEL 0" && \
        run_cmd "touch ${OUT}.filter_bam.done"
else
        log "         - Already Fishied!"
fi
echo -e '\n\n\n\n\n'




## 08 - HaplotypeCaller
# Ignore flags:
#    -L ${interval_list}	Want to call variants from the whole genome
#    --dbsnp ${dbSNP_vcf}	Dont have a preexisting database of SNPs avaliable
#    --standard-min-confidence-threshold-for-calling 20		When running in '-ERC GVCF' mode, the confidence threshold is automatically set to 0.
#
# Assumes:
#	--sample-ploidy 2 (default)
#	--heterozygosity 0.001 (deafult; dont have prior info to update this with)
log "Step 3 - HaplotypeCaller"
if [ ! -f "${OUT}.HaplotypeCaller.done" ];
then
	run_cmd "gatk --java-options \"-Xmx320G -DGATK_STACKTRACE_ON_USER_EXCEPTION=true\" HaplotypeCaller \
		--reference ${REF} \
		--input ${OUT}.Minimap2.coordSorted.filtered.bam \
		--output ${OUT}.HaplotypeCaller.g.vcf.gz \
		-dont-use-soft-clipped-bases \
		-ERC GVCF \
		--sample-ploidy 3" && \
	run_cmd "touch ${OUT}.HaplotypeCaller.done"
else
	log "         - Already Fishied!"
fi
echo -e '\n\n\n\n\n'


echo -e "## Done running!"

