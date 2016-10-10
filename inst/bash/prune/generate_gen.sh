#!/bin/bash

cd /home/hpc2862/Raw_Files/CAMH/1kg_hapmap_comb/hapmap3_r2_plus_1000g_jun2010_b36_ceu

/home/hpc2862/Programs/hapgen2 \
       	-h pilot1.jun2010.b36.CEU.chr1.snpfilt.haps \
	-l pilot1.jun2010.b36.CEU.chr1.snpfilt.legend 
	-m genetic_map_chr1_combined_b36.txt \
	-dl 77053 1 1.0 1.0 \
       	-n 1000 0 \
	-int 0 500000000 \
	-o /scratch/hpc2862/CAMH/perm_container/prune/prune

