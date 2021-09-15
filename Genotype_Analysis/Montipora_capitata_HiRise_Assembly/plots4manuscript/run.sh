


conda activate r4_env



##
## Allelic depth (AD) plots
##

awk -F'\t' '{if($2==2){PLOIDY="Diploid"} else{PLOIDY="Triploid"}; print "../RNAseq_short_variant_analysis/filtering/GVCFall_SNPs.AD_Analysis/GVCFall_SNPs_DPfilterNoCall.AD.sumSDdenominator/"$1".GT.AD.sumSDdenominator.txt\t"$1" ("PLOIDY")"}' sample_info.txt  > files2plot.txt

Rscript plot_AD_scores.R "AllSamples_AD_plots.XaxisLimits" "files2plot.txt" 0.1 0.9 1> "AllSamples_AD_plots.XaxisLimits.log" 2>&1



##
## Variant score plots (used for picking filtering threasholds)
##
SNP_QD_MIN=20.000
SNP_MQ_MIN=50.000
SNP_FS_MAX=5.000
SNP_SOR_MAX=2.500

INDEL_QD_MIN=20.000
INDEL_MQ_MIN=45.000
INDEL_FS_MAX=5.000
INDEL_SOR_MAX=2.500

Rscript plot_variants_scores.R "AllSamples.variants_scores" "../RNAseq_short_variant_analysis/filtering/GVCFall_SNPs.table" "../RNAseq_short_variant_analysis/filtering/GVCFall_INDELs.table" \
        $SNP_QD_MIN $SNP_MQ_MIN $SNP_FS_MAX $SNP_SOR_MAX \
        $INDEL_QD_MIN $INDEL_MQ_MIN $INDEL_FS_MAX $INDEL_SOR_MAX \
        1> "AllSamples.variants_scores.log" 2>&1



##
## Read depth (DP; used for picking filtering threasholds)
##
DP_MIN=20.000
Rscript plot_DP_scores.R "AllSamples.DP" $DP_MIN 100 1> "AllSamples.DP.log" 2>&1




