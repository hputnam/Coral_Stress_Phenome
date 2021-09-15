#!/usr/bin/env Rscript

DESCRIPTION="
##
## DESCRIPTION
##

# Example:
Rscript plot_sample2sample_distances_heatmap.R matrix.file sample.file out.prefix color.file [colorbar.cex.axis]

# matrix.file (can be gzipped):
Name	S1_rep1	S1_rep2	S2_rep1	..	..
Seq1	100.2	23.1	54.9	..	..
Seq2	1649.3	2036.8	1894.7	..	..
..	..	..	..	..	..

# sample.file (can be gzipped):
Sample1	S1_rep1
Sample1	S1_rep2
Sample2	S1_rep2
..
*OR*
Clade1	S1_rep1
Clade2	S1_rep2
Clade2	S2_rep1
..

# out.prefix

# color.file
Clade1	#1f78b4
Clade2	#a6cee3
..

# colorbar.cex.axis (deafult = 0.5)

"
library(cluster)
library(Biobase)
library(qvalue)
library(fastcluster)
options(stringsAsFactors = FALSE)

source("heatmap.3.labelSizeOption.R")
source("misc_rnaseq_funcs.R")

args = commandArgs(trailingOnly=TRUE)
# Test if there is two arguments: if not, return an error
if (length(args)<3) {
        cat(DESCRIPTION)
        stop("At least three arguments must be supplied (in_file, sample.file, out_prefix, [color.file], [colorbar.cex.axis])", call.=FALSE)
}

matrix.file <- args[1]
sample.file <- args[2]
out.prefix <- args[3]
color.file  <- args[4]
colorbar.cex.axis <- 0.5

if (!is.na(args[5])) {
    colorbar.cex.axis <- double(args[5])
}

##
print('Reading matrix file.')
primary_data = read.table(matrix.file, header=T, com='', row.names=1, check.names=F, sep='\t')
primary_data = as.matrix(primary_data)
data = primary_data

myheatcol = colorpanel(75, 'purple','black','yellow')

##
print('Reading sample file.')
samples_data = read.table(sample.file, header=F, check.names=F, fill=T)
samples_data = samples_data[samples_data[,2] != '',]
colnames(samples_data) = c('sample_name', 'replicate_name')
sample_types = as.character(unique(samples_data[,1]))
rep_names = as.character(samples_data[,2])
data = data[, colnames(data) %in% rep_names, drop=F ]
nsamples = length(sample_types)

##
if (!is.na(color.file)) {
    print('Reading sample color file.')
    sample_colors = read.table(color.file,comment='')[,1]
} else {
    print('No color file provided, using rainbow palette.')
    sample_colors = rainbow(nsamples)
}

## Parse sample info
names(sample_colors) = sample_types
sample_type_list = list()
for (i in 1:nsamples) {
    samples_want = samples_data[samples_data[,1]==sample_types[i], 2]
    sample_type_list[[sample_types[i]]] = as.vector(samples_want)
}
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}

##
data = data[rowSums(data)>=10,]
initial_matrix = data # store before doing various data transformations
cs = colSums(data)
data = t( t(data)/cs) * 1e6;
data = log2(data+1)
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}
sampleAnnotations = matrix(ncol=ncol(data),nrow=nsamples)
for (i in 1:nsamples) {
  sampleAnnotations[i,] = colnames(data) %in% sample_type_list[[sample_types[i]]]
}
sampleAnnotations = apply(sampleAnnotations, 1:2, function(x) as.logical(x))
sampleAnnotations = sample_matrix_to_color_assignments(sampleAnnotations, col=sample_colors)
rownames(sampleAnnotations) = as.vector(sample_types)
colnames(sampleAnnotations) = colnames(data)
data = as.matrix(data) # convert to matrix
write.table(data, file=paste(out.prefix,".minRow10.CPM.log2.dat",sep=''), quote=F, sep='\t');

if (nrow(data) < 2) { stop("

**** Sorry, at least two rows are required for this matrix.

");}
if (ncol(data) < 2) { stop("

**** Sorry, at least two columns are required for this matrix.

");}


sample_cor = cor(data, method='pearson', use='pairwise.complete.obs')
sample_dist = dist(t(data), method='euclidean')
hc_samples = hclust(sample_dist, method='complete')
write.table(sample_cor, file=paste(out.prefix,".minRow10.CPM.log2.sample_cor_matrix.dat",sep=''), quote=F, sep='\t')
write(rev(hc_samples$labels[hc_samples$order]), file=paste(out.prefix,".minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt",sep=''))

if (is.null(hc_samples)) {
    RowV=NULL; ColV=NULL
} else {
    RowV=as.dendrogram(hc_samples); ColV=RowV
}

sample_cor_for_plot = sample_cor
pdf(paste(out.prefix,".minRow10.CPM.log2.sample_cor_heatmap.pdf",sep=''))
heatmap.3(sample_cor_for_plot, dendrogram='both', Rowv=RowV, Colv=ColV, col = myheatcol, scale='none', symm=TRUE, key=TRUE, 
    density.info='none', trace='none', symkey=FALSE, symbreaks=F, margins=c(10,10), 
    cexCol=0.1, cexRow=0.1, cex.main=0.75, colorbar.cex.axis=colorbar.cex.axis, 
    ColSideColors=sampleAnnotations, RowSideColors=t(sampleAnnotations),
    main=paste(matrix.file,".minRow10.CPM.log2",sep=''))
dev.off()
gene_cor = NULL
