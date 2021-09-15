


conda activate Trinity
MATRIX="Trinity.fasta.salmon.allSamples.numreads.matrix"

Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Pacuta.txt" "$MATRIX.Treatment_Timepoints"
Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Pacuta.Treatment.txt" "$MATRIX.Treatment"
Rscript plot_sample2sample_distances_TrinityHeatmap.R "$MATRIX" "samples_Pacuta.SiteName.txt"  "$MATRIX.SiteName"
Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" "samples_Pacuta.SNPclades.txt" "$MATRIX.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)




Rscript plot_sample2sample_distances_TrinityHeatmap_SNPclades.R "$MATRIX" <(grep -v 'Pacuta_HTHC_TP11_2185\|Pacuta_HTAC_TP11_1596\|Pacuta_HTAC_TP11_1582\|Pacuta_ATHC_TP7_2878\|Pacuta_HTHC_TP10_1238\|Pacuta_HTHC_TP11_1416\|Pacuta_HTHC_TP10_2300' "samples_Pacuta.SNPclades.txt") "$MATRIX.SNPclades.outliersRemoved" <(tac annotations.CladeColors.txt | cut -f2)


## Symbiont ITS2 bar plot
awk 'NR==1 || $1~"Pacuta"' ITS2_Profiles_with_original_SampleIDs.txt > ITS2_Profiles_with_original_SampleIDs.Pacuta.txt

conda activate Trinity
Rscript sample2sample_distance_order.R
Rscript Symbiont_ITS2_barplot.R

## With outlier samples removed
grep -v 'Pacuta_HTHC_TP11_2185\|Pacuta_HTAC_TP11_1596\|Pacuta_HTAC_TP11_1582\|Pacuta_ATHC_TP7_2878\|Pacuta_HTHC_TP10_1238\|Pacuta_HTHC_TP11_1416\|Pacuta_HTHC_TP10_2300' "samples_Pacuta.SNPclades.txt" > samples_Pacuta.SNPclades.outliersRemoved.txt
grep -v 'Pacuta_HTHC_TP11_2185\|Pacuta_HTAC_TP11_1596\|Pacuta_HTAC_TP11_1582\|Pacuta_ATHC_TP7_2878\|Pacuta_HTHC_TP10_1238\|Pacuta_HTHC_TP11_1416\|Pacuta_HTHC_TP10_2300' ITS2_Profiles_with_original_SampleIDs.Pacuta.txt > ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt
Rscript sample2sample_distance_order.outliersRemoved.R
Rscript Symbiont_ITS2_barplot.outliersRemoved.R



