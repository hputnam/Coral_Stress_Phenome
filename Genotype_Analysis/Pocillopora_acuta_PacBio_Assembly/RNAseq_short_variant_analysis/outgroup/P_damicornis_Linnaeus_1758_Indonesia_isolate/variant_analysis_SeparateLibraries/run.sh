

SRR988672
@RG ID:HWI_2 PU:HWI_2 SM:SRR988672 LB:SRR988672 PL:illumina
gatk AddOrReplaceReadGroups -I SRR988672.FastqToSam.unmapped.bam -O SRR988672.FastqToSam.unmapped.rg.bam -RGID HWI_2 -RGPU HWI_2 -RGSM SRR988672 -RGLB SRR988672 -RGPL illumina


SRR988671
@RG ID:HWI_6 PU:HWI_6 SM:SRR988671 LB:SRR988671 PL:illumina
gatk AddOrReplaceReadGroups -I SRR988671.FastqToSam.unmapped.bam -O SRR988671.FastqToSam.unmapped.rg.bam -RGID HWI_6 -RGPU HWI_6 -RGSM SRR988671 -RGLB SRR988671 -RGPL illumina


SRR988670
@RG ID:HWI_7 PU:HWI_7 SM:SRR988670 LB:SRR988670 PL:illumina
gatk AddOrReplaceReadGroups -I SRR988670.FastqToSam.unmapped.bam -O SRR988670.FastqToSam.unmapped.rg.bam -RGID HWI_7 -RGPU HWI_7 -RGSM SRR988670 -RGLB SRR988670 -RGPL illumina


SRR988551
@RG ID:HWI_4 PU:HWI_4 SM:SRR988551 LB:SRR988551 PL:illumina
gatk AddOrReplaceReadGroups -I SRR988551.FastqToSam.unmapped.bam -O SRR988551.FastqToSam.unmapped.rg.bam -RGID HWI_4 -RGPU HWI_4 -RGSM SRR988551 -RGLB SRR988551 -RGPL illumina


SRR414925
@RG ID:Unknown_3 PU:Unknown_3 SM:SRR414925 LB:SRR414925 PL:illumina
gatk AddOrReplaceReadGroups -I SRR414925.FastqToSam.unmapped.bam -O SRR414925.FastqToSam.unmapped.rg.bam -RGID Unknown_3 -RGPU Unknown_3 -RGSM SRR414925 -RGLB SRR414925 -RGPL illumina


SRR414924
@RG ID:Unknown_5 PU:Unknown_5 SM:SRR414924 LB:SRR414924 PL:illumina
gatk AddOrReplaceReadGroups -I SRR414924.FastqToSam.unmapped.bam -O SRR414924.FastqToSam.unmapped.rg.bam -RGID Unknown_5 -RGPU Unknown_5 -RGSM SRR414924 -RGLB SRR414924 -RGPL illumina





export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
GFM="/home/timothy/programs/genotype-files-manipulations"

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
OUT="GVCFall_withOutGroup"
VARIANTS=""

## Combine *.g.vcf.gz files and call genotypes
for F in SRR*.HaplotypeCaller.g.vcf.gz;
do
        VARIANTS="${VARIANTS} --variant $F";
done
for F in ../../../Pacuta_*.HaplotypeCaller.g.vcf.gz;
do
        VARIANTS="${VARIANTS} --variant $F";
done

gatk CombineGVCFs --reference "${REF}" --output "${OUT}.g.vcf.gz" ${VARIANTS} > ${OUT}.CombineGVCFs.log 2>&1
gatk --java-options "-Xmx4g" GenotypeGVCFs --reference "${REF}" --output "${OUT}.vcf.gz" -V "${OUT}.g.vcf.gz" -stand-call-conf 30 --annotation AS_MappingQualityRankSumTest --annotation AS_ReadPosRankSumTest > ${OUT}.GenotypeGVCFs.log 2>&1





