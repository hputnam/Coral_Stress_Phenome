


## No. unmapped reads. No bases unmapped reads
echo -e "sample_id\tRaw_R1_NoReads\tRaw_R1_NoBases\tRaw_R2_NoReads\tRaw_R2_NoBases" > stats.txt
for ID in $(awk -F'\t' '{printf " %s", $1}' prefixes4samples.txt);
do
        printf "%s\t%s\t%s\t%s\t%s\n" \
               "$ID" \
                $(awk -vID=$ID '$20~"/"ID"_R1.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R1.fastq.gz"{print $3}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2.fastq.gz"{print $1}' read_stats.txt) \
                $(awk -vID=$ID '$20~"/"ID"_R2.fastq.gz"{print $3}' read_stats.txt) 
done >> stats.txt




awk -F'\t' 'NR>1 {print $5"_"$9"_TP"$12"_"$7}' ../04Apr2020_Samples_Batch_2_and_3.txt | sort > prefixes4samples.txt



awk -F'\t' 'NR>1 {print "ln -s ../raw_reads/*/"$7"_R1_001.fastq.gz "$5"_"$9"_TP"$12"_"$7"_R1.fastq.gz"; print "ln -s ../raw_reads/*/"$7"_R2_001.fastq.gz "$5"_"$9"_TP"$12"_"$7"_R2.fastq.gz"; print ""}' ../04Apr2020_Samples_Batch_2_and_3.txt 



ln -s ../raw_reads/*/1041_R1_001.fastq.gz Pacuta_ATAC_TP3_1041_R1.fastq.gz
ln -s ../raw_reads/*/1041_R2_001.fastq.gz Pacuta_ATAC_TP3_1041_R2.fastq.gz

ln -s ../raw_reads/*/1043_R1_001.fastq.gz Pacuta_ATAC_TP1_1043_R1.fastq.gz
ln -s ../raw_reads/*/1043_R2_001.fastq.gz Pacuta_ATAC_TP1_1043_R2.fastq.gz

ln -s ../raw_reads/*/1047_R1_001.fastq.gz Pacuta_ATAC_TP7_1047_R1.fastq.gz
ln -s ../raw_reads/*/1047_R2_001.fastq.gz Pacuta_ATAC_TP7_1047_R2.fastq.gz

ln -s ../raw_reads/*/1050_R1_001.fastq.gz Pacuta_ATAC_TP6_1050_R1.fastq.gz
ln -s ../raw_reads/*/1050_R2_001.fastq.gz Pacuta_ATAC_TP6_1050_R2.fastq.gz

ln -s ../raw_reads/*/1051_R1_001.fastq.gz Pacuta_ATAC_TP8_1051_R1.fastq.gz
ln -s ../raw_reads/*/1051_R2_001.fastq.gz Pacuta_ATAC_TP8_1051_R2.fastq.gz

ln -s ../raw_reads/*/1058_R1_001.fastq.gz Mcapitata_ATAC_TP7_1058_R1.fastq.gz
ln -s ../raw_reads/*/1058_R2_001.fastq.gz Mcapitata_ATAC_TP7_1058_R2.fastq.gz

ln -s ../raw_reads/*/1060_R1_001.fastq.gz Pacuta_ATAC_TP4_1060_R1.fastq.gz
ln -s ../raw_reads/*/1060_R2_001.fastq.gz Pacuta_ATAC_TP4_1060_R2.fastq.gz

ln -s ../raw_reads/*/1074_R1_001.fastq.gz Mcapitata_HTHC_TP10_1074_R1.fastq.gz
ln -s ../raw_reads/*/1074_R2_001.fastq.gz Mcapitata_HTHC_TP10_1074_R2.fastq.gz

ln -s ../raw_reads/*/1090_R1_001.fastq.gz Pacuta_HTHC_TP7_1090_R1.fastq.gz
ln -s ../raw_reads/*/1090_R2_001.fastq.gz Pacuta_HTHC_TP7_1090_R2.fastq.gz

ln -s ../raw_reads/*/1095_R1_001.fastq.gz Mcapitata_ATAC_TP10_1095_R1.fastq.gz
ln -s ../raw_reads/*/1095_R2_001.fastq.gz Mcapitata_ATAC_TP10_1095_R2.fastq.gz

ln -s ../raw_reads/*/1103_R1_001.fastq.gz Pacuta_ATAC_TP11_1103_R1.fastq.gz
ln -s ../raw_reads/*/1103_R2_001.fastq.gz Pacuta_ATAC_TP11_1103_R2.fastq.gz

ln -s ../raw_reads/*/1114_R1_001.fastq.gz Mcapitata_ATAC_TP6_1114_R1.fastq.gz
ln -s ../raw_reads/*/1114_R2_001.fastq.gz Mcapitata_ATAC_TP6_1114_R2.fastq.gz

ln -s ../raw_reads/*/1126_R1_001.fastq.gz Mcapitata_HTHC_TP7_1126_R1.fastq.gz
ln -s ../raw_reads/*/1126_R2_001.fastq.gz Mcapitata_HTHC_TP7_1126_R2.fastq.gz

## EDIT: One sample (1128) was sequenced twice on accident by Genewiz. The good one is 1128 resub.
ln -s ../raw_reads/*/1128-resub_R1_001.fastq.gz Mcapitata_HTHC_TP3_1128_R1.fastq.gz
ln -s ../raw_reads/*/1128-resub_R2_001.fastq.gz Mcapitata_HTHC_TP3_1128_R2.fastq.gz

ln -s ../raw_reads/*/1131_R1_001.fastq.gz Pacuta_HTHC_TP9_1131_R1.fastq.gz
ln -s ../raw_reads/*/1131_R2_001.fastq.gz Pacuta_HTHC_TP9_1131_R2.fastq.gz

ln -s ../raw_reads/*/1138_R1_001.fastq.gz Pacuta_HTHC_TP6_1138_R1.fastq.gz
ln -s ../raw_reads/*/1138_R2_001.fastq.gz Pacuta_HTHC_TP6_1138_R2.fastq.gz

ln -s ../raw_reads/*/1141_R1_001.fastq.gz Pacuta_ATAC_TP9_1141_R1.fastq.gz
ln -s ../raw_reads/*/1141_R2_001.fastq.gz Pacuta_ATAC_TP9_1141_R2.fastq.gz

ln -s ../raw_reads/*/1148_R1_001.fastq.gz Mcapitata_ATHC_TP9_1148_R1.fastq.gz
ln -s ../raw_reads/*/1148_R2_001.fastq.gz Mcapitata_ATHC_TP9_1148_R2.fastq.gz

ln -s ../raw_reads/*/1159_R1_001.fastq.gz Pacuta_ATAC_TP10_1159_R1.fastq.gz
ln -s ../raw_reads/*/1159_R2_001.fastq.gz Pacuta_ATAC_TP10_1159_R2.fastq.gz

ln -s ../raw_reads/*/1164_R1_001.fastq.gz Mcapitata_HTHC_TP6_1164_R1.fastq.gz
ln -s ../raw_reads/*/1164_R2_001.fastq.gz Mcapitata_HTHC_TP6_1164_R2.fastq.gz

ln -s ../raw_reads/*/1168_R1_001.fastq.gz Pacuta_HTHC_TP5_1168_R1.fastq.gz
ln -s ../raw_reads/*/1168_R2_001.fastq.gz Pacuta_HTHC_TP5_1168_R2.fastq.gz

ln -s ../raw_reads/*/1184_R1_001.fastq.gz Pacuta_HTHC_TP8_1184_R1.fastq.gz
ln -s ../raw_reads/*/1184_R2_001.fastq.gz Pacuta_HTHC_TP8_1184_R2.fastq.gz

ln -s ../raw_reads/*/1196_R1_001.fastq.gz Mcapitata_ATAC_TP5_1196_R1.fastq.gz
ln -s ../raw_reads/*/1196_R2_001.fastq.gz Mcapitata_ATAC_TP5_1196_R2.fastq.gz

ln -s ../raw_reads/*/1205_R1_001.fastq.gz Pacuta_ATHC_TP10_1205_R1.fastq.gz
ln -s ../raw_reads/*/1205_R2_001.fastq.gz Pacuta_ATHC_TP10_1205_R2.fastq.gz

ln -s ../raw_reads/*/1219_R1_001.fastq.gz Pacuta_ATHC_TP3_1219_R1.fastq.gz
ln -s ../raw_reads/*/1219_R2_001.fastq.gz Pacuta_ATHC_TP3_1219_R2.fastq.gz

ln -s ../raw_reads/*/1220_R1_001.fastq.gz Pacuta_ATHC_TP4_1220_R1.fastq.gz
ln -s ../raw_reads/*/1220_R2_001.fastq.gz Pacuta_ATHC_TP4_1220_R2.fastq.gz

ln -s ../raw_reads/*/1223_R1_001.fastq.gz Mcapitata_ATHC_TP7_1223_R1.fastq.gz
ln -s ../raw_reads/*/1223_R2_001.fastq.gz Mcapitata_ATHC_TP7_1223_R2.fastq.gz

ln -s ../raw_reads/*/1225_R1_001.fastq.gz Pacuta_HTAC_TP10_1225_R1.fastq.gz
ln -s ../raw_reads/*/1225_R2_001.fastq.gz Pacuta_HTAC_TP10_1225_R2.fastq.gz

ln -s ../raw_reads/*/1227_R1_001.fastq.gz Pacuta_HTHC_TP3_1227_R1.fastq.gz
ln -s ../raw_reads/*/1227_R2_001.fastq.gz Pacuta_HTHC_TP3_1227_R2.fastq.gz

ln -s ../raw_reads/*/1235_R1_001.fastq.gz Mcapitata_HTAC_TP8_1235_R1.fastq.gz
ln -s ../raw_reads/*/1235_R2_001.fastq.gz Mcapitata_HTAC_TP8_1235_R2.fastq.gz

ln -s ../raw_reads/*/1238_R1_001.fastq.gz Pacuta_HTHC_TP10_1238_R1.fastq.gz
ln -s ../raw_reads/*/1238_R2_001.fastq.gz Pacuta_HTHC_TP10_1238_R2.fastq.gz

ln -s ../raw_reads/*/1239_R1_001.fastq.gz Pacuta_HTHC_TP1_1239_R1.fastq.gz
ln -s ../raw_reads/*/1239_R2_001.fastq.gz Pacuta_HTHC_TP1_1239_R2.fastq.gz

ln -s ../raw_reads/*/1246_R1_001.fastq.gz Mcapitata_HTHC_TP8_1246_R1.fastq.gz
ln -s ../raw_reads/*/1246_R2_001.fastq.gz Mcapitata_HTHC_TP8_1246_R2.fastq.gz

ln -s ../raw_reads/*/1250_R1_001.fastq.gz Mcapitata_HTHC_TP7_1250_R1.fastq.gz
ln -s ../raw_reads/*/1250_R2_001.fastq.gz Mcapitata_HTHC_TP7_1250_R2.fastq.gz

ln -s ../raw_reads/*/1254_R1_001.fastq.gz Pacuta_ATHC_TP6_1254_R1.fastq.gz
ln -s ../raw_reads/*/1254_R2_001.fastq.gz Pacuta_ATHC_TP6_1254_R2.fastq.gz

ln -s ../raw_reads/*/1260_R1_001.fastq.gz Mcapitata_ATHC_TP8_1260_R1.fastq.gz
ln -s ../raw_reads/*/1260_R2_001.fastq.gz Mcapitata_ATHC_TP8_1260_R2.fastq.gz

ln -s ../raw_reads/*/1278_R1_001.fastq.gz Mcapitata_HTAC_TP7_1278_R1.fastq.gz
ln -s ../raw_reads/*/1278_R2_001.fastq.gz Mcapitata_HTAC_TP7_1278_R2.fastq.gz

ln -s ../raw_reads/*/1296_R1_001.fastq.gz Pacuta_ATHC_TP5_1296_R1.fastq.gz
ln -s ../raw_reads/*/1296_R2_001.fastq.gz Pacuta_ATHC_TP5_1296_R2.fastq.gz

ln -s ../raw_reads/*/1303_R1_001.fastq.gz Pacuta_HTAC_TP5_1303_R1.fastq.gz
ln -s ../raw_reads/*/1303_R2_001.fastq.gz Pacuta_HTAC_TP5_1303_R2.fastq.gz

ln -s ../raw_reads/*/1306_R1_001.fastq.gz Mcapitata_HTAC_TP9_1306_R1.fastq.gz
ln -s ../raw_reads/*/1306_R2_001.fastq.gz Mcapitata_HTAC_TP9_1306_R2.fastq.gz

ln -s ../raw_reads/*/1317_R1_001.fastq.gz Mcapitata_HTHC_TP6_1317_R1.fastq.gz
ln -s ../raw_reads/*/1317_R2_001.fastq.gz Mcapitata_HTHC_TP6_1317_R2.fastq.gz

ln -s ../raw_reads/*/1323_R1_001.fastq.gz Mcapitata_HTHC_TP1_1323_R1.fastq.gz
ln -s ../raw_reads/*/1323_R2_001.fastq.gz Mcapitata_HTHC_TP1_1323_R2.fastq.gz

ln -s ../raw_reads/*/1330_R1_001.fastq.gz Pacuta_HTAC_TP6_1330_R1.fastq.gz
ln -s ../raw_reads/*/1330_R2_001.fastq.gz Pacuta_HTAC_TP6_1330_R2.fastq.gz

ln -s ../raw_reads/*/1331_R1_001.fastq.gz Mcapitata_HTHC_TP9_1331_R1.fastq.gz
ln -s ../raw_reads/*/1331_R2_001.fastq.gz Mcapitata_HTHC_TP9_1331_R2.fastq.gz

ln -s ../raw_reads/*/1343_R1_001.fastq.gz Pacuta_HTHC_TP4_1343_R1.fastq.gz
ln -s ../raw_reads/*/1343_R2_001.fastq.gz Pacuta_HTHC_TP4_1343_R2.fastq.gz

ln -s ../raw_reads/*/1345_R1_001.fastq.gz Mcapitata_HTHC_TP5_1345_R1.fastq.gz
ln -s ../raw_reads/*/1345_R2_001.fastq.gz Mcapitata_HTHC_TP5_1345_R2.fastq.gz

ln -s ../raw_reads/*/1415_R1_001.fastq.gz Pacuta_HTHC_TP5_1415_R1.fastq.gz
ln -s ../raw_reads/*/1415_R2_001.fastq.gz Pacuta_HTHC_TP5_1415_R2.fastq.gz

ln -s ../raw_reads/*/1418_R1_001.fastq.gz Pacuta_HTHC_TP3_1418_R1.fastq.gz
ln -s ../raw_reads/*/1418_R2_001.fastq.gz Pacuta_HTHC_TP3_1418_R2.fastq.gz

ln -s ../raw_reads/*/1420_R1_001.fastq.gz Mcapitata_ATAC_TP9_1420_R1.fastq.gz
ln -s ../raw_reads/*/1420_R2_001.fastq.gz Mcapitata_ATAC_TP9_1420_R2.fastq.gz

ln -s ../raw_reads/*/1427_R1_001.fastq.gz Pacuta_HTHC_TP7_1427_R1.fastq.gz
ln -s ../raw_reads/*/1427_R2_001.fastq.gz Pacuta_HTHC_TP7_1427_R2.fastq.gz

ln -s ../raw_reads/*/1436_R1_001.fastq.gz Mcapitata_ATAC_TP8_1436_R1.fastq.gz
ln -s ../raw_reads/*/1436_R2_001.fastq.gz Mcapitata_ATAC_TP8_1436_R2.fastq.gz

ln -s ../raw_reads/*/1451_R1_001.fastq.gz Pacuta_ATHC_TP9_1451_R1.fastq.gz
ln -s ../raw_reads/*/1451_R2_001.fastq.gz Pacuta_ATHC_TP9_1451_R2.fastq.gz

ln -s ../raw_reads/*/1459_R1_001.fastq.gz Pacuta_ATHC_TP8_1459_R1.fastq.gz
ln -s ../raw_reads/*/1459_R2_001.fastq.gz Pacuta_ATHC_TP8_1459_R2.fastq.gz

ln -s ../raw_reads/*/1466_R1_001.fastq.gz Pacuta_HTAC_TP6_1466_R1.fastq.gz
ln -s ../raw_reads/*/1466_R2_001.fastq.gz Pacuta_HTAC_TP6_1466_R2.fastq.gz

ln -s ../raw_reads/*/1471_R1_001.fastq.gz Pacuta_ATAC_TP3_1471_R1.fastq.gz
ln -s ../raw_reads/*/1471_R2_001.fastq.gz Pacuta_ATAC_TP3_1471_R2.fastq.gz

ln -s ../raw_reads/*/1478_R1_001.fastq.gz Mcapitata_HTAC_TP10_1478_R1.fastq.gz
ln -s ../raw_reads/*/1478_R2_001.fastq.gz Mcapitata_HTAC_TP10_1478_R2.fastq.gz

ln -s ../raw_reads/*/1486_R1_001.fastq.gz Pacuta_HTAC_TP9_1486_R1.fastq.gz
ln -s ../raw_reads/*/1486_R2_001.fastq.gz Pacuta_HTAC_TP9_1486_R2.fastq.gz

ln -s ../raw_reads/*/1487_R1_001.fastq.gz Pacuta_HTAC_TP7_1487_R1.fastq.gz
ln -s ../raw_reads/*/1487_R2_001.fastq.gz Pacuta_HTAC_TP7_1487_R2.fastq.gz

ln -s ../raw_reads/*/1496_R1_001.fastq.gz Mcapitata_HTAC_TP6_1496_R1.fastq.gz
ln -s ../raw_reads/*/1496_R2_001.fastq.gz Mcapitata_HTAC_TP6_1496_R2.fastq.gz

ln -s ../raw_reads/*/1499_R1_001.fastq.gz Mcapitata_ATAC_TP7_1499_R1.fastq.gz
ln -s ../raw_reads/*/1499_R2_001.fastq.gz Mcapitata_ATAC_TP7_1499_R2.fastq.gz

ln -s ../raw_reads/*/1536_R1_001.fastq.gz Pacuta_HTAC_TP10_1536_R1.fastq.gz
ln -s ../raw_reads/*/1536_R2_001.fastq.gz Pacuta_HTAC_TP10_1536_R2.fastq.gz

ln -s ../raw_reads/*/1542_R1_001.fastq.gz Pacuta_ATAC_TP6_1542_R1.fastq.gz
ln -s ../raw_reads/*/1542_R2_001.fastq.gz Pacuta_ATAC_TP6_1542_R2.fastq.gz

ln -s ../raw_reads/*/1544_R1_001.fastq.gz Mcapitata_ATHC_TP3_1544_R1.fastq.gz
ln -s ../raw_reads/*/1544_R2_001.fastq.gz Mcapitata_ATHC_TP3_1544_R2.fastq.gz

ln -s ../raw_reads/*/1559_R1_001.fastq.gz Pacuta_ATAC_TP10_1559_R1.fastq.gz
ln -s ../raw_reads/*/1559_R2_001.fastq.gz Pacuta_ATAC_TP10_1559_R2.fastq.gz

ln -s ../raw_reads/*/1561_R1_001.fastq.gz Mcapitata_ATAC_TP10_1561_R1.fastq.gz
ln -s ../raw_reads/*/1561_R2_001.fastq.gz Mcapitata_ATAC_TP10_1561_R2.fastq.gz

ln -s ../raw_reads/*/1580_R1_001.fastq.gz Mcapitata_ATAC_TP9_1580_R1.fastq.gz
ln -s ../raw_reads/*/1580_R2_001.fastq.gz Mcapitata_ATAC_TP9_1580_R2.fastq.gz

ln -s ../raw_reads/*/1594_R1_001.fastq.gz Pacuta_ATAC_TP9_1594_R1.fastq.gz
ln -s ../raw_reads/*/1594_R2_001.fastq.gz Pacuta_ATAC_TP9_1594_R2.fastq.gz

ln -s ../raw_reads/*/1595_R1_001.fastq.gz Pacuta_HTHC_TP6_1595_R1.fastq.gz
ln -s ../raw_reads/*/1595_R2_001.fastq.gz Pacuta_HTHC_TP6_1595_R2.fastq.gz

ln -s ../raw_reads/*/1600_R1_001.fastq.gz Mcapitata_ATAC_TP1_1600_R1.fastq.gz
ln -s ../raw_reads/*/1600_R2_001.fastq.gz Mcapitata_ATAC_TP1_1600_R2.fastq.gz

ln -s ../raw_reads/*/1617_R1_001.fastq.gz Pacuta_HTAC_TP3_1617_R1.fastq.gz
ln -s ../raw_reads/*/1617_R2_001.fastq.gz Pacuta_HTAC_TP3_1617_R2.fastq.gz

ln -s ../raw_reads/*/1631_R1_001.fastq.gz Mcapitata_ATAC_TP10_1631_R1.fastq.gz
ln -s ../raw_reads/*/1631_R2_001.fastq.gz Mcapitata_ATAC_TP10_1631_R2.fastq.gz

ln -s ../raw_reads/*/1637_R1_001.fastq.gz Pacuta_ATAC_TP3_1637_R1.fastq.gz
ln -s ../raw_reads/*/1637_R2_001.fastq.gz Pacuta_ATAC_TP3_1637_R2.fastq.gz

ln -s ../raw_reads/*/1641_R1_001.fastq.gz Pacuta_ATAC_TP10_1641_R1.fastq.gz
ln -s ../raw_reads/*/1641_R2_001.fastq.gz Pacuta_ATAC_TP10_1641_R2.fastq.gz

ln -s ../raw_reads/*/1644_R1_001.fastq.gz Mcapitata_ATAC_TP11_1644_R1.fastq.gz
ln -s ../raw_reads/*/1644_R2_001.fastq.gz Mcapitata_ATAC_TP11_1644_R2.fastq.gz

ln -s ../raw_reads/*/1676_R1_001.fastq.gz Pacuta_HTHC_TP1_1676_R1.fastq.gz
ln -s ../raw_reads/*/1676_R2_001.fastq.gz Pacuta_HTHC_TP1_1676_R2.fastq.gz

ln -s ../raw_reads/*/1705_R1_001.fastq.gz Mcapitata_HTAC_TP6_1705_R1.fastq.gz
ln -s ../raw_reads/*/1705_R2_001.fastq.gz Mcapitata_HTAC_TP6_1705_R2.fastq.gz

ln -s ../raw_reads/*/1721_R1_001.fastq.gz Pacuta_HTHC_TP6_1721_R1.fastq.gz
ln -s ../raw_reads/*/1721_R2_001.fastq.gz Pacuta_HTHC_TP6_1721_R2.fastq.gz

ln -s ../raw_reads/*/1728_R1_001.fastq.gz Pacuta_HTAC_TP7_1728_R1.fastq.gz
ln -s ../raw_reads/*/1728_R2_001.fastq.gz Pacuta_HTAC_TP7_1728_R2.fastq.gz

ln -s ../raw_reads/*/1732_R1_001.fastq.gz Pacuta_HTHC_TP10_1732_R1.fastq.gz
ln -s ../raw_reads/*/1732_R2_001.fastq.gz Pacuta_HTHC_TP10_1732_R2.fastq.gz

ln -s ../raw_reads/*/1744_R1_001.fastq.gz Pacuta_HTAC_TP6_1744_R1.fastq.gz
ln -s ../raw_reads/*/1744_R2_001.fastq.gz Pacuta_HTAC_TP6_1744_R2.fastq.gz

ln -s ../raw_reads/*/1751_R1_001.fastq.gz Mcapitata_HTAC_TP3_1751_R1.fastq.gz
ln -s ../raw_reads/*/1751_R2_001.fastq.gz Mcapitata_HTAC_TP3_1751_R2.fastq.gz

ln -s ../raw_reads/*/1754_R1_001.fastq.gz Mcapitata_HTAC_TP10_1754_R1.fastq.gz
ln -s ../raw_reads/*/1754_R2_001.fastq.gz Mcapitata_HTAC_TP10_1754_R2.fastq.gz

ln -s ../raw_reads/*/1755_R1_001.fastq.gz Pacuta_ATAC_TP8_1755_R1.fastq.gz
ln -s ../raw_reads/*/1755_R2_001.fastq.gz Pacuta_ATAC_TP8_1755_R2.fastq.gz

ln -s ../raw_reads/*/1757_R1_001.fastq.gz Pacuta_ATAC_TP5_1757_R1.fastq.gz
ln -s ../raw_reads/*/1757_R2_001.fastq.gz Pacuta_ATAC_TP5_1757_R2.fastq.gz

ln -s ../raw_reads/*/1765_R1_001.fastq.gz Pacuta_HTAC_TP8_1765_R1.fastq.gz
ln -s ../raw_reads/*/1765_R2_001.fastq.gz Pacuta_HTAC_TP8_1765_R2.fastq.gz

ln -s ../raw_reads/*/1767_R1_001.fastq.gz Pacuta_HTAC_TP4_1767_R1.fastq.gz
ln -s ../raw_reads/*/1767_R2_001.fastq.gz Pacuta_HTAC_TP4_1767_R2.fastq.gz

ln -s ../raw_reads/*/1775_R1_001.fastq.gz Pacuta_ATAC_TP1_1775_R1.fastq.gz
ln -s ../raw_reads/*/1775_R2_001.fastq.gz Pacuta_ATAC_TP1_1775_R2.fastq.gz

ln -s ../raw_reads/*/1776_R1_001.fastq.gz Mcapitata_ATAC_TP5_1776_R1.fastq.gz
ln -s ../raw_reads/*/1776_R2_001.fastq.gz Mcapitata_ATAC_TP5_1776_R2.fastq.gz

ln -s ../raw_reads/*/1779_R1_001.fastq.gz Mcapitata_ATAC_TP8_1779_R1.fastq.gz
ln -s ../raw_reads/*/1779_R2_001.fastq.gz Mcapitata_ATAC_TP8_1779_R2.fastq.gz

ln -s ../raw_reads/*/1820_R1_001.fastq.gz Pacuta_HTHC_TP7_1820_R1.fastq.gz
ln -s ../raw_reads/*/1820_R2_001.fastq.gz Pacuta_HTHC_TP7_1820_R2.fastq.gz

ln -s ../raw_reads/*/1826_R1_001.fastq.gz Mcapitata_ATHC_TP1_1826_R1.fastq.gz
ln -s ../raw_reads/*/1826_R2_001.fastq.gz Mcapitata_ATHC_TP1_1826_R2.fastq.gz

ln -s ../raw_reads/*/2005_R1_001.fastq.gz Pacuta_HTAC_TP1_2005_R1.fastq.gz
ln -s ../raw_reads/*/2005_R2_001.fastq.gz Pacuta_HTAC_TP1_2005_R2.fastq.gz

ln -s ../raw_reads/*/2012_R1_001.fastq.gz Pacuta_ATAC_TP8_2012_R1.fastq.gz
ln -s ../raw_reads/*/2012_R2_001.fastq.gz Pacuta_ATAC_TP8_2012_R2.fastq.gz

ln -s ../raw_reads/*/2026_R1_001.fastq.gz Pacuta_HTAC_TP3_2026_R1.fastq.gz
ln -s ../raw_reads/*/2026_R2_001.fastq.gz Pacuta_HTAC_TP3_2026_R2.fastq.gz

ln -s ../raw_reads/*/2064_R1_001.fastq.gz Pacuta_HTAC_TP10_2064_R1.fastq.gz
ln -s ../raw_reads/*/2064_R2_001.fastq.gz Pacuta_HTAC_TP10_2064_R2.fastq.gz

ln -s ../raw_reads/*/2068_R1_001.fastq.gz Mcapitata_ATHC_TP1_2068_R1.fastq.gz
ln -s ../raw_reads/*/2068_R2_001.fastq.gz Mcapitata_ATHC_TP1_2068_R2.fastq.gz

ln -s ../raw_reads/*/2072_R1_001.fastq.gz Pacuta_HTAC_TP7_2072_R1.fastq.gz
ln -s ../raw_reads/*/2072_R2_001.fastq.gz Pacuta_HTAC_TP7_2072_R2.fastq.gz

ln -s ../raw_reads/*/2081_R1_001.fastq.gz Mcapitata_HTHC_TP1_2081_R1.fastq.gz
ln -s ../raw_reads/*/2081_R2_001.fastq.gz Mcapitata_HTHC_TP1_2081_R2.fastq.gz

ln -s ../raw_reads/*/2183_R1_001.fastq.gz Mcapitata_HTAC_TP1_2183_R1.fastq.gz
ln -s ../raw_reads/*/2183_R2_001.fastq.gz Mcapitata_HTAC_TP1_2183_R2.fastq.gz

ln -s ../raw_reads/*/2197_R1_001.fastq.gz Pacuta_ATHC_TP10_2197_R1.fastq.gz
ln -s ../raw_reads/*/2197_R2_001.fastq.gz Pacuta_ATHC_TP10_2197_R2.fastq.gz

ln -s ../raw_reads/*/2202_R1_001.fastq.gz Pacuta_HTHC_TP9_2202_R1.fastq.gz
ln -s ../raw_reads/*/2202_R2_001.fastq.gz Pacuta_HTHC_TP9_2202_R2.fastq.gz

ln -s ../raw_reads/*/2204_R1_001.fastq.gz Mcapitata_HTHC_TP4_2204_R1.fastq.gz
ln -s ../raw_reads/*/2204_R2_001.fastq.gz Mcapitata_HTHC_TP4_2204_R2.fastq.gz

ln -s ../raw_reads/*/2300_R1_001.fastq.gz Pacuta_HTHC_TP10_2300_R1.fastq.gz
ln -s ../raw_reads/*/2300_R2_001.fastq.gz Pacuta_HTHC_TP10_2300_R2.fastq.gz

ln -s ../raw_reads/*/2304_R1_001.fastq.gz Pacuta_HTHC_TP8_2304_R1.fastq.gz
ln -s ../raw_reads/*/2304_R2_001.fastq.gz Pacuta_HTHC_TP8_2304_R2.fastq.gz

ln -s ../raw_reads/*/2305_R1_001.fastq.gz Pacuta_HTHC_TP9_2305_R1.fastq.gz
ln -s ../raw_reads/*/2305_R2_001.fastq.gz Pacuta_HTHC_TP9_2305_R2.fastq.gz

ln -s ../raw_reads/*/2357_R1_001.fastq.gz Pacuta_ATAC_TP9_2357_R1.fastq.gz
ln -s ../raw_reads/*/2357_R2_001.fastq.gz Pacuta_ATAC_TP9_2357_R2.fastq.gz

ln -s ../raw_reads/*/2363_R1_001.fastq.gz Pacuta_ATAC_TP1_2363_R1.fastq.gz
ln -s ../raw_reads/*/2363_R2_001.fastq.gz Pacuta_ATAC_TP1_2363_R2.fastq.gz

ln -s ../raw_reads/*/2386_R1_001.fastq.gz Mcapitata_HTAC_TP8_2386_R1.fastq.gz
ln -s ../raw_reads/*/2386_R2_001.fastq.gz Mcapitata_HTAC_TP8_2386_R2.fastq.gz

ln -s ../raw_reads/*/2409_R1_001.fastq.gz Pacuta_ATHC_TP7_2409_R1.fastq.gz
ln -s ../raw_reads/*/2409_R2_001.fastq.gz Pacuta_ATHC_TP7_2409_R2.fastq.gz

ln -s ../raw_reads/*/2412_R1_001.fastq.gz Mcapitata_HTAC_TP9_2412_R1.fastq.gz
ln -s ../raw_reads/*/2412_R2_001.fastq.gz Mcapitata_HTAC_TP9_2412_R2.fastq.gz

ln -s ../raw_reads/*/2413_R1_001.fastq.gz Pacuta_ATAC_TP7_2413_R1.fastq.gz
ln -s ../raw_reads/*/2413_R2_001.fastq.gz Pacuta_ATAC_TP7_2413_R2.fastq.gz

ln -s ../raw_reads/*/2414_R1_001.fastq.gz Pacuta_HTAC_TP1_2414_R1.fastq.gz
ln -s ../raw_reads/*/2414_R2_001.fastq.gz Pacuta_HTAC_TP1_2414_R2.fastq.gz

ln -s ../raw_reads/*/2513_R1_001.fastq.gz Pacuta_HTAC_TP8_2513_R1.fastq.gz
ln -s ../raw_reads/*/2513_R2_001.fastq.gz Pacuta_HTAC_TP8_2513_R2.fastq.gz

ln -s ../raw_reads/*/2518_R1_001.fastq.gz Mcapitata_HTHC_TP3_2518_R1.fastq.gz
ln -s ../raw_reads/*/2518_R2_001.fastq.gz Mcapitata_HTHC_TP3_2518_R2.fastq.gz

ln -s ../raw_reads/*/2527_R1_001.fastq.gz Pacuta_HTHC_TP3_2527_R1.fastq.gz
ln -s ../raw_reads/*/2527_R2_001.fastq.gz Pacuta_HTHC_TP3_2527_R2.fastq.gz

ln -s ../raw_reads/*/2550_R1_001.fastq.gz Pacuta_ATHC_TP10_2550_R1.fastq.gz
ln -s ../raw_reads/*/2550_R2_001.fastq.gz Pacuta_ATHC_TP10_2550_R2.fastq.gz

ln -s ../raw_reads/*/2554_R1_001.fastq.gz Mcapitata_ATHC_TP10_2554_R1.fastq.gz
ln -s ../raw_reads/*/2554_R2_001.fastq.gz Mcapitata_ATHC_TP10_2554_R2.fastq.gz

ln -s ../raw_reads/*/2561_R1_001.fastq.gz Mcapitata_ATHC_TP4_2561_R1.fastq.gz
ln -s ../raw_reads/*/2561_R2_001.fastq.gz Mcapitata_ATHC_TP4_2561_R2.fastq.gz

ln -s ../raw_reads/*/2743_R1_001.fastq.gz Pacuta_ATHC_TP1_2743_R1.fastq.gz
ln -s ../raw_reads/*/2743_R2_001.fastq.gz Pacuta_ATHC_TP1_2743_R2.fastq.gz

ln -s ../raw_reads/*/2860_R1_001.fastq.gz Mcapitata_ATHC_TP7_2860_R1.fastq.gz
ln -s ../raw_reads/*/2860_R2_001.fastq.gz Mcapitata_ATHC_TP7_2860_R2.fastq.gz

ln -s ../raw_reads/*/2861_R1_001.fastq.gz Pacuta_ATHC_TP8_2861_R1.fastq.gz
ln -s ../raw_reads/*/2861_R2_001.fastq.gz Pacuta_ATHC_TP8_2861_R2.fastq.gz

ln -s ../raw_reads/*/2862_R1_001.fastq.gz Mcapitata_ATHC_TP9_2862_R1.fastq.gz
ln -s ../raw_reads/*/2862_R2_001.fastq.gz Mcapitata_ATHC_TP9_2862_R2.fastq.gz

ln -s ../raw_reads/*/2866_R1_001.fastq.gz Mcapitata_ATHC_TP3_2866_R1.fastq.gz
ln -s ../raw_reads/*/2866_R2_001.fastq.gz Mcapitata_ATHC_TP3_2866_R2.fastq.gz

ln -s ../raw_reads/*/2870_R1_001.fastq.gz Pacuta_ATHC_TP6_2870_R1.fastq.gz
ln -s ../raw_reads/*/2870_R2_001.fastq.gz Pacuta_ATHC_TP6_2870_R2.fastq.gz

ln -s ../raw_reads/*/2873_R1_001.fastq.gz Pacuta_ATHC_TP9_2873_R1.fastq.gz
ln -s ../raw_reads/*/2873_R2_001.fastq.gz Pacuta_ATHC_TP9_2873_R2.fastq.gz

ln -s ../raw_reads/*/2875_R1_001.fastq.gz Mcapitata_ATHC_TP7_2875_R1.fastq.gz
ln -s ../raw_reads/*/2875_R2_001.fastq.gz Mcapitata_ATHC_TP7_2875_R2.fastq.gz

ln -s ../raw_reads/*/2877_R1_001.fastq.gz Pacuta_ATHC_TP5_2877_R1.fastq.gz
ln -s ../raw_reads/*/2877_R2_001.fastq.gz Pacuta_ATHC_TP5_2877_R2.fastq.gz

ln -s ../raw_reads/*/2878_R1_001.fastq.gz Pacuta_ATHC_TP7_2878_R1.fastq.gz
ln -s ../raw_reads/*/2878_R2_001.fastq.gz Pacuta_ATHC_TP7_2878_R2.fastq.gz

ln -s ../raw_reads/*/2977_R1_001.fastq.gz Pacuta_ATHC_TP1_2977_R1.fastq.gz
ln -s ../raw_reads/*/2977_R2_001.fastq.gz Pacuta_ATHC_TP1_2977_R2.fastq.gz

ln -s ../raw_reads/*/2979_R1_001.fastq.gz Pacuta_ATHC_TP9_2979_R1.fastq.gz
ln -s ../raw_reads/*/2979_R2_001.fastq.gz Pacuta_ATHC_TP9_2979_R2.fastq.gz

ln -s ../raw_reads/*/2993_R1_001.fastq.gz Pacuta_ATHC_TP4_2993_R1.fastq.gz
ln -s ../raw_reads/*/2993_R2_001.fastq.gz Pacuta_ATHC_TP4_2993_R2.fastq.gz

ln -s ../raw_reads/*/2995_R1_001.fastq.gz Mcapitata_ATHC_TP9_2995_R1.fastq.gz
ln -s ../raw_reads/*/2995_R2_001.fastq.gz Mcapitata_ATHC_TP9_2995_R2.fastq.gz

ln -s ../raw_reads/*/2999_R1_001.fastq.gz Pacuta_ATHC_TP6_2999_R1.fastq.gz
ln -s ../raw_reads/*/2999_R2_001.fastq.gz Pacuta_ATHC_TP6_2999_R2.fastq.gz

ln -s ../raw_reads/*/1037_R1_001.fastq.gz Mcapitata_ATAC_TP1_1037_R1.fastq.gz
ln -s ../raw_reads/*/1037_R2_001.fastq.gz Mcapitata_ATAC_TP1_1037_R2.fastq.gz

ln -s ../raw_reads/*/1059_R1_001.fastq.gz Pacuta_ATAC_TP5_1059_R1.fastq.gz
ln -s ../raw_reads/*/1059_R2_001.fastq.gz Pacuta_ATAC_TP5_1059_R2.fastq.gz

ln -s ../raw_reads/*/1076_R1_001.fastq.gz Mcapitata_ATAC_TP11_1076_R1.fastq.gz
ln -s ../raw_reads/*/1076_R2_001.fastq.gz Mcapitata_ATAC_TP11_1076_R2.fastq.gz

ln -s ../raw_reads/*/1078_R1_001.fastq.gz Mcapitata_HTHC_TP9_1078_R1.fastq.gz
ln -s ../raw_reads/*/1078_R2_001.fastq.gz Mcapitata_HTHC_TP9_1078_R2.fastq.gz

ln -s ../raw_reads/*/1082_R1_001.fastq.gz Mcapitata_HTHC_TP8_1082_R1.fastq.gz
ln -s ../raw_reads/*/1082_R2_001.fastq.gz Mcapitata_HTHC_TP8_1082_R2.fastq.gz

ln -s ../raw_reads/*/1083_R1_001.fastq.gz Mcapitata_ATAC_TP8_1083_R1.fastq.gz
ln -s ../raw_reads/*/1083_R2_001.fastq.gz Mcapitata_ATAC_TP8_1083_R2.fastq.gz

ln -s ../raw_reads/*/1101_R1_001.fastq.gz Mcapitata_ATAC_TP3_1101_R1.fastq.gz
ln -s ../raw_reads/*/1101_R2_001.fastq.gz Mcapitata_ATAC_TP3_1101_R2.fastq.gz

ln -s ../raw_reads/*/1108_R1_001.fastq.gz Mcapitata_ATAC_TP4_1108_R1.fastq.gz
ln -s ../raw_reads/*/1108_R2_001.fastq.gz Mcapitata_ATAC_TP4_1108_R2.fastq.gz

ln -s ../raw_reads/*/1120_R1_001.fastq.gz Mcapitata_ATAC_TP12_1120_R1.fastq.gz
ln -s ../raw_reads/*/1120_R2_001.fastq.gz Mcapitata_ATAC_TP12_1120_R2.fastq.gz

ln -s ../raw_reads/*/1121_R1_001.fastq.gz Mcapitata_ATAC_TP9_1121_R1.fastq.gz
ln -s ../raw_reads/*/1121_R2_001.fastq.gz Mcapitata_ATAC_TP9_1121_R2.fastq.gz

ln -s ../raw_reads/*/1124_R1_001.fastq.gz Mcapitata_HTHC_TP4_1124_R1.fastq.gz
ln -s ../raw_reads/*/1124_R2_001.fastq.gz Mcapitata_HTHC_TP4_1124_R2.fastq.gz

ln -s ../raw_reads/*/1140_R1_001.fastq.gz Mcapitata_HTHC_TP12_1140_R1.fastq.gz
ln -s ../raw_reads/*/1140_R2_001.fastq.gz Mcapitata_HTHC_TP12_1140_R2.fastq.gz

ln -s ../raw_reads/*/1145_R1_001.fastq.gz Mcapitata_HTHC_TP1_1145_R1.fastq.gz
ln -s ../raw_reads/*/1145_R2_001.fastq.gz Mcapitata_HTHC_TP1_1145_R2.fastq.gz

ln -s ../raw_reads/*/1147_R1_001.fastq.gz Pacuta_ATHC_TP11_1147_R1.fastq.gz
ln -s ../raw_reads/*/1147_R2_001.fastq.gz Pacuta_ATHC_TP11_1147_R2.fastq.gz

ln -s ../raw_reads/*/1154_R1_001.fastq.gz Mcapitata_ATHC_TP12_1154_R1.fastq.gz
ln -s ../raw_reads/*/1154_R2_001.fastq.gz Mcapitata_ATHC_TP12_1154_R2.fastq.gz

ln -s ../raw_reads/*/1169_R1_001.fastq.gz Pacuta_HTHC_TP4_1169_R1.fastq.gz
ln -s ../raw_reads/*/1169_R2_001.fastq.gz Pacuta_HTHC_TP4_1169_R2.fastq.gz

ln -s ../raw_reads/*/1178_R1_001.fastq.gz Mcapitata_HTHC_TP11_1178_R1.fastq.gz
ln -s ../raw_reads/*/1178_R2_001.fastq.gz Mcapitata_HTHC_TP11_1178_R2.fastq.gz

ln -s ../raw_reads/*/1204_R1_001.fastq.gz Mcapitata_ATHC_TP10_1204_R1.fastq.gz
ln -s ../raw_reads/*/1204_R2_001.fastq.gz Mcapitata_ATHC_TP10_1204_R2.fastq.gz

ln -s ../raw_reads/*/1207_R1_001.fastq.gz Pacuta_ATHC_TP1_1207_R1.fastq.gz
ln -s ../raw_reads/*/1207_R2_001.fastq.gz Pacuta_ATHC_TP1_1207_R2.fastq.gz

ln -s ../raw_reads/*/1212_R1_001.fastq.gz Mcapitata_ATHC_TP6_1212_R1.fastq.gz
ln -s ../raw_reads/*/1212_R2_001.fastq.gz Mcapitata_ATHC_TP6_1212_R2.fastq.gz

ln -s ../raw_reads/*/1218_R1_001.fastq.gz Mcapitata_ATHC_TP1_1218_R1.fastq.gz
ln -s ../raw_reads/*/1218_R2_001.fastq.gz Mcapitata_ATHC_TP1_1218_R2.fastq.gz

ln -s ../raw_reads/*/1221_R1_001.fastq.gz Mcapitata_ATHC_TP4_1221_R1.fastq.gz
ln -s ../raw_reads/*/1221_R2_001.fastq.gz Mcapitata_ATHC_TP4_1221_R2.fastq.gz

ln -s ../raw_reads/*/1229_R1_001.fastq.gz Mcapitata_ATHC_TP5_1229_R1.fastq.gz
ln -s ../raw_reads/*/1229_R2_001.fastq.gz Mcapitata_ATHC_TP5_1229_R2.fastq.gz

ln -s ../raw_reads/*/1237_R1_001.fastq.gz Mcapitata_ATHC_TP11_1237_R1.fastq.gz
ln -s ../raw_reads/*/1237_R2_001.fastq.gz Mcapitata_ATHC_TP11_1237_R2.fastq.gz

ln -s ../raw_reads/*/1248_R1_001.fastq.gz Mcapitata_HTAC_TP11_1248_R1.fastq.gz
ln -s ../raw_reads/*/1248_R2_001.fastq.gz Mcapitata_HTAC_TP11_1248_R2.fastq.gz

ln -s ../raw_reads/*/1269_R1_001.fastq.gz Mcapitata_HTAC_TP4_1269_R1.fastq.gz
ln -s ../raw_reads/*/1269_R2_001.fastq.gz Mcapitata_HTAC_TP4_1269_R2.fastq.gz

ln -s ../raw_reads/*/1270_R1_001.fastq.gz Mcapitata_HTHC_TP11_1270_R1.fastq.gz
ln -s ../raw_reads/*/1270_R2_001.fastq.gz Mcapitata_HTHC_TP11_1270_R2.fastq.gz

ln -s ../raw_reads/*/1274_R1_001.fastq.gz Mcapitata_HTHC_TP12_1274_R1.fastq.gz
ln -s ../raw_reads/*/1274_R2_001.fastq.gz Mcapitata_HTHC_TP12_1274_R2.fastq.gz

ln -s ../raw_reads/*/1277_R1_001.fastq.gz Mcapitata_HTHC_TP3_1277_R1.fastq.gz
ln -s ../raw_reads/*/1277_R2_001.fastq.gz Mcapitata_HTHC_TP3_1277_R2.fastq.gz

ln -s ../raw_reads/*/1281_R1_001.fastq.gz Pacuta_ATHC_TP7_1281_R1.fastq.gz
ln -s ../raw_reads/*/1281_R2_001.fastq.gz Pacuta_ATHC_TP7_1281_R2.fastq.gz

ln -s ../raw_reads/*/1289_R1_001.fastq.gz Mcapitata_HTAC_TP3_1289_R1.fastq.gz
ln -s ../raw_reads/*/1289_R2_001.fastq.gz Mcapitata_HTAC_TP3_1289_R2.fastq.gz

ln -s ../raw_reads/*/1302_R1_001.fastq.gz Pacuta_HTAC_TP9_1302_R1.fastq.gz
ln -s ../raw_reads/*/1302_R2_001.fastq.gz Pacuta_HTAC_TP9_1302_R2.fastq.gz

ln -s ../raw_reads/*/1315_R1_001.fastq.gz Mcapitata_HTAC_TP10_1315_R1.fastq.gz
ln -s ../raw_reads/*/1315_R2_001.fastq.gz Mcapitata_HTAC_TP10_1315_R2.fastq.gz

ln -s ../raw_reads/*/1321_R1_001.fastq.gz Mcapitata_HTAC_TP5_1321_R1.fastq.gz
ln -s ../raw_reads/*/1321_R2_001.fastq.gz Mcapitata_HTAC_TP5_1321_R2.fastq.gz

ln -s ../raw_reads/*/1328_R1_001.fastq.gz Mcapitata_HTHC_TP4_1328_R1.fastq.gz
ln -s ../raw_reads/*/1328_R2_001.fastq.gz Mcapitata_HTHC_TP4_1328_R2.fastq.gz

ln -s ../raw_reads/*/1329_R1_001.fastq.gz Pacuta_HTAC_TP8_1329_R1.fastq.gz
ln -s ../raw_reads/*/1329_R2_001.fastq.gz Pacuta_HTAC_TP8_1329_R2.fastq.gz

ln -s ../raw_reads/*/1332_R1_001.fastq.gz Mcapitata_HTHC_TP10_1332_R1.fastq.gz
ln -s ../raw_reads/*/1332_R2_001.fastq.gz Mcapitata_HTHC_TP10_1332_R2.fastq.gz

ln -s ../raw_reads/*/1416_R1_001.fastq.gz Pacuta_HTHC_TP11_1416_R1.fastq.gz
ln -s ../raw_reads/*/1416_R2_001.fastq.gz Pacuta_HTHC_TP11_1416_R2.fastq.gz

ln -s ../raw_reads/*/1445_R1_001.fastq.gz Pacuta_ATAC_TP7_1445_R1.fastq.gz
ln -s ../raw_reads/*/1445_R2_001.fastq.gz Pacuta_ATAC_TP7_1445_R2.fastq.gz

ln -s ../raw_reads/*/1449_R1_001.fastq.gz Mcapitata_HTHC_TP5_1449_R1.fastq.gz
ln -s ../raw_reads/*/1449_R2_001.fastq.gz Mcapitata_HTHC_TP5_1449_R2.fastq.gz

ln -s ../raw_reads/*/1452_R1_001.fastq.gz Mcapitata_ATAC_TP12_1452_R1.fastq.gz
ln -s ../raw_reads/*/1452_R2_001.fastq.gz Mcapitata_ATAC_TP12_1452_R2.fastq.gz

ln -s ../raw_reads/*/1455_R1_001.fastq.gz Mcapitata_ATAC_TP7_1455_R1.fastq.gz
ln -s ../raw_reads/*/1455_R2_001.fastq.gz Mcapitata_ATAC_TP7_1455_R2.fastq.gz

ln -s ../raw_reads/*/1467_R1_001.fastq.gz Mcapitata_HTAC_TP9_1467_R1.fastq.gz
ln -s ../raw_reads/*/1467_R2_001.fastq.gz Mcapitata_HTAC_TP9_1467_R2.fastq.gz

ln -s ../raw_reads/*/1468_R1_001.fastq.gz Pacuta_ATAC_TP6_1468_R1.fastq.gz
ln -s ../raw_reads/*/1468_R2_001.fastq.gz Pacuta_ATAC_TP6_1468_R2.fastq.gz

ln -s ../raw_reads/*/1481_R1_001.fastq.gz Mcapitata_HTAC_TP4_1481_R1.fastq.gz
ln -s ../raw_reads/*/1481_R2_001.fastq.gz Mcapitata_HTAC_TP4_1481_R2.fastq.gz

ln -s ../raw_reads/*/1548_R1_001.fastq.gz Mcapitata_ATAC_TP3_1548_R1.fastq.gz
ln -s ../raw_reads/*/1548_R2_001.fastq.gz Mcapitata_ATAC_TP3_1548_R2.fastq.gz

ln -s ../raw_reads/*/1562_R1_001.fastq.gz Mcapitata_HTAC_TP11_1562_R1.fastq.gz
ln -s ../raw_reads/*/1562_R2_001.fastq.gz Mcapitata_HTAC_TP11_1562_R2.fastq.gz

ln -s ../raw_reads/*/1563_R1_001.fastq.gz Pacuta_ATAC_TP5_1563_R1.fastq.gz
ln -s ../raw_reads/*/1563_R2_001.fastq.gz Pacuta_ATAC_TP5_1563_R2.fastq.gz

ln -s ../raw_reads/*/1571_R1_001.fastq.gz Pacuta_HTAC_TP5_1571_R1.fastq.gz
ln -s ../raw_reads/*/1571_R2_001.fastq.gz Pacuta_HTAC_TP5_1571_R2.fastq.gz

ln -s ../raw_reads/*/1579_R1_001.fastq.gz Mcapitata_HTAC_TP1_1579_R1.fastq.gz
ln -s ../raw_reads/*/1579_R2_001.fastq.gz Mcapitata_HTAC_TP1_1579_R2.fastq.gz

ln -s ../raw_reads/*/1581_R1_001.fastq.gz Pacuta_HTAC_TP4_1581_R1.fastq.gz
ln -s ../raw_reads/*/1581_R2_001.fastq.gz Pacuta_HTAC_TP4_1581_R2.fastq.gz

ln -s ../raw_reads/*/1582_R1_001.fastq.gz Pacuta_HTAC_TP11_1582_R1.fastq.gz
ln -s ../raw_reads/*/1582_R2_001.fastq.gz Pacuta_HTAC_TP11_1582_R2.fastq.gz

ln -s ../raw_reads/*/1583_R1_001.fastq.gz Mcapitata_HTAC_TP5_1583_R1.fastq.gz
ln -s ../raw_reads/*/1583_R2_001.fastq.gz Mcapitata_HTAC_TP5_1583_R2.fastq.gz

ln -s ../raw_reads/*/1588_R1_001.fastq.gz Mcapitata_HTAC_TP6_1588_R1.fastq.gz
ln -s ../raw_reads/*/1588_R2_001.fastq.gz Mcapitata_HTAC_TP6_1588_R2.fastq.gz

ln -s ../raw_reads/*/1596_R1_001.fastq.gz Pacuta_HTAC_TP11_1596_R1.fastq.gz
ln -s ../raw_reads/*/1596_R2_001.fastq.gz Pacuta_HTAC_TP11_1596_R2.fastq.gz

ln -s ../raw_reads/*/1604_R1_001.fastq.gz Mcapitata_HTHC_TP6_1604_R1.fastq.gz
ln -s ../raw_reads/*/1604_R2_001.fastq.gz Mcapitata_HTHC_TP6_1604_R2.fastq.gz

ln -s ../raw_reads/*/1609_R1_001.fastq.gz Mcapitata_ATAC_TP4_1609_R1.fastq.gz
ln -s ../raw_reads/*/1609_R2_001.fastq.gz Mcapitata_ATAC_TP4_1609_R2.fastq.gz

ln -s ../raw_reads/*/1610_R1_001.fastq.gz Mcapitata_ATAC_TP5_1610_R1.fastq.gz
ln -s ../raw_reads/*/1610_R2_001.fastq.gz Mcapitata_ATAC_TP5_1610_R2.fastq.gz

ln -s ../raw_reads/*/1611_R1_001.fastq.gz Mcapitata_ATAC_TP6_1611_R1.fastq.gz
ln -s ../raw_reads/*/1611_R2_001.fastq.gz Mcapitata_ATAC_TP6_1611_R2.fastq.gz

ln -s ../raw_reads/*/1628_R1_001.fastq.gz Mcapitata_ATAC_TP3_1628_R1.fastq.gz
ln -s ../raw_reads/*/1628_R2_001.fastq.gz Mcapitata_ATAC_TP3_1628_R2.fastq.gz

ln -s ../raw_reads/*/1632_R1_001.fastq.gz Mcapitata_HTAC_TP12_1632_R1.fastq.gz
ln -s ../raw_reads/*/1632_R2_001.fastq.gz Mcapitata_HTAC_TP12_1632_R2.fastq.gz

ln -s ../raw_reads/*/1642_R1_001.fastq.gz Pacuta_HTAC_TP3_1642_R1.fastq.gz
ln -s ../raw_reads/*/1642_R2_001.fastq.gz Pacuta_HTAC_TP3_1642_R2.fastq.gz

ln -s ../raw_reads/*/1645_R1_001.fastq.gz Mcapitata_HTAC_TP7_1645_R1.fastq.gz
ln -s ../raw_reads/*/1645_R2_001.fastq.gz Mcapitata_HTAC_TP7_1645_R2.fastq.gz

ln -s ../raw_reads/*/1647_R1_001.fastq.gz Pacuta_HTAC_TP11_1647_R1.fastq.gz
ln -s ../raw_reads/*/1647_R2_001.fastq.gz Pacuta_HTAC_TP11_1647_R2.fastq.gz

ln -s ../raw_reads/*/1651_R1_001.fastq.gz Mcapitata_ATAC_TP4_1651_R1.fastq.gz
ln -s ../raw_reads/*/1651_R2_001.fastq.gz Mcapitata_ATAC_TP4_1651_R2.fastq.gz

ln -s ../raw_reads/*/1652_R1_001.fastq.gz Mcapitata_ATAC_TP1_1652_R1.fastq.gz
ln -s ../raw_reads/*/1652_R2_001.fastq.gz Mcapitata_ATAC_TP1_1652_R2.fastq.gz

ln -s ../raw_reads/*/1653_R1_001.fastq.gz Pacuta_HTAC_TP1_1653_R1.fastq.gz
ln -s ../raw_reads/*/1653_R2_001.fastq.gz Pacuta_HTAC_TP1_1653_R2.fastq.gz

ln -s ../raw_reads/*/1689_R1_001.fastq.gz Mcapitata_HTHC_TP10_1689_R1.fastq.gz
ln -s ../raw_reads/*/1689_R2_001.fastq.gz Mcapitata_HTHC_TP10_1689_R2.fastq.gz

ln -s ../raw_reads/*/1694_R1_001.fastq.gz Mcapitata_HTHC_TP5_1694_R1.fastq.gz
ln -s ../raw_reads/*/1694_R2_001.fastq.gz Mcapitata_HTHC_TP5_1694_R2.fastq.gz

ln -s ../raw_reads/*/1696_R1_001.fastq.gz Pacuta_HTAC_TP9_1696_R1.fastq.gz
ln -s ../raw_reads/*/1696_R2_001.fastq.gz Pacuta_HTAC_TP9_1696_R2.fastq.gz

ln -s ../raw_reads/*/1701_R1_001.fastq.gz Pacuta_HTAC_TP4_1701_R1.fastq.gz
ln -s ../raw_reads/*/1701_R2_001.fastq.gz Pacuta_HTAC_TP4_1701_R2.fastq.gz

ln -s ../raw_reads/*/1706_R1_001.fastq.gz Mcapitata_ATHC_TP5_1706_R1.fastq.gz
ln -s ../raw_reads/*/1706_R2_001.fastq.gz Mcapitata_ATHC_TP5_1706_R2.fastq.gz

ln -s ../raw_reads/*/1707_R1_001.fastq.gz Pacuta_HTAC_TP5_1707_R1.fastq.gz
ln -s ../raw_reads/*/1707_R2_001.fastq.gz Pacuta_HTAC_TP5_1707_R2.fastq.gz

ln -s ../raw_reads/*/1709_R1_001.fastq.gz Pacuta_HTHC_TP8_1709_R1.fastq.gz
ln -s ../raw_reads/*/1709_R2_001.fastq.gz Pacuta_HTHC_TP8_1709_R2.fastq.gz

ln -s ../raw_reads/*/1722_R1_001.fastq.gz Mcapitata_HTAC_TP7_1722_R1.fastq.gz
ln -s ../raw_reads/*/1722_R2_001.fastq.gz Mcapitata_HTAC_TP7_1722_R2.fastq.gz

ln -s ../raw_reads/*/1729_R1_001.fastq.gz Mcapitata_HTAC_TP12_1729_R1.fastq.gz
ln -s ../raw_reads/*/1729_R2_001.fastq.gz Mcapitata_HTAC_TP12_1729_R2.fastq.gz

ln -s ../raw_reads/*/1762_R1_001.fastq.gz Pacuta_ATAC_TP4_1762_R1.fastq.gz
ln -s ../raw_reads/*/1762_R2_001.fastq.gz Pacuta_ATAC_TP4_1762_R2.fastq.gz

ln -s ../raw_reads/*/1777_R1_001.fastq.gz Pacuta_ATAC_TP11_1777_R1.fastq.gz
ln -s ../raw_reads/*/1777_R2_001.fastq.gz Pacuta_ATAC_TP11_1777_R2.fastq.gz

ln -s ../raw_reads/*/1997_R1_001.fastq.gz Mcapitata_HTAC_TP5_1997_R1.fastq.gz
ln -s ../raw_reads/*/1997_R2_001.fastq.gz Mcapitata_HTAC_TP5_1997_R2.fastq.gz

ln -s ../raw_reads/*/2000_R1_001.fastq.gz Mcapitata_HTAC_TP4_2000_R1.fastq.gz
ln -s ../raw_reads/*/2000_R2_001.fastq.gz Mcapitata_HTAC_TP4_2000_R2.fastq.gz

ln -s ../raw_reads/*/2002_R1_001.fastq.gz Pacuta_ATAC_TP4_2002_R1.fastq.gz
ln -s ../raw_reads/*/2002_R2_001.fastq.gz Pacuta_ATAC_TP4_2002_R2.fastq.gz

ln -s ../raw_reads/*/2007_R1_001.fastq.gz Mcapitata_HTAC_TP12_2007_R1.fastq.gz
ln -s ../raw_reads/*/2007_R2_001.fastq.gz Mcapitata_HTAC_TP12_2007_R2.fastq.gz

ln -s ../raw_reads/*/2009_R1_001.fastq.gz Mcapitata_HTHC_TP9_2009_R1.fastq.gz
ln -s ../raw_reads/*/2009_R2_001.fastq.gz Mcapitata_HTHC_TP9_2009_R2.fastq.gz

ln -s ../raw_reads/*/2016_R1_001.fastq.gz Mcapitata_ATHC_TP6_2016_R1.fastq.gz
ln -s ../raw_reads/*/2016_R2_001.fastq.gz Mcapitata_ATHC_TP6_2016_R2.fastq.gz

ln -s ../raw_reads/*/2021_R1_001.fastq.gz Mcapitata_HTAC_TP3_2021_R1.fastq.gz
ln -s ../raw_reads/*/2021_R2_001.fastq.gz Mcapitata_HTAC_TP3_2021_R2.fastq.gz

ln -s ../raw_reads/*/2067_R1_001.fastq.gz Mcapitata_HTHC_TP8_2067_R1.fastq.gz
ln -s ../raw_reads/*/2067_R2_001.fastq.gz Mcapitata_HTHC_TP8_2067_R2.fastq.gz

ln -s ../raw_reads/*/2087_R1_001.fastq.gz Pacuta_HTHC_TP5_2087_R1.fastq.gz
ln -s ../raw_reads/*/2087_R2_001.fastq.gz Pacuta_HTHC_TP5_2087_R2.fastq.gz

ln -s ../raw_reads/*/2153_R1_001.fastq.gz Mcapitata_HTAC_TP1_2153_R1.fastq.gz
ln -s ../raw_reads/*/2153_R2_001.fastq.gz Mcapitata_HTAC_TP1_2153_R2.fastq.gz

ln -s ../raw_reads/*/2185_R1_001.fastq.gz Pacuta_HTHC_TP11_2185_R1.fastq.gz
ln -s ../raw_reads/*/2185_R2_001.fastq.gz Pacuta_HTHC_TP11_2185_R2.fastq.gz

ln -s ../raw_reads/*/2188_R1_001.fastq.gz Mcapitata_ATHC_TP11_2188_R1.fastq.gz
ln -s ../raw_reads/*/2188_R2_001.fastq.gz Mcapitata_ATHC_TP11_2188_R2.fastq.gz

ln -s ../raw_reads/*/2190_R1_001.fastq.gz Mcapitata_HTHC_TP12_2190_R1.fastq.gz
ln -s ../raw_reads/*/2190_R2_001.fastq.gz Mcapitata_HTHC_TP12_2190_R2.fastq.gz

ln -s ../raw_reads/*/2195_R1_001.fastq.gz Pacuta_HTHC_TP4_2195_R1.fastq.gz
ln -s ../raw_reads/*/2195_R2_001.fastq.gz Pacuta_HTHC_TP4_2195_R2.fastq.gz

ln -s ../raw_reads/*/2210_R1_001.fastq.gz Pacuta_HTHC_TP1_2210_R1.fastq.gz
ln -s ../raw_reads/*/2210_R2_001.fastq.gz Pacuta_HTHC_TP1_2210_R2.fastq.gz

ln -s ../raw_reads/*/2212_R1_001.fastq.gz Pacuta_ATHC_TP5_2212_R1.fastq.gz
ln -s ../raw_reads/*/2212_R2_001.fastq.gz Pacuta_ATHC_TP5_2212_R2.fastq.gz

ln -s ../raw_reads/*/2302_R1_001.fastq.gz Mcapitata_ATAC_TP11_2302_R1.fastq.gz
ln -s ../raw_reads/*/2302_R2_001.fastq.gz Mcapitata_ATAC_TP11_2302_R2.fastq.gz

ln -s ../raw_reads/*/2306_R1_001.fastq.gz Pacuta_ATAC_TP11_2306_R1.fastq.gz
ln -s ../raw_reads/*/2306_R2_001.fastq.gz Pacuta_ATAC_TP11_2306_R2.fastq.gz

ln -s ../raw_reads/*/2380_R1_001.fastq.gz Mcapitata_HTAC_TP11_2380_R1.fastq.gz
ln -s ../raw_reads/*/2380_R2_001.fastq.gz Mcapitata_HTAC_TP11_2380_R2.fastq.gz

ln -s ../raw_reads/*/2402_R1_001.fastq.gz Mcapitata_ATAC_TP6_2402_R1.fastq.gz
ln -s ../raw_reads/*/2402_R2_001.fastq.gz Mcapitata_ATAC_TP6_2402_R2.fastq.gz

ln -s ../raw_reads/*/2403_R1_001.fastq.gz Mcapitata_ATAC_TP12_2403_R1.fastq.gz
ln -s ../raw_reads/*/2403_R2_001.fastq.gz Mcapitata_ATAC_TP12_2403_R2.fastq.gz

ln -s ../raw_reads/*/2410_R1_001.fastq.gz Mcapitata_HTAC_TP8_2410_R1.fastq.gz
ln -s ../raw_reads/*/2410_R2_001.fastq.gz Mcapitata_HTAC_TP8_2410_R2.fastq.gz

ln -s ../raw_reads/*/2419_R1_001.fastq.gz Mcapitata_HTHC_TP7_2419_R1.fastq.gz
ln -s ../raw_reads/*/2419_R2_001.fastq.gz Mcapitata_HTHC_TP7_2419_R2.fastq.gz

ln -s ../raw_reads/*/2511_R1_001.fastq.gz Mcapitata_HTHC_TP11_2511_R1.fastq.gz
ln -s ../raw_reads/*/2511_R2_001.fastq.gz Mcapitata_HTHC_TP11_2511_R2.fastq.gz

ln -s ../raw_reads/*/2534_R1_001.fastq.gz Pacuta_ATHC_TP3_2534_R1.fastq.gz
ln -s ../raw_reads/*/2534_R2_001.fastq.gz Pacuta_ATHC_TP3_2534_R2.fastq.gz

ln -s ../raw_reads/*/2555_R1_001.fastq.gz Mcapitata_ATHC_TP6_2555_R1.fastq.gz
ln -s ../raw_reads/*/2555_R2_001.fastq.gz Mcapitata_ATHC_TP6_2555_R2.fastq.gz

ln -s ../raw_reads/*/2564_R1_001.fastq.gz Pacuta_ATHC_TP8_2564_R1.fastq.gz
ln -s ../raw_reads/*/2564_R2_001.fastq.gz Pacuta_ATHC_TP8_2564_R2.fastq.gz

ln -s ../raw_reads/*/2668_R1_001.fastq.gz Pacuta_ATHC_TP11_2668_R1.fastq.gz
ln -s ../raw_reads/*/2668_R2_001.fastq.gz Pacuta_ATHC_TP11_2668_R2.fastq.gz

ln -s ../raw_reads/*/2731_R1_001.fastq.gz Mcapitata_ATHC_TP3_2731_R1.fastq.gz
ln -s ../raw_reads/*/2731_R2_001.fastq.gz Mcapitata_ATHC_TP3_2731_R2.fastq.gz

ln -s ../raw_reads/*/2733_R1_001.fastq.gz Pacuta_ATHC_TP4_2733_R1.fastq.gz
ln -s ../raw_reads/*/2733_R2_001.fastq.gz Pacuta_ATHC_TP4_2733_R2.fastq.gz

ln -s ../raw_reads/*/2734_R1_001.fastq.gz Mcapitata_ATHC_TP4_2734_R1.fastq.gz
ln -s ../raw_reads/*/2734_R2_001.fastq.gz Mcapitata_ATHC_TP4_2734_R2.fastq.gz

ln -s ../raw_reads/*/2735_R1_001.fastq.gz Mcapitata_ATHC_TP8_2735_R1.fastq.gz
ln -s ../raw_reads/*/2735_R2_001.fastq.gz Mcapitata_ATHC_TP8_2735_R2.fastq.gz

ln -s ../raw_reads/*/2736_R1_001.fastq.gz Mcapitata_ATHC_TP12_2736_R1.fastq.gz
ln -s ../raw_reads/*/2736_R2_001.fastq.gz Mcapitata_ATHC_TP12_2736_R2.fastq.gz

ln -s ../raw_reads/*/2737_R1_001.fastq.gz Mcapitata_ATHC_TP10_2737_R1.fastq.gz
ln -s ../raw_reads/*/2737_R2_001.fastq.gz Mcapitata_ATHC_TP10_2737_R2.fastq.gz

ln -s ../raw_reads/*/2750_R1_001.fastq.gz Pacuta_ATHC_TP3_2750_R1.fastq.gz
ln -s ../raw_reads/*/2750_R2_001.fastq.gz Pacuta_ATHC_TP3_2750_R2.fastq.gz

ln -s ../raw_reads/*/2753_R1_001.fastq.gz Mcapitata_ATHC_TP8_2753_R1.fastq.gz
ln -s ../raw_reads/*/2753_R2_001.fastq.gz Mcapitata_ATHC_TP8_2753_R2.fastq.gz

ln -s ../raw_reads/*/2756_R1_001.fastq.gz Mcapitata_ATHC_TP11_2756_R1.fastq.gz
ln -s ../raw_reads/*/2756_R2_001.fastq.gz Mcapitata_ATHC_TP11_2756_R2.fastq.gz

ln -s ../raw_reads/*/2879_R1_001.fastq.gz Pacuta_ATHC_TP11_2879_R1.fastq.gz
ln -s ../raw_reads/*/2879_R2_001.fastq.gz Pacuta_ATHC_TP11_2879_R2.fastq.gz

ln -s ../raw_reads/*/2986_R1_001.fastq.gz Mcapitata_ATHC_TP5_2986_R1.fastq.gz
ln -s ../raw_reads/*/2986_R2_001.fastq.gz Mcapitata_ATHC_TP5_2986_R2.fastq.gz

ln -s ../raw_reads/*/2990_R1_001.fastq.gz Mcapitata_ATHC_TP12_2990_R1.fastq.gz
ln -s ../raw_reads/*/2990_R2_001.fastq.gz Mcapitata_ATHC_TP12_2990_R2.fastq.gz

