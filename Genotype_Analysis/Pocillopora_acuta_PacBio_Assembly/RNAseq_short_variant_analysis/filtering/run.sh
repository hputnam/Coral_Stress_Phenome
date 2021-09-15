

## Workflow based off the "best practice" protocols from GATK
##
## Workflow based on:
## 	- Genomic variant calling pipeline:			https://evodify.com/genomic-variant-calling-pipeline/
## 	- Best practice for genotype calling in a non-model organism:	https://evodify.com/gatk-in-non-model-organism/
## 	- RNAseq short variant discovery (SNPs + Indels):	https://gatk.broadinstitute.org/hc/en-us/articles/360035531192?id=4067
## 	- GitHub example:					https://github.com/gatk-workflows/gatk4-rnaseq-germline-snps-indels/blob/master/gatk4-rna-best-practices.wdl



export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
GFM="/home/timothy/programs/genotype-files-manipulations"

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
OUT="GVCFall"


## Select SNPs and Indels
gatk SelectVariants --reference "${REF}" --variant "${OUT}.vcf.gz" --output "${OUT}_SNPs.vcf.gz"   -select-type SNP 1> "${OUT}_SNPs.vcf.gz.log" 2>&1
gatk SelectVariants --reference "${REF}" --variant "${OUT}.vcf.gz" --output "${OUT}_INDELs.vcf.gz" -select-type INDEL 1> "${OUT}_INDELs.vcf.gz.log" 2>&1

##
## Make diagnostic plots to assist filtering
##
##
## 1st-pass filtering
##
# Extract Variant Quality Scores and Plot
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs.vcf.gz"   --output "${OUT}_SNPs.table"   -F CHROM -F POS -F QUAL -F QD -F DP -F MQ -F FS -F SOR -F MQRankSum -F ReadPosRankSum 1> "${OUT}_SNPs.table.log" 2>&1
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_INDELs.vcf.gz" --output "${OUT}_INDELs.table" -F CHROM -F POS -F QUAL -F QD -F DP -F MQ -F FS -F SOR -F MQRankSum -F ReadPosRankSum 1> "${OUT}_INDELs.table.log" 2>&1

SNP_QD_MIN=20.000
SNP_MQ_MIN=50.000
SNP_FS_MAX=5.000
SNP_SOR_MAX=2.500

INDEL_QD_MIN=20.000
INDEL_MQ_MIN=45.000
INDEL_FS_MAX=5.000
INDEL_SOR_MAX=2.500

Rscript plot_variants_scores.R "${OUT}.variants_scores" "${OUT}_SNPs.table" "${OUT}_INDELs.table" \
	$SNP_QD_MIN $SNP_MQ_MIN $SNP_FS_MAX $SNP_SOR_MAX \
	$INDEL_QD_MIN $INDEL_MQ_MIN $INDEL_FS_MAX $INDEL_SOR_MAX \
	1> "${OUT}.variants_scores.log" 2>&1

# Plots:
#	QUAL - variant confidence QUAL score (based on all reads)
#	QD - variant confidence standardized by depth.
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360056968272-QualByDepth

# 	DP - *combined* depth per SNP across samples
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360057441391-DepthPerSampleHC
#		- Depth of informative reads supporting variance (i.e. reads that show strong and clear evidence of the variant)

#	MQ - mapping quality of a SNP.
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360057438331-RMSMappingQuality
#		- Overall mapping quality of reads supporting a variant call, averaged over all samples in a cohort.

#	FS - strand bias in support for REF vs ALT allele calls
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360056968392-FisherStrand
#		- The output is a Phred-scaled p-value. The higher the output value, the more likely there is to be bias. More bias is indicative of false positive calls.

#	SOR - sequencing bias in which one DNA strand is favored over the other 
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360056967852-AS-StrandOddsRatio
#		- Allele-specific strand bias estimated by the Symmetric Odds Ratio test.
 
#	MQRankSum - Rank sum test for mapping qualities of REF vs. ALT reads.
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360057439151-MappingQualityRankSumTest
#		- Compares the mapping qualities of the reads supporting the reference allele with those supporting the alternate allele

#	ReadPosRankSum - do all the reads support a SNP call tend to be near the end of a read.
#		- https://gatk.broadinstitute.org/hc/en-us/articles/360057439971-AS-ReadPosRankSumTest
#		- Allele-specific Rank Sum Test for relative positioning of REF versus ALT allele within reads.
#		- Tests whether there is evidence of bias in the position of alleles within the reads that support them, between the reference and each alternate allele. 

# Can't filter using 'MQRankSum' and 'ReadPosRankSum' becuase lots of variants have these values undefined

## Apply Variant filtering
# NOTE: 
#	- MQ seems to always be set to 60 for all variants. Makes filtering pointless.
# 	- Some (~100) variants will have missing QD variable and will "PASS" filtering even though they arent good veriants. Not a big problem as they will be filtered out in the next step.  
gatk VariantFiltration --reference "${REF}" --variant "${OUT}_SNPs.vcf.gz"   --output "${OUT}_SNPs_VarScores_filter.vcf.gz" \
	--filter-name "VarScores_filter_QD"  --filter-expression "QD < $SNP_QD_MIN" \
	--filter-name "VarScores_filter_MQ"  --filter-expression "MQ < $SNP_MQ_MIN" \
	--filter-name "VarScores_filter_FS"  --filter-expression "FS > $SNP_FS_MAX" \
	--filter-name "VarScores_filter_SOR" --filter-expression "SOR > $SNP_SOR_MAX" \
	1> "${OUT}_SNPs_VarScores_filter.vcf.gz.log" 2>&1

gatk VariantFiltration --reference "${REF}" --variant "${OUT}_INDELs.vcf.gz" --output "${OUT}_INDELs_VarScores_filter.vcf.gz" \
	--filter-name "VarScores_filter_QD"  --filter-expression "QD < $INDEL_QD_MIN" \
	--filter-name "VarScores_filter_MQ"  --filter-expression "MQ < $INDEL_MQ_MIN" \
	--filter-name "VarScores_filter_FS"  --filter-expression "FS > $INDEL_FS_MAX" \
	--filter-name "VarScores_filter_SOR" --filter-expression "SOR > $INDEL_SOR_MAX" \
	1> "${OUT}_INDELs_VarScores_filter.vcf.gz.log" 2>&1




## Check number PASSED after filtering
zcat "${OUT}_SNPs.vcf.gz" | grep -v '^#' | wc -l
# 7838506
zcat "${OUT}_SNPs_VarScores_filter.vcf.gz" | grep 'PASS' | wc -l
# 5174648 (66.02% remain after first-pass filtering)
zcat "${OUT}_INDELs.vcf.gz" | grep -v '^#' | wc -l
# 1063367
zcat "${OUT}_INDELs_VarScores_filter.vcf.gz" | grep 'PASS' | wc -l
# 586520 (55.16% remain after first-pass filtering)


## Extract only variants that PASSED filtering
zcat "${OUT}_SNPs_VarScores_filter.vcf.gz" | grep -E '^#|PASS' > "${OUT}_SNPs_VarScores_filterPASSED.vcf"
gatk IndexFeatureFile --input "${OUT}_SNPs_VarScores_filterPASSED.vcf" 1> "${OUT}_SNPs_VarScores_filterPASSED.vcf.log" 2>&1
zcat "${OUT}_INDELs_VarScores_filter.vcf.gz" | grep -E '^#|PASS' > "${OUT}_INDELs_VarScores_filterPASSED.vcf"
gatk IndexFeatureFile --input "${OUT}_INDELs_VarScores_filterPASSED.vcf" 1> "${OUT}_INDELs_VarScores_filterPASSED.vcf.log" 2>&1


## Check filtering worked (show that no variants are left below our threasholds)
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED.vcf"   --output "${OUT}_SNPs_VarScores_filterPASSED.table" \
	-F CHROM -F POS -F QUAL -F QD -F DP -F MQ -F FS -F SOR -F MQRankSum -F ReadPosRankSum \
	1> "${OUT}_SNPs_VarScores_filterPASSED.table.log" 2>&1
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_INDELs_VarScores_filterPASSED.vcf" --output "${OUT}_INDELs_VarScores_filterPASSED.table" \
	-F CHROM -F POS -F QUAL -F QD -F DP -F MQ -F FS -F SOR -F MQRankSum -F ReadPosRankSum \
	1> "${OUT}_INDELs_VarScores_filterPASSED.table.log" 2>&1
Rscript check_filtering.R "${OUT}_SNPs_VarScores_filterPASSED.table" "${OUT}_INDELs_VarScores_filterPASSED.table" \
        $SNP_QD_MIN $SNP_MQ_MIN $SNP_FS_MAX $SNP_SOR_MAX \
        $INDEL_QD_MIN $INDEL_MQ_MIN $INDEL_FS_MAX $INDEL_SOR_MAX \
	1> "${OUT}.check_filtering.log" 2>&1
Rscript plot_variants_scores.R "${OUT}.variants_scores_afterFiltering" "${OUT}_SNPs_VarScores_filterPASSED.table" "${OUT}_INDELs_VarScores_filterPASSED.table" \
        $SNP_QD_MIN $SNP_MQ_MIN $SNP_FS_MAX $SNP_SOR_MAX \
        $INDEL_QD_MIN $INDEL_MQ_MIN $INDEL_FS_MAX $INDEL_SOR_MAX \
	1> "${OUT}.variants_scores_afterFiltering.log" 2>&1






##
## 2nd-pass filtering
##

# Extract and plot DP info for each sample (from all samples before previous filtering; shows us overall variant coverage, independent of other factors)
gatk VariantsToTable --reference "${REF}" --variant "${OUT}.vcf.gz" --output "${OUT}.DP.table" -F CHROM -F POS -GF GT -GF DP 1> "${OUT}.DP.table.log" 2>&1

# Each sample has 2 columns (GT, DP); get the GT column index for each sample first, extract idx and idx+1, filter using these two columns.
while read i;
do
        GT=$(cut -f $i "${OUT}.DP.table" | head -n 1)
        cut -f $i,$((i+1)) "${OUT}.DP.table" | awk '$1 != "./." && $1 != ".|." {print $2}' > $GT.DP.txt
done < <(head -n 1 "${OUT}.DP.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')

DP_MIN=20.000
Rscript plot_DP_scores.R "${OUT}.DP" $DP_MIN 100 1> "${OUT}.DP.log" 2>&1

## Apply DP filtering
gatk VariantFiltration --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED.vcf"   --output "${OUT}_SNPs_VarScores_filterPASSED_DPfilter.vcf" \
	--genotype-filter-name "DP_filter" --genotype-filter-expression "DP < $DP_MIN" \
	1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilter.vcf.log" 2>&1

gatk VariantFiltration --reference "${REF}" --variant "${OUT}_INDELs_VarScores_filterPASSED.vcf" --output "${OUT}_INDELs_VarScores_filterPASSED_DPfilter.vcf" \
	--genotype-filter-name "DP_filter" --genotype-filter-expression "DP < $DP_MIN" \
	1> "${OUT}_INDELs_VarScores_filterPASSED_DPfilter.vcf.log" 2>&1

## Set filtered sites to no call
gatk SelectVariants --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED_DPfilter.vcf" --output "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf" --set-filtered-gt-to-nocall \
	1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf.log" 2>&1
gatk SelectVariants --reference "${REF}" --variant "${OUT}_INDELs_VarScores_filterPASSED_DPfilter.vcf" --output "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.vcf" --set-filtered-gt-to-nocall \
	1> "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.vcf.log" 2>&1



## Check number of variants that PASSED after filtering
for F in "${OUT}.DP"/*.GT.DP.txt; do awk 'NR>1' $F; done | wc -l
# 430694419
awk 'NR>1' "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.GT.DP.txt" | wc -l
# 69361
awk 'NR>1' "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.GT.DP.txt" | wc -l
# 4995



# Extract and plot DP info for each sample (combine it all together and plot; we dont care about each sample as we just want to check that filtering worked)
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf" --output "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.DP.table" -F CHROM -F POS -GF GT -GF DP \
	1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.DP.table.log" 2>&1
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.vcf" --output "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.DP.table" -F CHROM -F POS -GF GT -GF DP \
	1> "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.DP.table.log" 2>&1

while read i;
do
        cut -f $i,$((i+1)) "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.DP.table" | awk '$1 != "./." && $1 != ".|." {print $2}' > "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.GT.DP.txt"
done < <(head -n 1 "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.DP.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')
while read i;
do
        cut -f $i,$((i+1)) "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.DP.table" | awk '$1 != "./." && $1 != ".|." {print $2}' > "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.GT.DP.txt"
done < <(head -n 1 "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.DP.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')


DP_MIN=20.000
Rscript plot_DP_scores.R "${OUT}.DP.afterFiltering" $DP_MIN 100 1> "${OUT}.DP.afterFiltering.log" 2>&1






##
## 3nd-pass filtering
##
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf" --output "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" -F CHROM -F POS -GF GT -GF AD -GF DP \
	1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table.log" 2>&1

# Each sample has 3 columns (GT, AD, DP); get the GT column index for each sample first, extract idx - idx+2, filter using these two columns.
while read i;
do
        GT=$(cut -f $i "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | head -n 1)
        cut -f $i-$((i+2)) "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | awk '$1 != "./." && $1 != ".|." { if(NR==1) {print $2} else {split($2,a,","); for (i in a) {print a[i]/$3} } }' > $GT.AD.txt
done < <(head -n 1 "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')

Rscript plot_AD_scores.R "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD" 0.0 1.0 1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.log" 2>&1
Rscript plot_AD_scores.R "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.XaxisLimits" 0.1 0.9 1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.XaxisLimits.log" 2>&1

mkdir "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD"
mv *.GT.AD.txt "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD/"

## Generate allelic depth plots using sum(AD) as denominator instead of DP
while read i;
do
        GT=$(cut -f $i "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | head -n 1)
        cut -f $i-$((i+2)) "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | awk '$1 != "./." && $1 != ".|." { if(NR==1) {print $2} else {split($2,a,","); SUM=0; for (i in a) {SUM=SUM+a[i]}; if(SUM>0){for (i in a) {print a[i]/SUM}} } }' > $GT.AD.sumSDdenominator.txt
done < <(head -n 1 "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')

Rscript plot_AD_scores.sumSDdenominator.R "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator" 0.0 1.0 1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator.log" 2>&1
Rscript plot_AD_scores.sumSDdenominator.R "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator.XaxisLimits" 0.1 0.9 1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator.XaxisLimits.log" 2>&1

mkdir "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator"
mv *.GT.AD.sumSDdenominator.txt "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.AD.sumSDdenominator/"





## VCF to Table (use for phylogeny)
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf"   --output "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.table"   -F CHROM -F POS -GF GT \
	1> "${OUT}_SNPs_VarScores_filterPASSED_DPfilterNoCall.table.log" 2>&1
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.vcf" --output "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.table" -F CHROM -F POS -GF GT \
	1> "${OUT}_INDELs_VarScores_filterPASSED_DPfilterNoCall.table.log" 2>&1






