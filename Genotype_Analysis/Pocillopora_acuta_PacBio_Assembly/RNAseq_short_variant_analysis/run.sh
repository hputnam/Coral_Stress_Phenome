

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
VARIANTS=""

gatk CreateSequenceDictionary -REFERENCE $REF -OUTPUT ${REF%*.*}.dict

## Combine *.g.vcf.gz files and call genotypes
for F in Pacuta_*.HaplotypeCaller.g.vcf.gz;
do
	VARIANTS="${VARIANTS} --variant $F"; 
done

# CombineGVCFs: ~9.6hrs
# GenotypeGVCFs: ~10.25hrs
gatk CombineGVCFs --reference "${REF}" --output "${OUT}.g.vcf.gz" ${VARIANTS} > ${OUT}.CombineGVCFs.log 2>&1
gatk --java-options "-Xmx4g" GenotypeGVCFs --reference "${REF}" --output "${OUT}.vcf.gz" -V "${OUT}.g.vcf.gz" -stand-call-conf 30 --annotation AS_MappingQualityRankSumTest --annotation AS_ReadPosRankSumTest > ${OUT}.GenotypeGVCFs.log 2>&1


