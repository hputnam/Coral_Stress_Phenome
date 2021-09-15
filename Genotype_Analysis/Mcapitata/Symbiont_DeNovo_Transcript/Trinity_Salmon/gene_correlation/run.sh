


conda activate Trinity
MATRIX="Trinity.fasta.salmon.allSamples.numreads.matrix"

Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Mcapitata.txt" "$MATRIX.Treatment_Timepoints"
Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Mcapitata.Treatment.txt" "$MATRIX.Treatment"
Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Mcapitata.SiteName.txt"  "$MATRIX.SiteName"
Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" "samples_Mcapitata.SNPclades.txt" "$MATRIX.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)




## Symbiont ITS2 bar plot
awk 'NR==1 || $1~"Mcapitata"' ITS2_Profiles_with_original_SampleIDs.txt > ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt

conda activate Trinity
Rscript sample2sample_distance_order.R
Rscript Symbiont_ITS2_barplot.R




