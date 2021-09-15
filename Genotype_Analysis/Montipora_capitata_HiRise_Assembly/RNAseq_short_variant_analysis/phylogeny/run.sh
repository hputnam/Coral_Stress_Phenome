

export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
export PATH="$PATH:/home/timothy/programs/iqtree-1.6.12-Linux/bin"
GFM="/home/timothy/programs/genotype-files-manipulations"
NCPUS=24

REF="Montipora_capitata_HIv1.assembly.fasta"

VCF="GVCFall_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf"
OUT="SNPs_filtered"

# GTR - General time reversible model with unequal rates and unequal base freq.





## Tab to Fasta (remove variants where one or more samples have missing allele info)
gatk VariantsToTable --reference "${REF}" --variant "${VCF}" --output "${OUT}.table" -F CHROM -F POS -GF GT 1> "${OUT}.table.log" 2>&1
sed -e 's@|@/@g' "${OUT}.table" | grep -v '\./\.' | grep -v '*' | sed -e 's/\.GT//g' > "${OUT}.NoMissingAlleles.table"
python $GFM/vcfTab_to_callsTab.py -i "${OUT}.NoMissingAlleles.table" -o "${OUT}.NoMissingAlleles.tab"
python $GFM/callsToFastaPhy_speed.py -i "${OUT}.NoMissingAlleles.tab" -f "${OUT}.NoMissingAlleles.fasta"

## Ambiguous nt to ATGC characters
./expand_one-character_genotype_fasta.py -i "${OUT}.NoMissingAlleles.fasta" -o "${OUT}.NoMissingAlleles.expandedChar.fasta"

## Build SNP tree using non-ambiguous characters
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.expandedChar.fasta"

## Build tree using non-ambiguous characters - To use model GTR+ASC we have to first let iqtree remove invariant sites
## See Section 15.10 - page 155 - http://www.iqtree.org/doc/iqtree-doc.pdf
ln -s "${OUT}.NoMissingAlleles.expandedChar.fasta" "${OUT}.NoMissingAlleles.expandedChar.ASC.fasta"
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR+ASC -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.expandedChar.ASC.fasta"
iqtree -nt AUTO -ntmax $NCPUS -st DNA -m GTR+ASC -bb 2000 -quiet -s "${OUT}.NoMissingAlleles.expandedChar.ASC.fasta.varsites.phy"








## Build tree using just intervals that overlap selected exons.
awk -F'\t' '$3=="exon" {print $1"\t"$4-1"\t"$5}' ../../liftoff/Montipora_capitata_HIv1.genesNoCopies.gff3_polished | ~/programs/bedtools-2.29.2/bin/bedtools sort | ~/programs/bedtools-2.29.2/bin/bedtools merge > exons.bed
gatk BedToIntervalList --INPUT exons.bed --OUTPUT exons.interval_list --SEQUENCE_DICTIONARY "${REF%*.fasta}.dict" 1> exons.interval_list.log 2>&1
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
# 96
# 214
# 216







## Cluster using SNPs from VCF file (skip having to make an alignment)
Rscript cluster_VCF.R "${VCF}.cluster" "${VCF}"







## Annotations
#awk -F'\t' '$7=="Mcapitata" {print $2"\t"$4}' ../../../../../0009_Coral_Stress_Phenome/01_Data/Supplementary_Tables_S1-Samples.txt > annotations.SiteName.txt
#sed -i -e 's/ /_/g' -e 's/\.GT//' annotations.Clades.txt
cat annotations.SiteName.txt \
 | ./add_value_to_table.py -c 2 -a annotations.SiteNameColors.txt \
 | ./add_value_to_table.py -c 1 -a annotations.Clades.txt \
 | ./add_value_to_table.py -c 4 -a annotations.CladeColors.txt \
 > annotations.txt
#    1           2          3         4         5
# Sample.ID  Site.Name  Site.Color  Clade  Clade.Color 

## Color tips by "Clade"
awk -F'\t' '
   BEGIN{
      print "TREE_COLORS\nSEPARATOR SPACE\nDATA"
   } {
      print $1" label "$5
   }' annotations.txt \
 > annotations.iTOL.TREE_COLOR.txt

awk -F'\t' '
   BEGIN{
      print "TREE_COLORS\nSEPARATOR SPACE\nDATA"
   } {
      print $1" label_background "$5
   }' annotations.txt \
 > annotations.iTOL.TREE_COLOR_background.txt


## Color stripts above tips by "Site.Name"
awk -F'\t' '
   BEGIN{
      print "DATASET_COLORSTRIP\nSEPARATOR SPACE\nDATASET_LABEL Sample.Site\nCOLOR #ff0000\nCOLOR_BRANCHES 0\nDATA"
   } {
      print $1" "$3" "$2
   }' annotations.txt \
 > annotations.iTOL.COLORSTRIP_SiteName.txt









