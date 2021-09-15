#!/usr/bin/env Rscript

DESCRIPTION="
##
## Plot read depth (DP) for variants from each sample. File to plot should have *.GT.DP.txt extension (script will auto find these files).
##

# Example:
Rscript plot_DP_scores.R out_prefix cutoff x-lim

# out_prefix:
Prefix to use for output files.

# cutoff:
Position along x-axis to plot red line (helps to pick filtering cutoff)

# x-lim
Max x value to plot. 

"

args = commandArgs(trailingOnly=TRUE)
# Test if there is two arguments: if not, return an error
if (length(args)!=3) {
        cat(DESCRIPTION)
        stop("Three arguments must be supplied (out_prefix, cutoff, x-lim)", call.=FALSE)
}

out <- args[1]
cutoff <- as.double(args[2])
x.lim <- as.double(args[3])

nameList <- Sys.glob("../RNAseq_short_variant_analysis/filtering/GVCFall.DP/*.GT.DP.txt")
nsamples <- length(nameList)
print("Found DP info files:")
print(nameList)

pdf(paste(out, ".pdf", sep=''))
par(mar=c(5, 3, 3, 2), cex=1.5, mfrow=c(4,2)) # number of plots per page
for (i in 1:nsamples) {
  title <- gsub('.GT.DP.txt', '', nameList[i])
  title <- gsub('../RNAseq_short_variant_analysis/filtering/GVCFall.DP/', '', title)
  DP <- read.table(nameList[i], header = T)
  d <- density(DP[,1], from=0, to=x.lim, bw=0.5, na.rm =T)
  plot(d, xlim = c(0,x.lim), main=title, col="blue", xlab = dim(DP)[1], lwd=2)
  abline(v=cutoff, col='red', lwd=0.5)
}
dev.off()

