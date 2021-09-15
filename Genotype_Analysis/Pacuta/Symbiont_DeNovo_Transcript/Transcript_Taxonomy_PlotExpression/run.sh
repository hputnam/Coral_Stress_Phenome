


awk -F'\t' '$11<1e-5 && $2!~"^Host" {print $1}' Top_hit_across_DBs.outfmt6.top1 > Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit
awk -F'\t' '$11<1e-5 && $2~"^Host"  {print $1}' Top_hit_across_DBs.outfmt6.top1 > Top_hit_across_DBs.outfmt6.top1.HostTopHit


# wc -l Top_hit_across_DBs.outfmt6.top1*
#  512089 Top_hit_across_DBs.outfmt6.top1
#  261082 Top_hit_across_DBs.outfmt6.top1.HostTopHit
#  248841 Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit
#
# awk -F'\t' '$11<1e-5' Top_hit_across_DBs.outfmt6.top1 | wc -l
# 509923
# awk -F'\t' '$11>1e-5' Top_hit_across_DBs.outfmt6.top1 | wc -l
# 2158


## Remove outliers
grep -v 'Pacuta_HTHC_TP11_2185\|Pacuta_HTAC_TP11_1596\|Pacuta_HTAC_TP11_1582\|Pacuta_ATHC_TP7_2878\|Pacuta_HTHC_TP10_1238\|Pacuta_HTHC_TP11_1416\|Pacuta_HTHC_TP10_2300' "samples_Pacuta.SNPclades.txt" > "samples_Pacuta.SNPclades.outliersRemoved.txt"


MATRIX="Trinity.fasta.salmon.allSamples.numreads.matrix"

## Get just Symbiont transcripts
~/scripts/grepf_column.py --keep_header -i "$MATRIX" -f Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit > "$MATRIX.justSymbiont"
## Get just Host transcripts
~/scripts/grepf_column.py --keep_header -i "$MATRIX" -f Top_hit_across_DBs.outfmt6.top1.HostTopHit > "$MATRIX.justHost"
## Get non-Host transcripts
~/scripts/grepf_column.py --keep_header -i "$MATRIX" -f Top_hit_across_DBs.outfmt6.top1.HostTopHit -v > "$MATRIX.nonHost"
## Get non-classified transcripts (unknown)
~/scripts/grepf_column.py --keep_header -i "$MATRIX" -f <(cat Top_hit_across_DBs.outfmt6.top1.HostTopHit Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit) -v > "$MATRIX.Unknown"

# wc -l Trinity.fasta.salmon.allSamples.numreads.matrix*
#  1066585 Trinity.fasta.salmon.allSamples.numreads.matrix
#   261083 Trinity.fasta.salmon.allSamples.numreads.matrix.justHost
#   248842 Trinity.fasta.salmon.allSamples.numreads.matrix.justSymbiont
#   805503 Trinity.fasta.salmon.allSamples.numreads.matrix.nonHost		# 1066585 - 261082 = 805503
#   556662 Trinity.fasta.salmon.allSamples.numreads.matrix.Unknown		# 1066585 - (261082 + 248841) = 1066585 - 509923 = 556662




conda activate Trinity


## Just Symbiont transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justSymbiont" "samples_Pacuta.SNPclades.txt" "$MATRIX.justSymbiont.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justSymbiont" "samples_Pacuta.SNPclades.outliersRemoved.txt" "$MATRIX.justSymbiont.SNPclades.outliersRemoved" <(tac annotations.CladeColors.txt | cut -f2)

## Just Host transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justHost" "samples_Pacuta.SNPclades.txt" "$MATRIX.justHost.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justHost" "samples_Pacuta.SNPclades.outliersRemoved.txt" "$MATRIX.justHost.SNPclades.outliersRemoved" <(tac annotations.CladeColors.txt | cut -f2)

## Non-Host transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.nonHost" "samples_Pacuta.SNPclades.txt" "$MATRIX.nonHost.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.nonHost" "samples_Pacuta.SNPclades.outliersRemoved.txt" "$MATRIX.nonHost.SNPclades.outliersRemoved" <(tac annotations.CladeColors.txt | cut -f2)

## Non-classified transcripts (unknown)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.Unknown" "samples_Pacuta.SNPclades.txt" "$MATRIX.Unknown.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.Unknown" "samples_Pacuta.SNPclades.outliersRemoved.txt" "$MATRIX.Unknown.SNPclades.outliersRemoved" <(tac annotations.CladeColors.txt | cut -f2)




## Symbiont ITS2 bar plot
awk 'NR==1 || $1~"Pacuta"' ITS2_Profiles_with_original_SampleIDs.txt > ITS2_Profiles_with_original_SampleIDs.Pacuta.txt
grep -v 'Pacuta_HTHC_TP11_2185\|Pacuta_HTAC_TP11_1596\|Pacuta_HTAC_TP11_1582\|Pacuta_ATHC_TP7_2878\|Pacuta_HTHC_TP10_1238\|Pacuta_HTHC_TP11_1416\|Pacuta_HTHC_TP10_2300' \
 ITS2_Profiles_with_original_SampleIDs.Pacuta.txt > ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt


## Just Symbiont transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justSymbiont.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"

ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justSymbiont.SNPclades.outliersRemoved.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Just Host transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justHost.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"

ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justHost.SNPclades.outliersRemoved.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Non-Host transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.nonHost.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"

ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.nonHost.SNPclades.outliersRemoved.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Non-classified transcripts (unknown)
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.Unknown.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"

ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.Unknown.SNPclades.outliersRemoved.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Pacuta.outliersRemoved.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"








