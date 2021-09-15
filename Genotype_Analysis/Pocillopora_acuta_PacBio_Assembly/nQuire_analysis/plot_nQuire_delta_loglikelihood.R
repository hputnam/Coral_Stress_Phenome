library(ggplot2)
# 
# Takes nQuire delta log-liklihood values for diploid/triploid/tetraploid models 
# and plots values as a PDF
#   
#   ## Expected input format (Columns need headers shown):
# |------|---------------|--------|
# | Name | LogLikelihood | Ploidy |
# |------|---------------|--------|
# | Seq1 |   72155.57    |  dip   |
# | Seq1 |   72355.57    |  tri   |
# | Seq1 |   82165.57    |  tet   |
# | Seq2 |   62165.57    |  dip   |
# | Seq2 |   72195.57    |  tri   |
# | Seq2 |   82155.57    |  tet   |
# | Seq3 |   12168.57    |  dip   |
# | Seq3 |   32175.57    |  tri   |
# | Seq3 |   33195.57    |  tet   |
# |------|---------------|--------|
#   


## Load command line args
args = commandArgs(trailingOnly=TRUE)
# test if there 2 arguments: if not, return an error
if (length(args)<2) {
  stop("R script requires 2 files: delta_log-likelihood.txt output.pdf [order2plot].n", call.=FALSE)
}

#args <- c("delta_log-likelihood.Diploid.txt", "delta_log-likelihood.Diploid.txt.plot.pdf")
data.file <- args[1]
output.pdf.file <- args[2]
order.file <- args[3]

data <- read.table(data.file, header = T, sep = '\t')
data$Ploidy <- factor(data$Ploidy, levels = c("Diploid", "Triploid", "Tetraploid"))
## Open list of names and order to plot if avaliable.
if (is.na(order.file)) {
  order2plot <- unique(data$Name)
} else {
  order2plot <- unique(readLines(order.file))
  order2plot <- order2plot[order2plot != ""]
}
data$Name <- factor(data$Name, levels = order2plot)

p<-ggplot(data, aes(x=Name, y=LogLikelihood, group=Ploidy)) +
  geom_point(aes(color=Ploidy)) + 
  scale_color_brewer(palette="Dark2") + 
  theme_light() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=4)) +
  xlab("Samples") + 
  ylab("delta Log-Likelihood") +
  theme(panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank())
ggsave(output.pdf.file, p, width = 7, height = 7, units = "in")

