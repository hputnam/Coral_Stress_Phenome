

conda activate r4_env


##
## Allelic depth (AD) plots
##

## Ref genome AD file (ploidy 3)
echo -e "../Genome_short_variant_analysis/filtering/GVCFall_withREF_SNPs.AD_Analysis/GVCFall_withREF_SNPs_DPfilterNoCall.AD.sumSDdenominator/P2185.GT.AD.sumSDdenominator.txt\tPacuta reference genome (Triploid)" > files2plot.txt

## AD files from from Pdamicornis (ploidy 2)
awk -F'\t' '{if($2==2){PLOIDY="Diploid"} else{PLOIDY="Triploid"}; print "../RNAseq_short_variant_analysis/outgroup/P_damicornis_Linnaeus_1758_Indonesia_isolate/variant_analysis_SeparateLibraries/filtering/GVCFall_withOutGroup_SNPs.AD_Analysis/GVCFall_withOutGroup_SNPs_DPfilterNoCall.AD.sumSDdenominator/"$1".GT.AD.sumSDdenominator.txt\tP. damicornis "$1" ("PLOIDY")"}' sample_info.Pdamicornis.txt >> files2plot.txt

## AD files of Pacuta samples (ploidy 2/3)
awk -F'\t' '{if($2==2){PLOIDY="Diploid"} else{PLOIDY="Triploid"}; print "../Genome_short_variant_analysis/filtering/GVCFall_withREF_SNPs.AD_Analysis/GVCFall_withREF_SNPs_DPfilterNoCall.AD.sumSDdenominator/"$1".GT.AD.sumSDdenominator.txt\t"$1" ("PLOIDY")"}' sample_info.Pacuta.txt >> files2plot.txt

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



