#' Correction of Genomes in R
#'
#' Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments
#'
#' @param i i index.
#' @param j j index.
#' @param path.base Base of the path.
#' @param summary.file Path to summary file.
#' @param output Output stream to write to.
#'
#' @return Flat file at specified path.
#' @export

analyze <- function(i = double(), j = double(), path.base = "/scratch/hpc2862/CAMH/perm_container/container_", summary.file = "/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", output = "~/repos/coR-ge/data/test_run.txt"){

		message("Error Checking")

	if(any(is.null(c(i,j,path.base, summary.file)))) stop("Please complete all input arguemnets")


		message("Loading required libraries...")

	if (!require("pacman")) install.packages("pacman", "http://cran.utstat.utoronto.ca/")
	library(pacman)
	p_load(data.table, dplyr, magrittr, devtools, foreach)

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

	snps <- causal.snps(summary)
	colnames(snps)[3] <- "V3"


		message("Merging together and converting from Oxford to R format...")

	comb <- as.data.frame(merge(gen, snps, by = "V3"))

		comb$rsid <- NULL
		comb$chromosome <- NULL
		comb$all_maf <- NULL
		comb$k <- NULL

	combR <- gen2r(genfile = comb, local = TRUE)

	b <- phen()


	combR <- as.data.frame(foreach(i = 1:nrow(combR), .combine = 'rbind') %:% foreach(j = 1:ncol(combR), .combine = 'c') %do% {
		combR[i,j] <- combR[i,j]*b[j] - b[j]*snps[j,"all_maf"] })

	WAS <- rowSums(combR)

	samp$Z <- as.character(foreach(i = 1:length(WAS), .combine = 'c') %do% WAS[i] + rnorm(1, 0, sd = sqrt(0.55)))


	var <- data.frame(0, 0, 0, "C")
	samp$Z <- as.character(samp$Z)
	colnames(var) <- colnames(samp)
	samp <- rbind(var, samp)

	message("Writing out temp files")

	write.table(samp, paste0(path,"phen_test.sample"), quote = FALSE, row.names=F, col.names = T, sep = "\t")
	write.table(gen, paste0(path,"gen_test.gen"), quote = FALSE, row.names = F, col.names = F)

# ----------------------------------------------

	message("Cleaning up")

	for(k in 1:5){
	  system(paste0("rm chr1_block_",i, "_perm_", j,"_k_", k, ".controls.gen"))
	}

	message("Bash calls")

	system(paste0("/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ", i, "_", j, "_out.ped --map ", i, "_", j, "_out.map --phenotype Z"))

	system("rm gtool.log")
	system("rm gen_test.gen")
	system("rm phen_test.sample")

	system(paste0("/home/hpc2862/Programs/binary_executables/plink --noweb --file ",path, i, "_", j, "_out --assoc --allow-no-sex --out ", path, "plink"))

	system("rm plink.log")
	system("rm plink.nosex")
	system(paste0("rm ", i, "_", j, "_out.ped"))
	system(paste0("rm ", i, "_", j, "_out.map"))

# -----------------------------------------

	message("Performing correction")

	snps %>% select(rsid) %>% as.vector -> snp_list

  n_strata <- 2
  strata <- stratify(snp_list = snp_list, p = 0.5, n_strata = n_strata)

  out <- correct(strata=strata, n_strata = n_strata, assoc = "plink.qassoc")

  if(!file.exists(output)) suppressWarnings(write.table(out, output, row.names = F, col.names = TRUE, quote = F, append = T)) else if(file.exists(output)) write.table(out, output, row.names = F, col.names = F, quote = F, append = T)
}
