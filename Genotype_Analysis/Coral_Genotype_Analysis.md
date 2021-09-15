# Analysis of the genotypes of RNA-seq samples from *M. capitata* and *P.  acuta*

This directory contains all of the scripts (bash, python, and R scripts), log files, and some of the smaller results files from the genotype analysis of coral RNA-seq sample.

In each analysis directory there will be a `run.sh` bash script which details the commands that were run to generate the results. The log files produced during the analysis, as well as the python and R scripts used, are also included in each directory. 

## Description of analysis directories

### `Pocillopora_acuta_PacBio_Assembly/`

Genotype analysis of *P. acuta* using the 119 RNA-seq samples and the high-quality PacBio HiFi genome assembly. 

- `RNAseq_short_variant_analysis/`
    - Call variants in *P. acuta* RNA-seq samples. Combine variants from each sample; apply filtering before phylogenetic analysis. 
    - `filtering/`
        - Filtering of called variants (across all samples) using various quality/confidence threasholds. 
        - Generate some QC plots to help pick thresholds. 
    - `phylogeny/`
        - Parse filtered variants, keeping only those that have calls across all samples, and use them for phylogenetic analysis. 
    - `outgroup/P_damicornis_Linnaeus_1758_Indonesia_isolate/`
        - *P. damicornis* RNA-seq samples used as an outgroup for *P. acuta* phylogenetic analysis.
        - In this directory (and subdirectories) are the scripts to download (`run_fasterq-dump.sh`) and trim (`run_Cutadapt.sh`) reads, call variants (`variant_analysis_SeparateLibraries/*.sh`), and filter SNPs (`filtering/`) ready for phylogenetic analysis (`phylogeny/`). 

- `RNAseq_short_variant_analysis_CorrectPloidy`
    - Call variants in *P. acuta* RNA-seq samples (again) this time taking into consideration the putative ploidy of each sample during the haplotype calling stage. The variant calling, filtering and phylogenetic analysis is virtually the same as the `RNAseq_short_variant_analysis/` directory.

- `Pocillopora_acuta_PacBio_Assembly/`
    - Call variants using the *P. acuta* PacBio HiFi genome data. Combine the called variants with those from the RNA-seq samples and redo filtering and phylogenetic analysis. This analysis takes into consideration the putative ploidy of the RNA-seq samples and the sample used for genome sequencing. The variant calling, filtering and phylogenetic analysis is virtually the same as the `RNAseq_short_variant_analysis/` directory.
- `nQuire_analysis/`
    - Assessment of the ploidy of each RNA-seq samples using nQuire (https://github.com/clwgg/nQuire). Uses the aligned and post-processed reads from `RNAseq_short_variant_analysis/`, `outgroup/P_damicornis_Linnaeus_1758_Indonesia_isolate/` and `Genome_short_variant_analysis/`.
- `MultiQC/`
    - MultiQC visualization of the FastQC plots generated from the trimmed *P. acuta* RNA-seq samples. 
- `plots4manuscript/`
    - Scripts used to aggregate and plot results from variant filtering. 

---

###  `Montipora_capitata_HiRise_Assembly/`

Genotype analysis of *M. capitata* using the 132 RNA-seq samples and the high-quality PacBio+Hi-C genome assembly. 

- `RNAseq_short_variant_analysis/`
    - Call variants in *M. capitata* RNA-seq samples. Combine variants from each sample; apply filtering before phylogenetic analysis. 
    - `filtering/`
        - Filtering of called variants (across all samples) using various quality/confidence threasholds. 
        - Generate some QC plots to help pick thresholds. 
    - `phylogeny/`
        - Parse filtered variants, keeping only those that have calls across all samples, and use them for phylogenetic analysis. 

- `nQuire_analysis/`
    - Assessment of the ploidy of each RNA-seq samples using nQuire (https://github.com/clwgg/nQuire). Uses the aligned and post-processed reads from `RNAseq_short_variant_analysis/`, `outgroup/P_damicornis_Linnaeus_1758_Indonesia_isolate/` and `Genome_short_variant_analysis/`.
- `MultiQC/`
    - MultiQC visualization of the FastQC plots generated from the trimmed *M. capitata* RNA-seq samples. 
- `plots4manuscript/`
    - Scripts used to aggregate and plot results from variant filtering. 

---

### `Pacuta/`

Analysis of expression patterns using the trimmed RNA-seq reads from each sample aligned against the published *P. acuta* genome assembly. 

- `Read_Mapping/PredGenes_Pacuta_experimental_CDS_RNAseq_Salmon/`
    - Scripts for expression quantification using `salmon`. 
    - `gene_correlation/`
        - Scripts for clustering of gene expression patterns and for plotting heatmaps of sample-to-sample expression pattern distances with various metadata annotated. 
- `Symbiont_DeNovo_Transcript/`
    - Assembly and analysis of reads that didn't align to the *P. acuta* reference genome (i.e., reads putatively from the holobiont component of each sample).
    - `Trinity/`
        - Assembly of unaligned reads using `Trinity`
    - `Trinity_Salmon/`
        - Expression quantification of `Trinity` assembled transcripts using the unaligned reads.
    - `Transcript_Taxonomy/`
        - Compare `Trinity` transcripts against a database composed of *P. acuta* transcripts and a database of algal symbiont transcript sequences. Use the top hit information to classify transcripts as either host, symbiont, or unknown. 
    - `Transcript_Taxonomy_PlotExpression/`
        - Cluster holotranscripts using gene expression patterns; annotate heatmaps with the host clade/genotype. Filter the transcripts based on if they were classified as host, symbiont, or unknown. Plot these different groups to see what affect it has on the heatmap. 

### `Mcapitata/`

Analysis of expression patterns using the trimmed RNA-seq reads from each sample aligned against the published *M. capitata* genome assembly. 

- **Analysis directories are the same as described for `Pacuta/` except that the *M. capitata* RNA-seq and genome data was used in-place of *P. acuta* data**

---

### `RNA_Seq_data/`

Trimming of raw *P. acuta* and *M. capitata* RNA-seq reads.

- `raw_reads/`
    - Directory where raw RNA-seq reads were downloaded from the sequencing provider. md5sums and basic stats files are included in this directory. 
- `raw_reads_renamed/`
    - Commands to rename (using symbolic links) the raw data from sequencing provider. Rename files to include species, treatment, timepoint and plug ID. 
- `trimming_cutadapt/`
    - Scripts for running the two rounds of read trimming that was used to prepare the raw RNA-seq reads. Directory also includes the log files for each sample plus a file `stats.txt` that lists the number of reads and bases in each sample after each round of filtering.  

