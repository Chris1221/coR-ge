library(coRge)
library(data.table)

gen <- fread("/scratch/hpc2862/CAMH/new_corge/sim/chr1_sim1.controls.gen", h = F, sep = " ", data.table = F, nrow = 100000)
summary <- fread("/scratch/hpc2862/CAMH/new_corge/summary/stats.txt", h = T, sep = " ", nrow = 100000)

analyze(i =1, j = 1, gen = gen, summary = summary, local = T, output ="/scratch/hpc2862/CAMH/new_corge/results/run2.txt", mode = "ld" )
