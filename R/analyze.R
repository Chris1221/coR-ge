#' Correction of Genomes in R
#'
#' Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments
#'
#' @param i i index.
#' @param j j index.
#' @param path.base Base of the path.
#' @param summary.file Path to summary file.
#' @param output Output stream to write to.
#' @param test testing (only read one gen file)
#' @param safe Don't delete files
#' @param h2 Proportion of heritability explained by causal SNPS
#' @param pc Proportion of causal SNPs in the second strata
#' @param pnc Proportion of noncausal SNPs in the second strata
#' @param nc Number of causal SNPs
#' @param gen Gen matrix if local 
#' @param summary Summary file if preread
#' @param maf Maf or no
#' @param maf_range MAF range
#'
#' @import foreach
#' @import devtools
#' @importFrom lazyeval interp
#' @importFrom data.table fread 
#' @importFrom magrittr %<>%
#' @importFrom dplyr mutate mutate_ filter filter_ select select_ sample_n %>%
#' @importFrom Rcpp evalCpp
#'
#' @useDynLib coRge
#'
#' @return Flat file at specified path.
#' @export



analyze <- function(i = double(),
		    j = double(),
		    mode = "default",
		    path.base = "/scratch/hpc2862/CAMH/perm_container/container_",
		    summary.file = "/scratch/hpc2862/CAMH/perm_container/snp_summary2.out",
		    output = "~/repos/coR-ge/data/test_run2.txt",
		    test = TRUE,
		    safe = TRUE,
		    local = FALSE,
		    h2 = 0.45,
		    pc = 0.5,
		    pnc = 0.5,
		    nc = 1000,
		    gen = NULL,
		    summary = summary,
		    maf = FALSE,
		    maf_range = NULL){

	if(local) {

		gen <- gen
		summary <- summary

	} else if(!local){

			message("Error Checking")

		if(any(is.null(c(i,j,path.base, summary.file)))) stop("Please complete all input arguemnets")

		path <- paste0(path.base,i,"_",j,"/")
		setwd(path)


			message("Deleting junk files...")

		list.files(path)[!grepl("controls.gen", list.files(path))] %>%
			file.remove

			message("Reading in genotype files...")

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
		summary <- fread(summary.file, h = T, sep = " ")

	}

# 	     ___         __                _  _
# 	    /   \  ___  / _|  __ _  _   _ | || |_
# 	   / /\ / / _ \| |_  / _` || | | || || __|
# 	  / /_// |  __/|  _|| (_| || |_| || || |_
# 	/___,'   \___||_|   \__,_| \__,_||_| \__|
#


	if(is.null(mode) || mode == "default"){


    		message("Selecting Causal SNPs")

    	snps <- causal.snps(summary, mode = "default", nc = nc)
    	colnames(snps)[3] <- "V3"


    		message("Merging together and converting from Oxford to R format...")

    	comb <- as.data.frame(merge(gen, snps, by = "V3"))

    		comb$rsid <- NULL
    		comb$chromosome <- NULL
    		comb$all_maf <- NULL
    		comb$k <- NULL
    		comb$chromosomes <- NULL

    		WAS <- calculate_was(gen = comb, snps = snps, h2 = h2)

    	samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(1-h2)))


    	var <- data.frame(0, 0, 0, "P")
    	samp$Z <- as.character(samp$Z)
    	colnames(var) <- colnames(samp)
    	samp <- rbind(var, samp)

	P_list <- assoc_wrapper(gen, samp)

    	message("Performing correction")

	snps %>% select(rsid) %>% as.vector -> snp_list

	#this is a major assumption so leave it
	n_strata <- 2
	strata <- stratify(snp_list = snp_list, summary = summary, n_strata = n_strata, pc = pc, pnc = pnc)

	out <- correct(strata=strata, n_strata = n_strata, assoc = P_list, group = FALSE)

	


#            ___                                       _
#           / _ \ _ __   ___   _   _  _ __    ___   __| |
#          / /_\/| '__| / _ \ | | | || '_ \  / _ \ / _` |
#         / /_\\ | |   | (_) || |_| || |_) ||  __/| (_| |
#         \____/ |_|    \___/  \__,_|| .__/  \___| \__,_|
#                                    |_|



  } else if(mode == "grouped"){


#NEW


    		message("Selecting Causal SNPs")

    	snps <- causal.snps(summary, mode = "default", nc = nc)
    	colnames(snps)[3] <- "V3"


    		message("Merging together and converting from Oxford to R format...")

    	comb <- as.data.frame(merge(gen, snps, by = "V3"))

    		comb$rsid <- NULL
    		comb$chromosome <- NULL
    		comb$all_maf <- NULL
    		comb$k <- NULL
    		comb$chromosomes <- NULL

    		WAS <- calculate_was(gen = comb, snps = snps, h2 = h2)

    	samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(1-h2)))


    	var <- data.frame(0, 0, 0, "P")
    	samp$Z <- as.character(samp$Z)
    	colnames(var) <- colnames(samp)
    	samp <- rbind(var, samp)

	P_list <- assoc_wrapper(gen, samp)

    	message("Performing correction")

	snps %>% select(rsid) %>% as.vector -> snp_list

	#this is a major assumption so leave it
	n_strata <- 2
	strata <- stratify(snp_list = snp_list, summary = summary, n_strata = n_strata, pc = pc, pnc = pnc)

	out <- correct(strata=strata, n_strata = n_strata, assoc = P_list, group = TRUE, group_name = "k")


#           ,--.   ,------.
#           |  |   |  .-.  \
#           |  |   |  |  \  :
#           |  '--.|  '--'  /
#           `-----'`-------'


  } else if(mode == "ld"){

	message("Selecting Causal SNPs")

    	snps <- causal.snps(summary, mode = "default", nc = nc)
    	colnames(snps)[3] <- "V3"


    		message("Merging together and converting from Oxford to R format...")

    	comb <- as.data.frame(merge(gen, snps, by = "V3"))

    		comb$rsid <- NULL
    		comb$chromosome <- NULL
    		comb$all_maf <- NULL
    		comb$k <- NULL
    		comb$chromosomes <- NULL

    		WAS <- calculate_was(gen = comb, snps = snps, h2 = h2)

    	samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(1-h2)))


    	var <- data.frame(0, 0, 0, "P")
    	samp$Z <- as.character(samp$Z)
    	colnames(var) <- colnames(samp)
    	samp <- rbind(var, samp)

	P_list <- assoc_wrapper(gen, samp)

    	message("Performing correction")

	snps %>% select(rsid) %>% as.vector -> snp_list

	#this is a major assumption so leave it
	n_strata <- 2
	strata <- stratify(snp_list = snp_list, summary = summary, n_strata = n_strata, pc = pc, pnc = pnc)

	# Set the grouping factor to a factor
	strata$k <- as.factor(strata$k)

	# Initialize a column for the LD to sit in
	# Initiate it with 0 and then sequentially overwrite.
	strata$ld <- 0

	# Calculate the LD from ld.cpp 
	LdList <- ld_cor(snps, gen)
	
	# Loop through each of the LD TP thresholds.
	for(th in c(0.2, 0.4, 0.6, 0.8, 0.9, 1)){
		
		# Create a list of SNPs which have higher than the threshold
		# LD.
		snp_b <- LdList$rsid[LdList$ld > th]
		
		# Assign the threshold value to each of these SNPs.
		strata$ld[strata$rsid %in% snp_b] <- th
	}

	 out <- correct(strata=strata, n_strata = n_strata, assoc = P_list, group = FALSE, mode = "ld")


  }


  out$h2 <- h2
  out$pnc <- pnc
  out$pc <- pc
  out$nc <- nc
  out$i <- i
  out$j <- j
  out$maf_l <- maf_range[1]
  out$maf_u <- maf_range[2]


  if(!file.exists(output)) suppressWarnings(write.table(out, output, row.names = F, col.names = TRUE, quote = F, append = T)) else if(file.exists(output)) write.table(out, output, row.names = F, col.names = F, quote = F, append = T)


  return(0)

}
