# Coral Stress Phenome Paper

### Writing

[Main paper google doc link](https://docs.google.com/document/d/1geXeJEXaPVHWE6Ivdi6BW2qoF3PHT_Ok1Fv9iM8aLwg/edit).  
[Supplemental Methods google doc link](https://docs.google.com/document/d/1EQtKXPAxybWeG9LPgz5mEjV0kLC8PoA571XGKSlX2ek/edit).

### Experimental Design

![expt-sch](https://github.com/hputnam/Coral_Stress_Phenome/blob/main/Environmental-data/HoloInt-schematic.png?raw=true)

900 corals, 450 *M. capitata* and 450 *P. acuta*, were collected from 6 sites in Kaneohe Bay, Hawai'i. These corals were randomly assigned to one of 4 treatments. 3 tanks per treatment, 12 tanks total. 2 months of treatment and 2 months of recovery in ambient conditions.   

ATAC = Ambient Temperature (27C) Ambient pCO2 (~480 uatm)  
ATHC = Ambient Temperature (27C) High pCO2 (~1,200 uatm)    
HTAC = High Temperature (29.5C) Ambient pCO2 (~480 uatm)  
HTHC = High Temperature (29.5C) High pCO2 (~1,200 uatm)

### Collection Timeline

| Date Collected 	| Site Name         	| Coordinates                	|
|----------------	|-------------------	|----------------------------	|
| 20180904       	| SITE 2 HIMB       	| 21°26'09.8"N 157°47'12.7"W 	|
| 20180905       	| SITE 6 REEF 42.43 	| 21°28'37.9"N 157°49'36.8"W 	|
| 20180906       	| SITE 5 REEF 35.36 	| 21°28'26.0"N 157°50'01.2"W 	|
| 20180907       	| SITE 4 REEF 11.13 	| 21°27'02.9"N 157°47'41.8"W 	|
| 20180908       	| SITE 1 LILIPUNA   	| 21°25'45.9"N 157°47'28.0"W 	|
| 20180910       	| SITE 3 REEF 18    	| 21°27'02.9"N 157°48'40.1"W 	|

Experimental treatment started on 20180922.

**fill in the spawning dates for context**:  
*M. capitata* spawning dates:  
*P. acuta* spawning dates:

### Sampling Timeline

|                      	| Acute Stress 	|       	| Chronic Stress 	|      	|      	|      	|      	|      	|      	|      	| Recovery 	|       	|       	|       	|       	|       	|       	|       	|
|----------------------	|--------------	|-------	|----------------	|------	|------	|------	|------	|------	|------	|------	|----------	|-------	|-------	|-------	|-------	|-------	|-------	|-------	|
|                      	| Day 1        	| Day 2 	| Wk 1           	| Wk 2 	| Wk 3 	| Wk 4 	| Wk 5 	| Wk 6 	| Wk 7 	| Wk 8 	| Wk 9     	| Wk 10 	| Wk 11 	| Wk 12 	| Wk 13 	| Wk 14 	| Wk 15 	| Wk 16 	|
| Holobiont Physiology 	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	| x     	|       	|       	|       	| x     	|
| Metabolism          	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	|       	|       	|       	|       	|       	|
| Growth              	| x            	| x     	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	| x     	|       	| x     	|       	| x     	|       	| x     	|
| Bleaching Score     	|              	|       	| x              	| x    	| x    	| x    	| x    	| x    	| x    	| x    	| x        	| x     	| x     	| x     	| x     	| x     	| x     	| x     	|
| Survivorship        	| x            	| x     	| x              	| x    	| x    	| x    	| x    	| x    	| x    	| x    	| x        	| x     	| x     	| x     	| x     	| x     	| x     	| x     	|
| Molecular            	| 0, 6, 12 hr  	| 24 hr 	| x              	| x    	|      	| x    	|      	| x    	|      	| x    	|          	|       	|       	| x     	|       	|       	|       	| x     	|

**Response variables:**

Molecular: Symbiont community assemblage (ITS2 Seq), bacterial community assemblage (16S Seq), gene expression patterns (RNASeq), DNA methylation patterns (WGBS).  

Metabolomics   

Holobiont physiology: protein content, total antioxidant capacity, chlorophyll concentration, tissue biomass, symbiont density.  

**Currently not included in Coral Stress Phenome paper**  

- Metabolism: respiration and photosynthetic rates.  
- Growth rates  
- Pocillopora acuta identity (mtORF Seq)   

### Experimental Treatments

**Hobo Logger Data**

Emma needs to parse hobo logger data for times they were out of the water and then will put an updated version here.

**Discrete Temperature and pH Measurements**

To be placed here from version in CSP.

**Discrete Carbonate Chemistry**

To be placed here from version in CSP.

### Physiological data

Only what is to be included in Coral Stress Phenome paper. Link to results package from HoloInt [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/HoloInt-Results-package.md).

**Survivorship**  

Figure as of 2021-05-27. For now these are just copied from HoloInt repo. 

![sur](https://github.com/hputnam/Coral_Stress_Phenome/blob/main/Physiology-data/All_survivorship_20210527.png?raw=true)





### Statistics

```
Permutation test for adonis under reduced model
Terms added sequentially (first to last)
Permutation: free
Number of permutations: 999

adonis2(formula = Mcap.data.scaled ~ Temperature * CO2 * Timepoint, data = Mcap.info, method = "euclidian")
                           Df SumOfSqs      R2      F Pr(>F)    
Temperature                 1     8.97 0.01323 1.6422  0.167    
CO2                         1     1.12 0.00165 0.2054  0.937    
Timepoint                   4    75.22 0.11094 3.4436  0.001 ***
Temperature:CO2             1     5.86 0.00865 1.0740  0.356    
Temperature:Timepoint       4    22.21 0.03276 1.0168  0.433    
CO2:Timepoint               4    23.07 0.03403 1.0562  0.379    
Temperature:CO2:Timepoint   4    28.26 0.04168 1.2936  0.198    
Residual                   94   513.30 0.75707                  
Total                     113   678.00 1.00000                  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```


*P. acuta* PERMANOVA

```
Permutation test for adonis under reduced model
Terms added sequentially (first to last)
Permutation: free
Number of permutations: 999

adonis2(formula = Pact.data.scaled ~ Temperature * CO2 * Timepoint, data = Pact.info, method = "euclidian")
                           Df SumOfSqs      R2      F Pr(>F)    
Temperature                 1    28.54 0.04709 5.6114  0.003 **
CO2                         1     2.85 0.00470 0.5604  0.674    
Timepoint                   4    70.51 0.11636 3.4663  0.001 ***
Temperature:CO2             1     6.41 0.01058 1.2608  0.263    
Temperature:Timepoint       4    36.31 0.05992 1.7851  0.053 .  
CO2:Timepoint               4    20.20 0.03333 0.9929  0.452    
Temperature:CO2:Timepoint   3    19.08 0.03148 1.2506  0.273    
Residual                   83   422.10 0.69653                  
Total                     101   606.00 1.00000                  

---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

![biplots](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-PCAs.png?raw=true)

![all](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-all.png?raw=true)

The above figure is connecting dots by x axis placement, not factor(timepoint). Come back to how to change this..

![blchscore](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-Photographic_Bleaching.png?raw=true)

![surv](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/All_survivorship.png?raw=true)
