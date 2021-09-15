#!/usr/bin/env Rscript

DESCRIPTION="
##
## Plot allelic depth (DP) for variants from each sample. File to plot should have *.GT.AD.txt extension (script will auto find these files).
##

# Example:
Rscript plot_AD_scores.R out_prefix xaxis_mix x-axis_max

# out_prefix:
Prefix to use for output files.

# x-axis_*:
Min and max x-axis coords for plotting.

"

args = commandArgs(trailingOnly=TRUE)
# Test if there is two arguments: if not, return an error
if (length(args)!=3) {
        cat(DESCRIPTION)
        stop("Three arguments must be supplied (out_prefix, xaxis_mix, x-axis_max)", call.=FALSE)
}

out <- args[1]
x_min <- as.double(args[2])
x_max <- as.double(args[3])

nameList <- Sys.glob("*.GT.AD.sumSDdenominator.txt")
nsamples <- length(nameList)
print("Found AD info files:")
print(nameList)

pdf(paste(out, ".pdf", sep=''))
par(mar=c(5, 3, 3, 2), cex=1.5, mfrow=c(4,2)) # number of plots per page
for (i in 1:nsamples) {
  AD <- read.table(nameList[i], header = T)
  d <- density(AD[,1], from=x_min, to=x_max, bw=0.01, na.rm =T)
  plot(d, xlim = c(x_min,x_max), main=nameList[i], col="blue", xlab = dim(AD)[1], lwd=2)
  #abline(v=cutoff_min, col='red', lwd=0.5)
  #abline(v=cutoff_max, col='red', lwd=0.5)
}
dev.off()

