#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l mf=75G
#$ -j y
#$ -o /home/hpc2862/logs/test.txt

i=$1
j=$2

cd /scratch/hpc2862/CAMH/perm_container/container_${i}_${j}

for k in {1..10}
do
  rm chr1_block_${i}_perm_${k}_k_${j}.cases.gen
  rm chr1_block_${i}_perm_${k}_k_${j}.cases.haps
  rm chr1_block_${i}_perm_${k}_k_${j}.cases.sample
  rm chr1_block_${i}_perm_${k}_k_${j}.cases.summary
  rm chr1_block_${i}_perm_${k}_k_${j}.cases.legend
#  #rm chr1_block_${i}_perm_${j}_k_${k}.controls.gen
  rm chr1_block_${i}_perm_${k}_k_${j}.controls.sample
  rm chr1_block_${i}_perm_${k}_k_${j}.controls.haps
  rm chr1_block_${i}_perm_${k}_k_${j}.controls.summary
  rm chr1_block_${i}_perm_${k}_k_${j}.controls.legend
done

Rscript /home/hpc2862/Scripts/sFDR/rand.R $i $j

for k in {1..10}
do
  rm chr1_block_${i}_perm_${k}_k_${j}.controls.gen
#  rm chr1_block_${i}_perm_${j}_k_${k}.controls.sample
done

/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ${i}_${j}_out.ped --map ${i}_${j}_out.map --phenotype Z

rm gtool.log
rm gen_test.gen
rm phen_test.sample

/home/hpc2862/Programs/binary_executables/plink --file ${i}_${j}_out --assoc --allow-no-sex

rm plink.log
rm plink.nosex
rm ${i}_${j}_out.ped
rm ${i}_${j}_out.map

Rscript /home/hpc2862/Scripts/sFDR/correct_and_report.R $i $j

cd ..
#rm -rf /scratch/hpc2862/CAMH/perm_container/container_${i}_${j}
