#!/usr/bin/env Rscript

DESCRIPTION="
##
## Plot allelic depth (AD) for variants from each sample. Files to plot and plot title will be pulled from files2plot file.
##

# Example:
Rscript plot_AD_scores.R out_prefix files2plot xaxis_mix x-axis_max

# out_prefix:
Prefix to use for output files.

# files2plot
List of files to plot.
File_to_load [tab] title_of_plot

# x-axis_*:
Min and max x-axis coords for plotting.

"

args = commandArgs(trailingOnly=TRUE)
# Test if there is two arguments: if not, return an error
if (length(args)!=4) {
        cat(DESCRIPTION)
        stop("Four arguments must be supplied (out_prefix, files2plot, xaxis_mix, x-axis_max)", call.=FALSE)
}

out <- args[1]
files2plot <- read.table(args[2], header = F, sep='\t')
x_min <- as.double(args[3])
x_max <- as.double(args[4])

nsamples <- length(files2plot[,1])
print("Found AD info files:")
print(files2plot[,1])

pdf(paste(out, ".pdf", sep=''))
par(mar=c(5, 3, 3, 2), cex=1.5, mfrow=c(4,2)) # number of plots per page
for (i in 1:nsamples) {
  AD <- read.table(as.character(files2plot[i,1]), header = T)
  d <- density(AD[,1], from=x_min, to=x_max, bw=0.01, na.rm =T)
  plot(d, xlim = c(x_min,x_max), main=as.character(files2plot[i,2]), col="blue", xlab = dim(AD)[1], lwd=2)
}
dev.off()

