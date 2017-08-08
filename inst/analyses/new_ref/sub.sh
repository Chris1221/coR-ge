#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l hostname=sw0050
#$ -j y
#$ -o /home/hpc2862/repos/coR-ge/inst/logs/$JOB_NAME.txt

cd /home/hpc2862/repos/coR-ge/inst/analyses/new_ref

Rscript run_coRge.R
