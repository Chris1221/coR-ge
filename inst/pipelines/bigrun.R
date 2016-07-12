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

# ------------------------------------------------------------------------------- #
#
# Step 3: Loop around options
#
# ------------------------------------------------------------------------------- #

library(foreach)

# chec if all need to be par or just the top level one, probbaly all but check speed if both


#foreach(i = c(1:10)) %:%
	foreach(maf_range = list(c(0.01, 0.05),  c(0.4, 0.5), c(0.05, 0.5))) %:%
		foreach(h2 = c(0.2, 0.4, 0.6, 0.8) %:%
			foreach(pc = c(0.2, 0.5, 0.8)) %:%
				foreach(pnc = c(0.2, 0.5, 0.8) %:%
					foreach(nc = c(100, 1000, 5000)) %do% {
						analyze(i = i, j = j, h2 = h2, pc = pc, pnc = pnc, nc = nc, local = TRUE, gen = gen, summary = summary, mode = "ld", maf = TRUE, maf_range = maf_range, output = "/home/hpc2862/repos/coR-ge/data/raw/results_priority.txt")
					}

