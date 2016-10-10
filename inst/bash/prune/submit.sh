#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l hostname=sw0050
#$ -pe shm.pe 4
#$ -j y
#$ -o /home/hpc2862/repos/coR-ge/inst/logs/$JOB_NAME.txt

use gcc-4.9.2

Rscript ~/repos/coR-ge/inst/bash/prune/run.R 
