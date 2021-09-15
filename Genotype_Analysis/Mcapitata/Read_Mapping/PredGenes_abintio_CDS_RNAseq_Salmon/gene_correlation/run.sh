


conda activate Trinity
TRINITY_HOME="/home/timothy/programs/trinityrnaseq-v2.11.0"
MATRIX="Mcap.mRNA.fa.salmon.allSamples.numreads.matrix"
SAMPLES="samples_Mcapitata.txt"

## Compare replicates for each of your samples

## Step 1 - pairwise dot plots + bar charts
$TRINITY_HOME/Analysis/DifferentialExpression/PtR \
 --matrix "$MATRIX" \
 --samples "$SAMPLES" --log2 --CPM \
 --min_rowSums 10 \
 --compare_replicates

## Compare Replicates Across Samples
## Step 2 - Heatmaps
$TRINITY_HOME/Analysis/DifferentialExpression/PtR \
 --matrix "$MATRIX" \
 --min_rowSums 10 \
 -s "$SAMPLES" --log2 --CPM --sample_cor_matrix

## Step 3 - PCA analysis
$TRINITY_HOME/Analysis/DifferentialExpression/PtR \
 --matrix "$MATRIX" \
 -s "$SAMPLES" --min_rowSums 10 --log2 \
 --CPM --center_rows \
 --prin_comp 3







conda activate Trinity
MATRIX="Mcap.mRNA.fa.salmon.allSamples.numreads.matrix"
SAMPLES="Supplementary_Tables_S1-Samples.txt"


awk -F'\t' '$1~"Mcapitata" {print $11"\t"$2}' "$SAMPLES" > "samples_Mcapitata.Treatment.txt"
awk -F'\t' '$1~"Mcapitata" {print $4"\t"$2}' "$SAMPLES"  > "samples_Mcapitata.SiteName.txt"
awk -F'\t' '{print $4"\t"$1}' "annotations.txt" | sort -k1,1r > "samples_Mcapitata.SNPclades.txt"

Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" <(sort -k1,1r "samples_Mcapitata.Treatment.txt") "$MATRIX.Treatment" <(tac annotations.Treatment.txt | cut -f2)
Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" <(sort -k1,1  "samples_Mcapitata.SiteName.txt")  "$MATRIX.SiteName"  <(cat annotations.SiteName.txt | cut -f2)
Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" "samples_Mcapitata.SNPclades.txt" "$MATRIX.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)

Rscript Mcap.mRNA.fa.salmon.allSamples.numreads.matrix.Step2.smallLabels.R




