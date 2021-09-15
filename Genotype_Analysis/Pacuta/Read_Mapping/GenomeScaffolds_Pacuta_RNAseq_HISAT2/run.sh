


## Stats of unmapped read pairs.
~/programs/bbmap/statswrapper.sh *.fastq.gz > unmapped_pairs.stats.txt

## Mapping rate, No. unmapped reads. No bases unmapped reads
echo -e "sample_id\tHISAT_mapping_rate\tR1_NoReads\tR1_NoBases\tR2_NoReads\tR2_NoBases" > stats.txt
for ID in $(awk -F'\t' '{printf " %s", $2}' samples_Pacuta.txt);
do 
	printf "%s\t%s\t%s\t%s\t%s\t%s\n" \
	       "$ID" \
		$(grep 'overall alignment rate' "$ID.HISAT2_RNAseq_mapping.hisat2_mapping.stats" | awk '{print $1}') \
		$(awk -vID=$ID '$20~"/"ID".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R1.fastq.gz"{print $1}' unmapped_pairs.stats.txt) \
		$(awk -vID=$ID '$20~"/"ID".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R1.fastq.gz"{print $3}' unmapped_pairs.stats.txt) \
		$(awk -vID=$ID '$20~"/"ID".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R2.fastq.gz"{print $1}' unmapped_pairs.stats.txt) \
		$(awk -vID=$ID '$20~"/"ID".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R2.fastq.gz"{print $3}' unmapped_pairs.stats.txt)
done >> stats.txt



