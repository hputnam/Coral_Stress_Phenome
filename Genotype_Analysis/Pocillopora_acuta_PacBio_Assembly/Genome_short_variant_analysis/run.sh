

tar -zxvf 20210513.P2185.ccs.tar.gz

#gatk RevertSam --COMPRESSION_LEVEL 0 --SORT_ORDER queryname --INPUT P2185.ccs.bam --OUTPUT P2185.ccs.ReadNameSorted.bam --VALIDATION_STRINGENCY SILENT

#BAM="P2185.MergeBamAlignment.merged.bam"
#gatk HaplotypeCaller --reference ${REF} --input ${BAM} --output ${BAM}.HaplotypeCaller.g.vcf.gz -dont-use-soft-clipped-bases -ERC GVCF





export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
GFM="/home/timothy/programs/genotype-files-manipulations"

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
OUT="GVCFall_withREF"
VARIANTS=""

## Combine *.g.vcf.gz files and call genotypes
for F in "../RNAseq_short_variant_analysis_CorrectPloidy/GVCFall.g.vcf.gz" "P2185.HaplotypeCaller.g.vcf.gz";
do
	VARIANTS="${VARIANTS} --variant $F"; 
done

# CombineGVCFs: ~10.7hrs
# GenotypeGVCFs: ~24.4hrs
gatk CombineGVCFs --reference "${REF}" --output "${OUT}.g.vcf.gz" ${VARIANTS} > ${OUT}.CombineGVCFs.log 2>&1
gatk --java-options "-Xmx4g" GenotypeGVCFs --reference "${REF}" --output "${OUT}.vcf.gz" -V "${OUT}.g.vcf.gz" -stand-call-conf 30 --annotation AS_MappingQualityRankSumTest --annotation AS_ReadPosRankSumTest > ${OUT}.GenotypeGVCFs.log 2>&1



##
BAM="P2185.Minimap2.coordSorted.filtered.bam"
~/programs/samtools-1.11/bin/samtools depth -aa --reference "${REF}" "${BAM}" | gzip -c > "${BAM}.depth.gz"
zcat "${BAM}.depth.gz" | cut -f3 | sort | uniq -c | sort -k2,2n > "${BAM}.depth.histo.txt"





