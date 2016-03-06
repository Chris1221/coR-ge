#!/bin/bash

i=$1 #for now keep the same
nj="10" #number of perms per block


for j in {1..10}
do
	mkdir /scratch/hpc2862/CAMH/perm_container/container_${i}_${j}	
	qsub -N k_jobs_${i}_${j} /home/hpc2862/repos/coR-ge/k_hapgen.sh ${i} ${j}
done
