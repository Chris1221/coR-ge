#!/usr/bin/Rscript

# ------------------------------------------------------------------------------- #
#
# Step 1: Take input options from command line 
#	  Currently assuming that only i and j vary but the others can too
#         Maybe put this into the makefile directly
#
# ------------------------------------------------------------------------------- #


library(dplyr)
library(devtools)
library(data.table)
library(Rcpp)
library(RcppArmadillo)

#install_github("Chris1221/coR-ge", ref = "devel")
library(coRge)

test <- FALSE

args <- commandArgs(TRUE)

i <- args[1]
j <- args[2]

path.base <- "/scratch/hpc2862/CAMH/perm_container/container_"

# ------------------------------------------------------------------------------- #
#
# Step 2: Read in gen and summary files
#         This has been removed from the main function to allow looping over analyze(local)
#         Perhaps try to save as an R binary file, but not now. 
#
# ------------------------------------------------------------------------------- #

path <- paste0(path.base,i,"_",j,"/")
setwd(path)

list.files(path)[!grepl("controls.gen", list.files(path))] %>%
	file.remove

if(!test){

	for(k in 1:5){
		if(k == 1){
			fread(paste0(path, "chr1_block_", i, "_perm_", j, "_k_", k, ".controls.gen"), h = F, sep = " ") %>% as.data.frame() -> gen
		} else if(k != 1){
			fread(paste0(path, "chr1_block_", i, "_perm_", j, "_k_", k, ".controls.gen"), h = F, sep = " ") %>% as.data.frame() %>% select(.,-V1:-V5) %>% cbind(gen, .) -> gen
		}
}

} else if(test){
	  k <- 1

	  gen <- fread(paste0(path, "chr1_block_", i, "_perm_", j, "_k_", k, ".controls.gen"), h = F, sep = " ") %>% as.data.frame()
}

colnames(gen) <- paste0("V",1:ncol(gen))

summary <- fread("/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", h = T)

h2 = 0.5
pc = 0.75
pnc = 0.2
nc = 500


for( var in c(50, 500, 5000) ){

	analyze(i = i,
		j = j,
		h2 = h2,
		pc = pc,
		pnc = pnc,
		nc = var,
		local = TRUE,
		gen = gen,
		summary = summary,
		mode = "ld",
		output = "~repos/coR-ge/data/raw/new_panels.txt")
}

for( var in c(0.1, 0.5, 0.9) ){

	analyze(i = i,
		j = j,
		h2 = i,
		pc = pc,
		pnc = pnc,
		nc = var,
		local = TRUE,
		gen = gen,
		summary = summary,
		mode = "ld",
		output = "~repos/coR-ge/data/raw/new_panels.txt")
}

for( var in c(0.5,0.8, 0.99) ){

	analyze(i = i,
		j = j,
		h2 = h2,
		pc = var,
		pnc = pnc,
		nc = i,
		local = TRUE,
		gen = gen,
		summary = summary,
		mode = "ld",
		output = "~repos/coR-ge/data/raw/new_panels.txt")
}
