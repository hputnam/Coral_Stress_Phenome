


awk -F'\t' '$11<1e-5 && $2!~"^Host" {print $1}' Top_hit_across_DBs.outfmt6.top1 > Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit
awk -F'\t' '$11<1e-5 && $2~"^Host"  {print $1}' Top_hit_across_DBs.outfmt6.top1 > Top_hit_across_DBs.outfmt6.top1.HostTopHit


# wc -l Top_hit_across_DBs.outfmt6.top1*
#  459446 Top_hit_across_DBs.outfmt6.top1
#  217816 Top_hit_across_DBs.outfmt6.top1.HostTopHit
#  238663 Top_hit_across_DBs.outfmt6.top1.SymbiontTopHit
#
# awk -F'\t' '$11<1e-5' Top_hit_across_DBs.outfmt6.top1 | wc -l
# 456479
# awk -F'\t' '$11>1e-5' Top_hit_across_DBs.outfmt6.top1 | wc -l
# 2955



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
#    1293201 Trinity.fasta.salmon.allSamples.numreads.matrix
#    217817 Trinity.fasta.salmon.allSamples.numreads.matrix.justHost
#    238664 Trinity.fasta.salmon.allSamples.numreads.matrix.justSymbiont
#   1075385 Trinity.fasta.salmon.allSamples.numreads.matrix.nonHost		# 1293201 - 217816 = 1075385
#    836722 Trinity.fasta.salmon.allSamples.numreads.matrix.Unknown		# 1293201 - (217816 + 238663) = 836722




conda activate Trinity


## Just Symbiont transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justSymbiont" "samples_Mcapitata.SNPclades.txt" "$MATRIX.justSymbiont.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)

## Just Host transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.justHost" "samples_Mcapitata.SNPclades.txt" "$MATRIX.justHost.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)

## Non-Host transcripts
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.nonHost" "samples_Mcapitata.SNPclades.txt" "$MATRIX.nonHost.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)

## Non-classified transcripts (unknown)
Rscript plot_sample2sample_distances_heatmap.R "$MATRIX.Unknown" "samples_Mcapitata.SNPclades.txt" "$MATRIX.Unknown.SNPclades" <(tac annotations.CladeColors.txt | cut -f2)




## Symbiont ITS2 bar plot
awk 'NR==1 || $1~"Mcapitata"' ITS2_Profiles_with_original_SampleIDs.txt > ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt


## Just Symbiont transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justSymbiont.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Just Host transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.justHost.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Non-Host transcripts
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.nonHost.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"


## Non-classified transcripts (unknown)
ORDER="Trinity.fasta.salmon.allSamples.numreads.matrix.Unknown.SNPclades.minRow10.CPM.log2.sample_cor_matrix.hclust_order.txt"
ITS2="ITS2_Profiles_with_original_SampleIDs.Mcapitata.txt"
Rscript Symbiont_ITS2_barplot.R "$ITS2" "$ORDER" "$ORDER.barplot_ordered_samples.pdf"






