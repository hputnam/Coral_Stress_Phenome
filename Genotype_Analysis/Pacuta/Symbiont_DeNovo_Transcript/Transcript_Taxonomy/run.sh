

## Make host transcript DB.
F="../../../../../../0020_Pocillopora_acuta_PacBio_Assembly/03_Analysis/2021_05_26/read_mapping/GenomeScaffolds_RNAseq_HISAT2/Pocillopora_acuta_HIv1.assembly.purged.fasta.stringtie2.estAbd.transcripts.fa"
sed -e 's/>/>Host-Pocillopora-acuta-HIv1-/' "$F" > host_db/Host_DB.trans.fna

F="/scratch/timothy/genome_data/Pocillopora_acuta_Genome/databases/Pocillopora_acuta_PredGenes_experimental_v1.transcripts.fasta"
sed -e 's/>/>Host-Pocillopora-acuta-Indonesia-/' "$F" >> host_db/Host_DB.trans.fna

F="/scratch/timothy/genome_data/Pocillopora_damicornis_RSMAS_Version1/nuclear_genome/databases/Pocillopora_damicornis_RSMAS.cds.fna"
sed -e 's/>/>Host-Pocillopora-damicorni-RSMAS-/' "$F" >> host_db/Host_DB.trans.fna

/home/timothy/programs/ncbi-blast-2.10.1+/bin/makeblastdb -dbtype nucl -in host_db/Host_DB.trans.fna



##
~/scripts/blast_top_hits.py -i Trinity.fasta.blastn_HostDB.outfmt6 -o Trinity.fasta.blastn_HostDB.outfmt6.top1
~/scripts/blast_top_hits.py -i Trinity.fasta.blastn_SymbiontDB.outfmt6 -o Trinity.fasta.blastn_SymbiontDB.outfmt6.top1

cat Trinity.fasta.blastn_HostDB.outfmt6.top1 Trinity.fasta.blastn_SymbiontDB.outfmt6.top1 | sort -k1,1 -k12,12nr | ~/scripts/blast_top_hits.py > Top_hit_across_DBs.outfmt6.top1







