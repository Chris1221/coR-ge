#!/usr/bin/Rscript

setwd("/scratch/hpc2862/CAMH/perm_container/prune")

library(dplyr)
library(devtools)
library(data.table)
library(Rcpp)
library(RcppArmadillo)
library(coRge)
library(foreach)

gen <- as.data.frame( data.table::fread("pruned_input.gen", h = F, sep = " "))
summary <- fread("/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", h = T)

foreach(h2 = seq(0.1, 0.9, by = 0.1)) %:%
	foreach(pc = seq(0.1, 0.9, by = 0.1)) %:%
		foreach(pnc = seq(0.1, 0.9, by = 0.1)) %:%
			foreach(nc = seq(50,500, by =50)) %do% {
				analyze(i = i,
				        j = j,
				       	h2 = h2,
				       	pc = pc,
				       	pnc = pnc,
				       	nc = nc,
				       	local = TRUE,
				       	gen = gen,
				       	summary = summary,
				       	mode = "ld",
				       	output = "~repos/coR-ge/data/raw/pri2.txt"
					)
			}

