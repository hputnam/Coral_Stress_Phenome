library(reshape2)
library(ggplot2)
library(RColorBrewer)

ITS2.matrix.file <- "ITS2_Profiles_with_original_SampleIDs.Pacuta.txt"
sample.order.file <- "Trinity.fasta.salmon.allSamples.numreads.matrix.hclust_sample_order.txt"
output.file <- "ITS2_Profiles_with_original_SampleIDs.Pacuta.txt.barplot_ordered_samples.pdf"

print('Reading ITS2 matrix file.')
data = read.table(ITS2.matrix.file, header=T, com='', row.names=1, check.names=F, sep='\t')
data = as.matrix(data)

print('Reading sample order file')
sample.order <- rev(read.table(sample.order.file,header=F)[,1])

# Calculate relative abundance of symbionts within each sample (row)
data.rel <- data/rowSums(data) 

data.rel.melted <- melt(data.rel)
colnames(data.rel.melted) <- c("SampleID", "SymbiontType", "Relative.Abundance")

data.rel.melted$SampleID <- factor(data.rel.melted$SampleID, levels = sample.order)

bp.x <- ggplot(data.rel.melted, aes(x=SampleID, y=Relative.Abundance, fill=SymbiontType)) + 
  geom_bar(position="stack", stat="identity") +
  coord_flip() +
  scale_fill_manual(values = colorRampPalette(brewer.pal(12,"Paired"))(12)) +
  theme_classic() +
  theme(axis.text.y = element_text(size=2)) +
  xlab("Sample ID") +
  ylab("Relative Abundance") +
  guides(fill=guide_legend(title="Symbiont Type"))
pdf(output.file)
bp.x
dev.off()
