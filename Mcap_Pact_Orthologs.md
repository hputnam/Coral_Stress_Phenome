#Download Mcap Proteins
wget https://osf.io/kxmvt/download

```grep -c ">" Mcap.protein.fa```
```63227```


#Download Pact Proteins
#experimental only from Vidal Dupiol
wget https://osf.io/5m8qx/download

```grep -c ">"  Pocillopora_acuta_PredGenes_experimental_v1.transcripts.pep.faa```
```52917
```

``` nano orthfind.sh ```

#Run Orthofinder

```
#!/bin/bash
#SBATCH -t 72:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH -p putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/hputnam/Orthologs

# load modules needed
# make sure that the foss-year all match

module load OrthoFinder/2.5.2-intel-2019b-Python-3.7.4

# requires path to Fastas directory
# using 10 threads, matching the SLRUM parameters above

orthofinder -f /data/putnamlab/hputnam/Orthologs/ -t 10
```

``` sbatch orthfind.sh ```

#Notes from run 
```
2021-05-03 14:38:41 : Started OrthoFinder version 2.5.2
Command Line: /opt/software/OrthoFinder/2.5.2-intel-2019b-Python-3.7.4/bin/orthofinder -f /data/putnamlab/hputnam/Orthologs/ -t 10

WorkingDirectory_Base: /data/putnamlab/hputnam/Orthologs/OrthoFinder/Results_May03/WorkingDirectory/

Species used:
0: Mcap.protein.fa
1: Pocillopora_acuta_PredGenes_experimental_v1.transcripts.pep.faa
```

scp -r hputnam@bluewaves.uri.edu:/data/putnamlab/hputnam/Orthologs/OrthoFinder/Results_May03/Orthogroups /Users/hputnam/MyProjects/Coral_Stress_Phenome