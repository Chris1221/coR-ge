#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l mf=192G
#$ -j y
#$ -o /home/hpc2862/logs/J.txt

i=$1
j=$SGE_TASK_ID

qsub -N k_jobs_${i}_${j} /home/hpc2862/Scripts/sFDR/k_hapgen.sh ${i} ${j}
