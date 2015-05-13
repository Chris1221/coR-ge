#!/bin/bash
#i=$1
i=$1 #for now keep the same
nj="10" #number of perms per block

#engage overflow control
#-> -> overflow.R

for folder in {1..10}
do
  mkdir /scratch/hpc2862/CAMH/perm_container/container_${i}_${folder}
  #submit watcher script
done
#qsub -N m_watcher -V -t 1-${nj}:1 /home/hpc2862/Scripts/scripts/R/sFDR/lord_commander_mormont.sh ${i}
qsub -N j_array_${i} -v i=${i} -t 1-${nj}:1 /home/hpc2862/Scripts/sFDR/j_array.sh ${i}

#rscript, wait for the previous ones to finish, wait until folder 10 has been deleted
#Rscript hold_your_horses.R

#have to wait for all of the above to finish before can do anything else.
#for array t = j, wait until folder j is filled up and THEN go
#so wait for i_t_* to finish

####qsub -t 0:9:1 -hold_jib -N internal_k -v i=${i} j=${j} mini_j.sub

#this contains all the stuff
