

export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
OUT="GVCFall_withREF"


##
## AD analysis
##


## Get AD and GQ info from raw SNPs
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs.vcf.gz" --output "${OUT}_SNPs.AD_GQ.table" -F CHROM -F POS -GF GT -GF AD -GF DP -GF GQ \
        1> "${OUT}_SNPs.AD_GQ.table.log" 2>&1

while read i;
do
        GT=$(cut -f $i "${OUT}_SNPs.AD_GQ.table" | head -n 1)
        cut -f $i-$((i+3)) "${OUT}_SNPs.AD_GQ.table" | awk '$1 != "./." && $1 != ".|." {print $3}' > $GT.DP.txt
done < <(head -n 1 "${OUT}_SNPs.AD_GQ.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')

while read i;
do
        GT=$(cut -f $i "${OUT}_SNPs.AD_GQ.table" | head -n 1)
        cut -f $i-$((i+3)) "${OUT}_SNPs.AD_GQ.table" | awk '$1 != "./." && $1 != ".|." {print $4}' > $GT.GQ.txt
done < <(head -n 1 "${OUT}_SNPs.AD_GQ.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')


DP_MIN=20.000
Rscript plot_DP_scores.R "${OUT}_SNPs.DP" $DP_MIN 100 1> "${OUT}_SNPs.DP.log" 2>&1
mkdir "${OUT}_SNPs.DP"; mv *.GT.DP.txt "${OUT}_SNPs.DP/"


GQ_MIN=20.000
Rscript plot_GQ_scores.R "${OUT}_SNPs.GQ" $GQ_MIN 100 1> "${OUT}_SNPs.GQ.log" 2>&1
mkdir "${OUT}_SNPs.GQ"; mv *.GT.GQ.txt "${OUT}_SNPs.GQ/"



## Apply DP filtering (ignore GQ as it seems to filter out sites with minor alleles that have few aligned counts, which we are intereted in)
DP_MIN=20
gatk VariantFiltration --reference "${REF}" --variant "${OUT}_SNPs.vcf.gz" --output "${OUT}_SNPs_DPfilter.vcf" \
        --genotype-filter-name "DP_filter" --genotype-filter-expression "DP < $DP_MIN" \
        1> "${OUT}_SNPs_DPfilter.vcf.log" 2>&1

## Set filtered sites to no call
gatk SelectVariants --reference "${REF}" --variant "${OUT}_SNPs_DPfilter.vcf" --output "${OUT}_SNPs_DPfilterNoCall.vcf" --set-filtered-gt-to-nocall \
        1> "${OUT}_SNPs_DPfilterNoCall.vcf.log" 2>&1



## Get AD info
gatk VariantsToTable --reference "${REF}" --variant "${OUT}_SNPs_DPfilterNoCall.vcf" --output "${OUT}_SNPs_DPfilterNoCall.AD_GQ.table" -F CHROM -F POS -GF GT -GF AD -GF DP -GF GQ \
        1> "${OUT}_SNPs_DPfilterNoCall.AD_GQ.table.log" 2>&1


# Each sample has 3 columns (GT, AD, DP); get the GT column index for each sample first, extract idx - idx+2, filter using these two columns.
while read i;
do
        GT=$(cut -f $i "${OUT}_SNPs_DPfilterNoCall.AD_GQ.table" | head -n 1)
        cut -f $i-$((i+2)) "${OUT}_SNPs_DPfilterNoCall.AD_GQ.table" | awk '$1 != "./." && $1 != ".|." && $1 != "././." && $1 != ".|.|." { if(NR==1) {print $2} else {split($2,a,","); SUM=0; for (i in a) {SUM=SUM+a[i]}; if(SUM>0){for (i in a) {print a[i]/SUM}} } }' > $GT.AD.sumSDdenominator.txt
done < <(head -n 1 "${OUT}_SNPs_DPfilterNoCall.AD_GQ.table" | awk '{for (i=1; i<=NF; ++i) {if($i~".GT$") {print i}}}')

Rscript plot_AD_scores.sumSDdenominator.R "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator" 0.0 1.0 1> "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator.log" 2>&1
Rscript plot_AD_scores.sumSDdenominator.R "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator.XaxisLimits" 0.1 0.9 1> "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator.XaxisLimits.log" 2>&1

mkdir "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator"
mv *.GT.AD.sumSDdenominator.txt "${OUT}_SNPs_DPfilterNoCall.AD.sumSDdenominator/"


