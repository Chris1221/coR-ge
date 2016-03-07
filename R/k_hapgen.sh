#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -t 1-10:1
#$ -V
#$ -l mf=192G
#$ -j y
#$ -o /home/hpc2862/logs/${i}_${j}_${SGE_TASK_ID}_${JOB_ID}.txt

#!/bin/bash

i2=${1}
j2=${2}

cd /home/hpc2862/Raw_Files/CAMH/1kg_hapmap_comb/hapmap3_r2_plus_1000g_jun2010_b36_ceu

/home/hpc2862/Programs/hapgen2 -h pilot1.jun2010.b36.CEU.chr1.snpfilt.haps -l pilot1.jun2010.b36.CEU.chr1.snpfilt.legend -m genetic_map_chr1_combined_b36.txt -dl 77053 1 1.0 1.0 -n 1000 0 -int 0 500000000 -o /scratch/hpc2862/CAMH/perm_container/container_${i2}_${j2}/chr1_block_${i2}_perm_${j2}_k_${SGE_TASK_ID}

if [ ${SGE_TASK_ID} == 10 ]
	then
	touch /scratch/hpc2862/CAMH/perm_container/container_${i2}_${j2}/${i2}_${j2}_done.txt	
fi
