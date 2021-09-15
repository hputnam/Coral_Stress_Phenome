

## Test to make sure my script works

VCF=GVCFall_SNPs_VarScores_filterPASSED_DPfilterNoCall.vcf
OUT="SNPs_test"

## Original method
gatk VariantsToTable --reference "${REF}" --variant "${VCF}" --output "${OUT}.table" -F CHROM -F POS -F REF -F ALT -GF GT 1> "${OUT}.table.log" 2>&1
sed -e 's@|@/@g' "${OUT}.table" | grep -v '\./\.' | grep -v '*' | awk -F'\t' '$4!~","' | sed -e 's/\.GT//g' | cut -f1-2,5- > "${OUT}.NoMissingAlleles.table"
python $GFM/vcfTab_to_callsTab.py -i "${OUT}.NoMissingAlleles.table" -o "${OUT}.NoMissingAlleles.tab"
python $GFM/callsToFastaPhy_speed.py -i "${OUT}.NoMissingAlleles.tab" -f "${OUT}.NoMissingAlleles.fasta"
./expand_one-character_genotype_fasta.py -i "${OUT}.NoMissingAlleles.fasta" -o "${OUT}.NoMissingAlleles.expandedChar.fasta"

## My script
sed -e 's@|@/@g' "${OUT}.table" | grep -v '\./\.' | grep -v '*' | ./make_biallelic_fasta_from_variant_table.py > "${OUT}.myScript.fasta"

md5sum "${OUT}.NoMissingAlleles.expandedChar.fasta" "${OUT}.myScript.fasta"
# e399989ffd6fdc71d298e2aac2115c8a  SNPs_test.NoMissingAlleles.expandedChar.fasta
# e399989ffd6fdc71d298e2aac2115c8a  SNPs_test.myScript.fasta
## They are the same. Great!!

