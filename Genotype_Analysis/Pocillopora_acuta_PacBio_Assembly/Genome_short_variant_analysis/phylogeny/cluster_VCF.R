#!/usr/bin/env Rscript

DESCRIPTION="
##
## Cluster samples from VCF file.
##

# Example:
Rscript cluster_VCF.R out_prefix in.vcf

# out_prefix:
Prefix to use for output files.

# in.vcf:
VCF file with variants to cluster with.

"
library(gdsfmt)
library(SNPRelate)
library(ggplot2)
library(ggtree)
library(ape)

## Code based on: https://rpubs.com/adel922/560260

args = commandArgs(trailingOnly=TRUE)
# Test if there is two arguments: if not, return an error
if (length(args)!=2) {
        cat(DESCRIPTION)
        stop("Two arguments must be supplied (out_prefix, in.vcf)", call.=FALSE)
}

out <- args[1]
vcf.file <- args[2]


### Load VCF file into GDS format
snpgdsVCF2GDS(vcf.file, paste(out, ".gds", sep=''), method ="copy.num.of.ref")


### Preparing the data so it is formatted correctly to create a dissimilarity matrix.
snps.gds <- snpgdsOpen(paste(out, ".gds", sep=''))

set.seed(100)
snps.HCluster <- snpgdsHCluster(snpgdsIBS(snps.gds,num.thread=2, autosome.only=FALSE))
snps.CutTree <- snpgdsCutTree(snps.HCluster)


### Saving the dendrograms to new Variables
pdf(file=paste(out,".dendrogram_1.pdf",sep=''), width=4, height=4)
plot(snps.CutTree$dendrogram,horiz=T, main ="VCF SNP Tree")
dev.off()

snps.tree = snps.CutTree$dendrogram
tree2 = ggtree(as.phylo(as.hclust(snps.tree)),
               layout="circular", color='darkgreen', branch.length="branch.length") +
        geom_tiplab(size=2.5, aes(angle=angle)) +
        ggtitle("VCF SNP Tree")
ggsave(filename=paste(out,".dendrogram_2.pdf",sep=''), plot=tree2, width=4, height=4)


### converting dendrograms to class hclust and to new variables
snps.CutTree.hc = as.hclust(snps.CutTree$dendrogram)
### Making the hclust object into a phylo object in ape
snps.CutTree.phylo <- as.phylo(snps.CutTree.hc)
#### Writing to a newick tree file
write.tree(phy=snps.CutTree.phylo , file=paste(out,".cluster.tre",sep=''))

