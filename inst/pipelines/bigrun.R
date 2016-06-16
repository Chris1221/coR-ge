#!/usr/bin/Rscript

# ------------------------------------------------------------------------------- #
#
# Step 1: Take input options from command line 
#	  Currently assuming that only i and j vary but the others can too
#         Maybe put this into the makefile directly
#
# ------------------------------------------------------------------------------- #

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

# ------------------------------------------------------------------------------- #
#
# Step 3: Loop around options
#
# ------------------------------------------------------------------------------- #

library(doMC)
registerDoMC(cores = 8)
library(foreach)


