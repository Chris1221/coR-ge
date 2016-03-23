#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -l mf=192G
#$ -j y
#$ -o /home/hpc2862/logs/m_watcher.txt

Rscript /home/hpc2862/Scripts/sFDR/watcher_on_the_walls.R $1 ${SGE_TASK_ID}
