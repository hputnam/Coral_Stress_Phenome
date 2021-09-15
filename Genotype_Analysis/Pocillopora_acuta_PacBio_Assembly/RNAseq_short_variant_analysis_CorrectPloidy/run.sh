

## Link haplotype calls for diploid samples (dont need to rerun; diploid calling is default)
awk -F'\t' '$2=="2"{print $1}' annotations.Ploidy.txt \
 | while read F; 
   do 
	ln -s "../RNAseq_short_variant_analysis/$F.HaplotypeCaller.g.vcf.gz"; 
	ln -s "../RNAseq_short_variant_analysis/$F.HaplotypeCaller.g.vcf.gz.tbi"; 
   done

## Link processed reads calls for triploid samples (need to rerun; set --ploidy to 3 for haplotypecaller)
awk -F'\t' '$2=="3"{print $1}' annotations.Ploidy.txt \
 | while read F; 
   do 
	ln -s "../RNAseq_short_variant_analysis/$F.SplitNCigarReads.split.bam"; 
	ln -s "../RNAseq_short_variant_analysis/$F.SplitNCigarReads.split.bai"; 
   done

## Get just triploid sample info. 
~/scripts/grepf_column.py -c 2 -f <(awk -F'\t' '$2=="3"{print $1}' annotations.Ploidy.txt) -i ../RNAseq_short_variant_analysis/samples_Pacuta.txt > samples_Pacuta_Triploid.txt


export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
GFM="/home/timothy/programs/genotype-files-manipulations"

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"
OUT="GVCFall"
VARIANTS=""

## Combine *.g.vcf.gz files and call genotypes
for F in Pacuta_*.HaplotypeCaller.g.vcf.gz;
do
       	VARIANTS="${VARIANTS} --variant $F";
done

# CombineGVCFs: ~8.7hrs
# GenotypeGVCFs: ~13.24hrs
gatk CombineGVCFs --reference "${REF}" --output "${OUT}.g.vcf.gz" ${VARIANTS} > ${OUT}.CombineGVCFs.log 2>&1
gatk --java-options "-Xmx4g" GenotypeGVCFs --reference "${REF}" --output "${OUT}.vcf.gz" -V "${OUT}.g.vcf.gz" -stand-call-conf 30 --annotation AS_MappingQualityRankSumTest --annotation AS_ReadPosRankSumTest > ${OUT}.GenotypeGVCFs.log 2>&1





