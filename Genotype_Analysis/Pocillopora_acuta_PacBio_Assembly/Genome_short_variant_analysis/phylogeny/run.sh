

export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
export PATH="$PATH:/home/timothy/programs/iqtree-1.6.12-Linux/bin"
GFM="/home/timothy/programs/genotype-files-manipulations"
NCPUS=24

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"

VCF="GVCFall_withREF_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf"
OUT="SNPs_filtered"

# GTR - General time reversible model with unequal rates and unequal base freq.





## Tab to Fasta (remove variants where one or more samples have missing allele info)
gatk VariantsToTable --reference "${REF}" --variant "${VCF}" --output "${OUT}.table" -F CHROM -F POS -F REF -F ALT -GF GT 1> "${OUT}.table.log" 2>&1
sed -e 's@|@/@g' "${OUT}.table" | grep -v '\./\.' | grep -v '*' > "${OUT}.NoMissingAlleles.table"
./make_biallelic_fasta_from_variant_table.py -i "${OUT}.NoMissingAlleles.table" > "${OUT}.NoMissingAlleles.fasta"
# [INFO]: Total variants processed: 12888
# [INFO]: Biallelic variants processed: 12584
# [INFO]: Multiallelic variants ignored: 304

## Build SNP tree using non-ambiguous characters
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.fasta"

## Build tree using non-ambiguous characters - To use model GTR+ASC we have to first let iqtree remove invariant sites
## See Section 15.10 - page 155 - http://www.iqtree.org/doc/iqtree-doc.pdf
ln -s "${OUT}.NoMissingAlleles.fasta" "${OUT}.NoMissingAlleles.ASC.fasta"
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR+ASC -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.ASC.fasta"
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR+ASC -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.ASC.fasta.varsites.phy"








## Build tree using just intervals that overlap selected exons.
awk -F'\t' '$3=="exon" {print $1"\t"$4-1"\t"$5}' ../../braker_v1/braker_v1.gtf | ~/programs/bedtools-2.29.2/bin/bedtools sort | ~/programs/bedtools-2.29.2/bin/bedtools merge > exons.bed
gatk BedToIntervalList --INPUT exons.bed --OUTPUT exons.interval_list --SEQUENCE_DICTIONARY "${REF%*.fasta}.dict"
gatk SelectVariants --variant "${VCF}" --output "${OUT}.overlap_exons.vcf" --intervals exons.interval_list 1> "${OUT}.overlap_exons.vcf.log" 2>&1

gatk VariantsToTable --reference "${REF}" --variant "${OUT}.overlap_exons.vcf" --output "${OUT}.overlap_exons.table" -F CHROM -F POS -GF GT 1> "${OUT}.overlap_exons.table.log" 2>&1
sed -e 's@|@/@g' "${OUT}.overlap_exons.table" | grep -v '\./\.' | grep -v '*' | sed -e 's/\.GT//g' > "${OUT}.overlap_exons.NoMissingAlleles.table"
python $GFM/vcfTab_to_callsTab.py -i "${OUT}.overlap_exons.NoMissingAlleles.table" -o "${OUT}.overlap_exons.NoMissingAlleles.tab"
python $GFM/callsToFastaPhy_speed.py -i "${OUT}.overlap_exons.NoMissingAlleles.tab" -f "${OUT}.overlap_exons.NoMissingAlleles.fasta"
./expand_one-character_genotype_fasta.py -i "${OUT}.overlap_exons.NoMissingAlleles.fasta" -o "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.fasta"

iqtree -nt AUTO -ntmax $NCPUS -s "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.fasta" -st DNA -m GTR -bb 2000 -quiet
ln -s "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.fasta" "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.ASC.fasta"
iqtree -nt AUTO -ntmax $NCPUS -s "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.ASC.fasta" -st DNA -m GTR+ASC -bb 2000 -quiet
iqtree -nt AUTO -ntmax $NCPUS -s "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.ASC.fasta.varsites.phy" -st DNA -m GTR+ASC -bb 2000 -quiet








## Compare the different trees using Robinson-Foulds distance
cat "${OUT}.NoMissingAlleles.expandedChar.ASC.fasta.varsites.phy.contree" \
 "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.fasta.contree" \
 "${OUT}.overlap_exons.NoMissingAlleles.expandedChar.ASC.fasta.varsites.phy.contree" \
 > all.contree
iqtree -rf_all -t "${OUT}.NoMissingAlleles.expandedChar.fasta.contree" -rf all.contree
# 82 
# 176
# 172





## Cluster using SNPs from VCF file (skip having to make an alignment)
Rscript cluster_VCF.R "${VCF}.cluster" "${VCF}"





## Annotations
## Use same as for RNA-seq plots


## Plotting using iTOL
#
# Bootstraps: Display - Text - Font:30px
# Position on branch:100%
# Dashed lines: 1px; Color: black




