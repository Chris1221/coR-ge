library(coRge)
library(data.table)

gen <- fread("/scratch/hpc2862/CAMH/new_corge/sim/chr1_sim1.controls.gen",
	     h = F,
	     sep = " ",
	     data.table = F)

summary <- fread("/scratch/hpc2862/CAMH/new_corge/summary/stats.txt",
		 h = T,
		 sep = " ")

analyze(i=1,
	j = 1,
	nc = 1000,
	gen = gen,
	summary = summary,
	local = T,
	output ="/scratch/hpc2862/CAMH/new_corge/results/run2.txt")
