

export PATH=$PATH:~/programs/salmon-1.1.0_linux_x86_64/bin

DIR_LIST=$(awk -F'\t' '{printf " %s", $2}' samples.txt)
F="Trinity.fasta"

salmon quantmerge --column numreads --output $F.salmon.allSamples.numreads.matrix --quants $DIR_LIST
salmon quantmerge --column tpm --output $F.salmon.allSamples.tpm.matrix --quants $DIR_LIST



echo -e "sample_id\tSalmon_mapping_rate" > stats.txt
for D in $(awk -F'\t' '{printf " %s", $2}' samples.txt); do echo -e "$D\t"$(grep 'Mapping rate' $D/logs/salmon_quant.log | awk '{print $8}'); done >> stats.txt



for D in $(awk -F'\t' '{printf " %s", $2}' samples.txt); do echo "$D"; tar -zcf $D.tar.gz $D && rm -r $D; done



