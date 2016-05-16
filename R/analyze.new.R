analyze <- function(i = double(), j = double(), path.base = "/scratch/hpc2862/CAMH/perm_container/container_", summary.file = "/scratch/hpc2862/CAMH/perm_container/snp_summary2.out"){



		message("Error Checking")

	if(any(is.null(c(i,j,path.base, summary.file)))) stop("Please complete all input arguemnets")




		message("Loading required libraries...")

	if (!require("pacman")) install.packages("pacman", "http://cran.utstat.utoronto.ca/")
	library(pacman)
	p_load(data.table, dplyr, magrittr, devtools)

	#if (!require("coRge")) install_github("Chris1221/coR-ge")
	library(coRge) # do this one seperately just to make sure

	path <- paste0(path.base,i,"_",j,"/")
	setwd(path)


		message("Deleting junk files...")

	list.files(path)[!grepl("controls.gen", list.files(path))] %>% 
		file.remove



		message("Reading in genotype files...")

	for(k in 1:5){
		if(k == 1){
			fread(paste0(path, "chr1_block_", i, "_perm_", j, "_k_", k, ".controls.gen"), h = F, sep = " ") %>% as.data.frame() -> gen
		} else if(k != 1){
			fread(paste0(path, "chr1_block_", i, "_perm_", j, "_k_", k, ".controls.gen"), h = F, sep = " ") %>% as.data.frame() %>% select(.,-V1:-V5) %>% cbind(gen, .) -> gen
		}
	}

	colnames(gen) <- paste0("V",1:ncol(gen))

	summary <- fread(summary.file, h = T, sep = " ")

		message("Selecting Causal SNPs")

	snps <- causal.snps(summary = summary)
	colnames(snps)[3] <- "V3"


		message("Merging together and converting from Oxford to R format...")

	comb <- as.data.frame(merge(gen, snps, by = "V3"))

		comb$rsid <- NULL 
		comb$chromosome <- NULL
		comb$all_maf <- NULL
		comb$k <- NULL

	combR <- gen2r(genfile = comb, local = TRUE)
	
