#!/usr/bin/env Rscript

DESCRIPTION="
##
## 
##

# Example:
Rscript plot_variants_scores.R plot_file SNP_table INDEL_table SNP_QD_min SNP_MQ_min SNP_FS_max SNP_SOR_max INDEL_QD_min INDEL_MQ_min INDEL_FS_max INDEL_SOR_max

# plot_prefix (prefix to use for output plots)

# SNP_table (can be gzipped; tab sep):
CHROM  	POS    	QUAL   	QD     	DP     	MQ     	FS     	SOR    	MQRankSum      	ReadPosRankSum
Seq1   	97     	83.26  	25.36  	2      	60.00  	0.000  	0.693  	NA     	NA
Seq1   	150    	39.77  	19.88  	6      	60.00  	0.000  	0.693  	NA     	NA
Seq1   	410    	40.29  	20.15  	5      	60.00  	0.000  	0.693  	NA     	NA
..
..

# INDEL_table (can be gzipped; tab sep):
CHROM  	POS    	QUAL   	QD     	DP     	MQ     	FS     	SOR    	MQRankSum      	ReadPosRankSum
Seq1   	98     	83.18  	28.73  	2      	60.00  	0.000  	0.693  	NA     	NA
Seq1   	1807   	83.18  	27.51  	2      	60.00  	0.000  	0.693  	NA     	NA
Seq1   	2308   	677.91 	9.68   	103    	60.00  	0.000  	0.693  	0.00   	2.85
..
..
# SNP_QD_min (float)
# SNP_MQ_min (float)
# SNP_FS_max (float)
# SNP_SOR_max (float)
# INDEL_QD_min (float)
# INDEL_MQ_min (float)
# INDEL_FS_max (float)
# INDEL_SOR_max (float)

## NOTE:
Warning messages:
1: Removed X rows containing non-finite values (stat_density). 
#    - These warnings are from the MQRankSum and ReadPosRankSum plots because they contain NA values for many of the SNPs/INDELs.
"
library('gridExtra')
library('ggplot2')

args = commandArgs(trailingOnly=TRUE)
# Test if there is 11 arguments: if not, return an error
if (length(args)!=11) {
  cat(DESCRIPTION)
  stop("11 arguments must be supplied (plot_prefix, SNP_table, INDEL_table, SNP_QD_min, SNP_MQ_min, SNP_FS_max, SNP_SOR_max, INDEL_QD_min, INDEL_MQ_min, INDEL_FS_max, INDEL_SOR_max)", call.=FALSE)
}
#args <- c("GVCFall.variants_scores", "GVCFall_SNPs.table", "GVCFall_INDELs.table", 
#          16, 50, 5, 2.5, 
#          16, 45, 5, 2.5)

## Load command line parameters
plot.prefix <- args[1]
VCFsnps.file <- args[2]
VCFindel.file <- args[3]

SNP.QD.min <- as.double(args[4])
SNP.MQ.min <- as.double(args[5])
SNP.FS.max <- as.double(args[6])
SNP.SOR.max <- as.double(args[7])

INDEL.QD.min <- as.double(args[8])
INDEL.MQ.min <- as.double(args[9])
INDEL.FS.max <- as.double(args[10])
INDEL.SOR.max <- as.double(args[11])

## Plot axis limits
FS.xmin <- 0
FS.xmax <- 20
SOR.xmin <- 0
SOR.xmax <- 10

###############
## Main code ##
###############

VCFsnps <- read.csv(VCFsnps.file, header = T, na.strings=c("","NA"), sep = "\t") 
VCFindel <- read.csv(VCFindel.file, header = T, na.strings=c("","NA"), sep = "\t")
print("SNPs dimensions:")
print(dim(VCFsnps))
print("INDELs dimensions:")
print(dim(VCFindel))
VCF <- rbind(VCFsnps, VCFindel)
VCF$Variant <- factor(c(rep("SNPs", dim(VCFsnps)[1]), rep("Indels", dim(VCFindel)[1])))

snps <- '#A9E2E4'
indels <- '#F4CCCA'

# NO plot axis limits
QD <- ggplot(VCF, aes(x=QD, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.QD.min, SNP.QD.min), size=0.5, colour = c(indels,snps)) +
  theme_classic()

MQ <- ggplot(VCF, aes(x=MQ, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.MQ.min, SNP.MQ.min), size=0.5, colour = c(indels,snps)) +
  xlim(0, 100) +
  theme_classic()

FS <- ggplot(VCF, aes(x=FS, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.FS.max, SNP.FS.max), size=0.5, colour = c(indels,snps)) +
  theme_classic()

SOR <- ggplot(VCF, aes(x=SOR, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.SOR.max, SNP.SOR.max), size=0.5, colour = c(indels,snps)) +
  theme_classic()

# Save
p <- grid.arrange(QD, MQ, FS, SOR, nrow=2)
ggsave(paste(plot.prefix, ".pdf", sep=''), p, height=8.3, width=11.7)



# WITH plot axis limits
QD <- ggplot(VCF, aes(x=QD, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.QD.min, SNP.QD.min), size=0.5, colour = c(indels,snps)) +
  theme_classic()

MQ <- ggplot(VCF, aes(x=MQ, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.MQ.min, SNP.MQ.min), size=0.5, colour = c(indels,snps)) +
  xlim(40, 80) +
  theme_classic()

FS <- ggplot(VCF, aes(x=FS, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.FS.max, SNP.FS.max), size=0.5, colour = c(indels,snps)) +
  xlim(FS.xmin, FS.xmax) +
  theme_classic()

SOR <- ggplot(VCF, aes(x=SOR, fill=Variant)) + geom_density(alpha=.3) +
  geom_vline(xintercept=c(INDEL.SOR.max, SNP.SOR.max), size=0.5, colour = c(indels,snps)) +
  xlim(SOR.xmin, SOR.xmax) +
  theme_classic()

# Save
p <- grid.arrange(QD, MQ, FS, SOR, nrow=2)
ggsave(paste(plot.prefix, ".axisLimits.pdf", sep=''), p, height=8.3, width=11.7)

