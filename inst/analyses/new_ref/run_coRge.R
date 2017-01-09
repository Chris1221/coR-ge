library(coRge)
library(data.table)

gen <- fread("/scratch/hpc2862/CAMH/new_corge/sim/chr1_sim1.controls.gen", h = F, sep = " ", data.table = F, nrow = 100000)
summary <- fread("/scratch/hpc2862/CAMH/new_corge/summary", h = T, sep = " ")

analyze(gen, summary, local = T, output ="/scratch/hpc2862/CAMH/new_corge/results/run2.txt" )
