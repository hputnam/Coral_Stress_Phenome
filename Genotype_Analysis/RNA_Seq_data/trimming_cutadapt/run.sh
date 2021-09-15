

## No. unmapped reads. No bases unmapped reads
echo -e "sample_id\tTrim1_R1_NoReads\tTrim1_R1_NoBases\tTrim1_R2_NoReads\tTrim1_R2_NoBases\tTrim2_R1_NoReads\tTrim2_R1_NoBases\tTrim2_R2_NoReads\tTrim2_R2_NoBases" > stats.txt
for ID in $(awk -F'\t' '{printf " %s", $1}' prefixes4samples.txt);
do
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
               "$ID" \
		$(awk -vID=$ID '$20~"/"ID"_R1_TrimmingRound1.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R1_TrimmingRound1.fastq.gz"{print $3}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2_TrimmingRound1.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2_TrimmingRound1.fastq.gz"{print $3}' read_stats.txt) \
		$(awk -vID=$ID '$20~"/"ID"_R1_TrimmingRound2.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R1_TrimmingRound2.fastq.gz"{print $3}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2_TrimmingRound2.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2_TrimmingRound2.fastq.gz"{print $3}' read_stats.txt) 
done >> stats.txt




