

# Make samples file.
awk -F'\t' '{ print $1"\t"$2"\t../../Read_Mapping/GenomeScaffolds_RNAseq_HISAT2/"$2".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R1.fastq.gz\t../../Read_Mapping/GenomeScaffolds_RNAseq_HISAT2/"$2".HISAT2_RNAseq_mapping.coordSorted.unmapped_pairs_R2.fastq.gz" }' ../../samples_Mcapitata.txt > samples.txt



