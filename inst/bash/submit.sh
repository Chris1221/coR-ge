#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -l hostname=sw0050
#$ -pe shm.pe 4
#$ -V
#$ -M hpc2862@localhost
#$ -m baes
#$ -j y
#$ -o /home/hpc2862/repos/coR-ge/inst/logs/$JOB_NAME.txt

i=$1
j=$2
R_FILE=$3

use gcc-4.8.2

Rscript ${R_FILE} $i $j

