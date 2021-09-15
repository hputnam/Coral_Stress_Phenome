
export PATH="$PATH:/home/timothy/programs/nQuire_ret20210707"
cut -f2 ../RNAseq_short_variant_analysis/samples_Pacuta.txt > sample_prefixes.txt
echo "P2185" >> sample_prefixes.txt

## Step 01
while read F;
do
run_cmd "nQuire create -q 20 -c 20 -x -b $F.bam -o $F"
done < sample_prefixes.txt 1> nQuire_01_create.log 2>&1

while read F;
do
run_cmd "nQuire create -q 20 -c 20 -x -b $F.bam -o $F"
done < sample_prefixes_extra_Pamicornis.txt 1> nQuire_01_create_extra_Pamicornis.log 2>&1



## Step 02
while read F;
do
run_cmd "nQuire denoise -o $F.denoise $F.bin 1> $F.denoise.log"
done < sample_prefixes.txt 1> nQuire_02_denoise.log 2>&1

while read F;
do
run_cmd "nQuire denoise -o $F.denoise $F.bin 1> $F.denoise.log"
done < sample_prefixes_extra_Pamicornis.txt 1> nQuire_02_denoise_extra_Pamicornis.log 2>&1



## Step 03
nQuire lrdmodel -t 24 *.bin > nQuire_03_lrdmodel.log



## Step 04
while read F;
do
run_cmd "nQuire histotest $F.bin 1> $F.histotest"
run_cmd "nQuire histotest $F.denoise.bin 1> $F.denoise.histotest"
done < sample_prefixes.txt 1> nQuire_04_histotest.log 2>&1

while read F;
do
run_cmd "nQuire histotest $F.bin 1> $F.histotest"
run_cmd "nQuire histotest $F.denoise.bin 1> $F.denoise.histotest"
done < sample_prefixes_extra_Pamicornis.txt 1> nQuire_04_histotest_extra_Pamicornis.log 2>&1




cat ../RNAseq_short_variant_analysis/phylogeny/annotations.Ploidy.txt \
 | sed -e 's/\([^_]*\)_\([^_]*\)_TP\([^_]*\)_\([^_]*\)\t.*/\0\t\1\t\2\t\3\t\4/' \
 | sort -k2,2n -k4,4 -k5,5n -k6,6n | cut -f1-2 \
 > sample_order_by_ploidy.txt


F="delta_log-likelihood"
awk -F'\t' 'BEGIN{print "Name\tLogLikelihood\tPloidy"} NR>1 && $1!~"denoise" {print $1"\t"$6"\tDiploid"; print $1"\t"$7"\tTriploid"; print $1"\t"$8"\tTetraploid"}' nQuire_03_lrdmodel.log \
 | sed -e 's/.bin//' > $F.txt


./grepf_column.py -i $F.txt -o $F.10TP.txt -f <(awk -F'\t' 'BEGIN{print "Name"} {print $1}' sample_order_by_ploidy.txt)
./grepf_column.py -i $F.txt -o $F.extraPamicornis.txt -f <(awk -F'\t' 'BEGIN{print "Name"} {print $1}' sample_prefixes_extra_Pamicornis.txt)
./grepf_column.py -i $F.txt -o $F.REF.txt -f <(echo -e "Name\nP2185")

Rscript plot_nQuire_delta_loglikelihood.R $F.10TP.txt $F.10TPtxt.plot.pdf <(awk -F'\t' '{print $1}' sample_order_by_ploidy.txt)
Rscript plot_nQuire_delta_loglikelihood.R $F.extraPamicornis.txt $F.extraPamicornis.txt.plot.pdf <(awk -F'\t' '{print $1}' sample_prefixes_extra_Pamicornis.txt)
Rscript plot_nQuire_delta_loglikelihood.R $F.REF.txt $F.REF.txt.plot.pdf



F="delta_log-likelihood.denoise"
awk -F'\t' 'BEGIN{print "Name\tLogLikelihood\tPloidy"} NR>1 && $1~"denoise" {print $1"\t"$6"\tDiploid"; print $1"\t"$7"\tTriploid"; print $1"\t"$8"\tTetraploid"}' nQuire_03_lrdmodel.log \
 | sed -e 's/.denoise.bin//' > $F.txt

./grepf_column.py -i $F.txt -o $F.10TP.txt -f <(awk -F'\t' 'BEGIN{print "Name"} {print $1}' sample_order_by_ploidy.txt)
./grepf_column.py -i $F.txt -o $F.extraPamicornis.txt -f <(awk -F'\t' 'BEGIN{print "Name"} {print $1}' sample_prefixes_extra_Pamicornis.txt)
./grepf_column.py -i $F.txt -o $F.REF.txt -f <(echo -e "Name\nP2185")

Rscript plot_nQuire_delta_loglikelihood.R $F.10TP.txt $F.10TP.txt.plot.pdf <(awk -F'\t' '{print $1}' sample_order_by_ploidy.txt)
Rscript plot_nQuire_delta_loglikelihood.R $F.extraPamicornis.txt $F.extraPamicornis.txt.plot.pdf <(awk -F'\t' '{print $1}' sample_prefixes_extra_Pamicornis.txt)
Rscript plot_nQuire_delta_loglikelihood.R $F.REF.txt $F.REF.txt.plot.pdf





cat \
   <(echo -e "Sample\tPloidy") \
   <(echo -e "P2185\t3") \
   <(awk -F'\t' '{print $1"\t2"}' sample_prefixes_extra_Pamicornis.txt) \
   sample_order_by_ploidy.txt \
 | ~/scripts/add_value_to_table.py -a <(awk -F'\t' 'BEGIN{print "Sample\td_Diploid\td_Triploid\td_Tetraploid"} NR>1 && $1!~"denoise" {print $1"\t"$6"\t"$7"\t"$8}' nQuire_03_lrdmodel.log | sed -e 's/.bin//') \
 | ~/scripts/add_value_to_table.py -a <(awk -F'\t' 'BEGIN{print "Sample\tdenoise_d_Diploid\tdenoise_d_Triploid\tdenoise_d_Tetraploid"} NR>1 && $1~"denoise" {print $1"\t"$6"\t"$7"\t"$8}' nQuire_03_lrdmodel.log | sed -e 's/.denoise.bin//') \
 > delta_log-likelihood_table_AllSamples.txt




