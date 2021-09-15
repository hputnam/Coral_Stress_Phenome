

export PATH="$PATH:/home/timothy/programs/gatk-4.2.0.0"
export PATH="$PATH:/home/timothy/programs/iqtree-1.6.12-Linux/bin"
GFM="/home/timothy/programs/genotype-files-manipulations"
NCPUS=24

REF="Pocillopora_acuta_HIv1.assembly.purged.fasta"

VCF="GVCFall_withOutGroup_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf"
OUT="SNPs_withOutGroup_filtered"

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











## Annotations
cp ../../../../phylogeny/annotations.txt .
echo -e "SRR414924\tIndonesia\t#4D5656\tIndonesia_2013\t#B2BABB\t2\t#01665e" >> annotations.txt
echo -e "SRR414925\tIndonesia\t#4D5656\tIndonesia_2013\t#B2BABB\t2\t#01665e" >> annotations.txt
echo -e "SRR988551\tIndonesia\t#4D5656\tIndonesia_2014\t#1B2631\t2\t#01665e" >> annotations.txt
echo -e "SRR988670\tIndonesia\t#4D5656\tIndonesia_2014\t#1B2631\t2\t#01665e" >> annotations.txt
echo -e "SRR988671\tIndonesia\t#4D5656\tIndonesia_2014\t#1B2631\t2\t#01665e" >> annotations.txt
echo -e "SRR988672\tIndonesia\t#4D5656\tIndonesia_2014\t#1B2631\t2\t#01665e" >> annotations.txt
#    1           2          3         4         5          6         7
# Sample.ID  Site.Name  Site.Color  Clade  Clade.Color  Ploidy  Ploidy.Color

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

## Color stripts above tips by "Ploidy"
awk -F'\t' '
   BEGIN{
      print "DATASET_COLORSTRIP\nSEPARATOR SPACE\nDATASET_LABEL Ploidy\nCOLOR #ff0000\nCOLOR_BRANCHES 0\nDATA"
   } {
      print $1" "$7" "$6
   }' annotations.txt \
 > annotations.iTOL.COLORSTRIP_Ploidy.txt




## Plotting using iTOL
#
# Bootstraps: Display - Text - Font:30px
# Position on branch:100%
# Dashed lines: 1px; Color: black




