

export PATH=$PATH:~/programs/salmon-1.1.0_linux_x86_64/bin

DIR_LIST=$(awk -F'\t' '{printf " %s", $2}' samples_Pacuta.txt)
F="Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna"

salmon quantmerge --column numreads --output $F.salmon.allSamples.numreads.matrix --quants $DIR_LIST
salmon quantmerge --column tpm --output $F.salmon.allSamples.tpm.matrix --quants $DIR_LIST



echo -e "sample_id\tSalmon_mapping_rate" > stats.txt
for D in $(awk -F'\t' '{printf " %s", $2}' samples_Pacuta.txt); do echo -e "$D\t"$(grep 'Mapping rate' $D/logs/salmon_quant.log | awk '{print $8}'); done >> stats.txt



for D in $(awk -F'\t' '{printf " %s", $2}' samples_Pacuta.txt); do echo "$D"; tar -zcf $D.tar.gz $D && rm -r $D; done




echo -e "Sample\tReplicate\tSpecies\tTreatment\tTimePoint\tTime\tPLUG_ID\tRead1\tRead2" > samples_Pacuta_metaInfo.txt
awk '{split($2, a, "_"); gsub("TP", "", a[3]); print $1"\t"$2"\t"a[1]"\t"a[2]"\t"a[3]"\t"a[3]"\t"a[4]"\t"$3"\t"$4}' samples_Pacuta.txt \
 | sort -k3,4 -k5,5n \
 | awk 'BEGIN{OFS=FS="\t"} 
	{ 	if($6=="1") {$6="0"} else 
		if($6=="3") {$6="0.25"} else 
		if($6=="4") {$6="0.5"} else 
		if($6=="5") {$6="1.25"} else 
		if($6=="6") {$6="7"} else 
		if($6=="7") {$6="14"} else 
		if($6=="8") {$6="28"} else 
		if($6=="9") {$6="42"} else 
		if($6=="10") {$6="56"} else 
		if($6=="11") {$6="84"} else 
		if($6=="12") {$6="112"}; 
	print }' \
 >> samples_Pacuta_metaInfo.txt



## Normalize count matrix
conda activate r4_en
Rscript normalize_matrix.R Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna.salmon.allSamples.numreads.matrix

## "Melt" table into a single data column format for plotting with R
./melt_table.py -i Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna.salmon.allSamples.numreads.matrix.normalized_counts.txt \
 | awk -F'\t' '{ if(NR==1) {print $0"\tCondition"} else {split($2,a,"_"); b=substr(a[3],3); print $1"\t"b"\t"$3"\t"a[2]} }' \
 > Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna.salmon.allSamples.numreads.matrix.normalized_counts.txt.melted


./melt_table.py -i Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna.salmon.allSamples.tpm.matrix \
 | awk -F'\t' '{ if(NR==1) {print $0"\tCondition"} else {split($2,a,"_"); b=substr(a[3],3); print $1"\t"b"\t"$3"\t"a[2]} }' \
 > Pocillopora_acuta_PredGenes_experimental_v1.transcripts.cds.fna.salmon.allSamples.tpm.matrix.melted

