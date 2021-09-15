

F="../../../../../../0017_Montipora_capitata_HiRise_Assembly/03_Analysis/2021_04_21/read_mapping/Genome_RNAseq_HISAT2_StringTie2_NoRefGff/Montipora_capitata_HIv1.assembly.fasta.stringtie2.transcripts.fa"
sed -e 's/>/>Host-Montipora-capitata-HIv1-/' "$F" > host_db/Host_DB.trans.fna

F="/scratch/timothy/genome_data/Montipora_capitata_Genome/databases/Mcap.mRNA.fa"
sed -e 's/>/>Host-Montipora-capitata-HIpub-/' "$F" >> host_db/Host_DB.trans.fna

/home/timothy/programs/ncbi-blast-2.10.1+/bin/makeblastdb -dbtype nucl -in host_db/Host_DB.trans.fna



##
~/scripts/blast_top_hits.py -i Trinity.fasta.blastn_HostDB.outfmt6 -o Trinity.fasta.blastn_HostDB.outfmt6.top1
~/scripts/blast_top_hits.py -i Trinity.fasta.blastn_SymbiontDB.outfmt6 -o Trinity.fasta.blastn_SymbiontDB.outfmt6.top1

cat Trinity.fasta.blastn_HostDB.outfmt6.top1 Trinity.fasta.blastn_SymbiontDB.outfmt6.top1 | sort -k1,1 -k12,12nr | ~/scripts/blast_top_hits.py > Top_hit_across_DBs.outfmt6.top1







