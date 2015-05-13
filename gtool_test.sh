#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l mf=192G
#$ -j y
#$ -o /home/hpc2862/logs/${JOB_ID}.txt

i=1
j=2

cd /scratch/hpc2862/CAMH/perm_container/container_1_1
/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ${i}_${j}_out.ped --map ${i}_${j}_out.map --phenotype Z
