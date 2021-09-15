


awk -F'_' '{print $1"_"$2"_"$3"\t"$0"\t/scratch/ts942/TranscriptomeAnalysis_Mcapitata_Pacuta_TimeSeriesDE/RNA_Seq_data/trimming_cutadapt/"$0"_R1_TrimmingRound2.fastq.gz\t/scratch/ts942/TranscriptomeAnalysis_Mcapitata_Pacuta_TimeSeriesDE/RNA_Seq_data/trimming_cutadapt/"$0"_R2_TrimmingRound2.fastq.gz"}' raw_reads_renamed/prefixes4samples.txt > samples.txt

grep '^Mcapitata' samples.txt > samples_Mcapitata.txt
grep '^Pacuta' samples.txt > samples_Pacuta.txt



