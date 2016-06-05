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
#'
#' @import foreach
#' @import devtools
#' @importFrom lazyeval interp
#' @importFrom data.table fread fwrite
#' @importFrom magrittr %<>%
#' @importFrom dplyr mutate mutate_ filter filter_ select select_ sample_n %>%
#'
#' @return Flat file at specified path.
#' @export

analyze <- function(i = double(), j = double(), mode = "default", path.base = "/scratch/hpc2862/CAMH/perm_container/container_", summary.file = "/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", output = "~/repos/coR-ge/data/test_run2.txt", test = TRUE, safe = TRUE){


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


# 	     ___         __                _  _
# 	    /   \  ___  / _|  __ _  _   _ | || |_
# 	   / /\ / / _ \| |_  / _` || | | || || __|
# 	  / /_// |  __/|  _|| (_| || |_| || || |_
# 	/___,'   \___||_|   \__,_| \__,_||_| \__|
#


	if(is.null(mode) || mode == "default"){


    		message("Selecting Causal SNPs")

    	snps <- causal.snps(summary, mode = "default")
    	colnames(snps)[3] <- "V3"


    		message("Merging together and converting from Oxford to R format...")

    	comb <- as.data.frame(merge(gen, snps, by = "V3"))

    		comb$rsid <- NULL
    		comb$chromosome <- NULL
    		comb$all_maf <- NULL
    		comb$k <- NULL
    		comb$chromosomes <- NULL

    		WAS <- calculate_was(gen = comb, snps = snps)

    	samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(0.55)))


    	var <- data.frame(0, 0, 0, "P")
    	samp$Z <- as.character(samp$Z)
    	colnames(var) <- colnames(samp)
    	samp <- rbind(var, samp)

    	message("Writing out temp files")

    	fwrite(samp, paste0(path,"phen_test.sample"), quote = FALSE, col.names = T, sep = "\t")
    	fwrite(gen, paste0(path,"gen_test.gen"), quote = FALSE, col.names = F, sep = "\t")

    # ----------------------------------------------

    	message("Cleaning up")

    	if(!safe){
      	for(k in 1:5){
      	  system(paste0("rm chr1_block_",i, "_perm_", j,"_k_", k, ".controls.gen"))
      	}
    	}

    	message("Bash calls")

    	system(paste0("/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ", i, "_", j, "_out.ped --map ", i, "_", j, "_out.map --phenotype Z"))

    	if(!safe){
      	system("rm gtool.log")
      	system("rm gen_test.gen")
      	system("rm phen_test.sample")
      }

    	system(paste0("/home/hpc2862/Programs/binary_executables/plink --noweb --file ",path, i, "_", j, "_out --assoc --allow-no-sex --out ", path, "plink"))


    	if(!safe){
      	system("rm plink.log")
      	system("rm plink.nosex")
      	system(paste0("rm ", i, "_", j, "_out.ped"))
      	system(paste0("rm ", i, "_", j, "_out.map"))
    	}
    # -----------------------------------------

    	message("Performing correction")

    	snps %>% select(rsid) %>% as.vector -> snp_list

      n_strata <- 2
      strata <- stratify(snp_list = snp_list, summary = summary, p = 0.5, n_strata = n_strata)

      out <- correct(strata=strata, n_strata = n_strata, assoc = "plink.qassoc", group = FALSE)



#            ___                                       _
#           / _ \ _ __   ___   _   _  _ __    ___   __| |
#          / /_\/| '__| / _ \ | | | || '_ \  / _ \ / _` |
#         / /_\\ | |   | (_) || |_| || |_) ||  __/| (_| |
#         \____/ |_|    \___/  \__,_|| .__/  \___| \__,_|
#                                    |_|



  } else if(mode == "grouped"){

    message("Selecting Causal SNPs")

    snps <- causal.snps(summary, mode = "grouped")
    colnames(snps)[3] <- "V3"


    message("Merging together and converting from Oxford to R format...")

    comb <- as.data.frame(merge(gen, snps, by = "V3"))

    comb$rsid <- NULL
    comb$chromosome <- NULL
    comb$all_maf <- NULL
    comb$k <- NULL
    comb$chromosomes <- NULL

    WAS <- calculate_was(gen = comb, snps = snps)

    samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(0.55)))


    var <- data.frame(0, 0, 0, "P")
    samp$Z <- as.character(samp$Z)
    colnames(var) <- colnames(samp)
    samp <- rbind(var, samp)

    message("Writing out temp files")

    fwrite(samp, paste0(path,"phen_test.sample"), quote = FALSE, col.names = T, sep = "\t")
    fwrite(gen, paste0(path,"gen_test.gen"), quote = FALSE, col.names = F, sep = "\t")

    # ----------------------------------------------

    message("Cleaning up")

    if(!safe){
      for(k in 1:5){
        system(paste0("rm chr1_block_",i, "_perm_", j,"_k_", k, ".controls.gen"))
      }
    }

    message("Bash calls")

    system(paste0("/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ", i, "_", j, "_out.ped --map ", i, "_", j, "_out.map --phenotype Z"))

    if(!safe){
      system("rm gtool.log")
      system("rm gen_test.gen")
      system("rm phen_test.sample")
    }

    system(paste0("/home/hpc2862/Programs/binary_executables/plink --noweb --file ",path, i, "_", j, "_out --assoc --allow-no-sex --out ", path, "plink"))


    if(!safe){
      system("rm plink.log")
      system("rm plink.nosex")
      system(paste0("rm ", i, "_", j, "_out.ped"))
      system(paste0("rm ", i, "_", j, "_out.map"))
    }
    # -----------------------------------------

    message("Performing correction")

    snps %>% select(rsid) %>% as.vector -> snp_list

    n_strata <- 2
    strata <- stratify(snp_list = snp_list, summary = summary, p = 0.5, n_strata = n_strata)

    out <- correct(strata=strata, n_strata = n_strata, assoc = "plink.qassoc", group = TRUE, group_name = "k")




#           ,--.   ,------.
#           |  |   |  .-.  \
#           |  |   |  |  \  :
#           |  '--.|  '--'  /
#           `-----'`-------'


  } else if(mode == "ld"){


    message("Selecting Causal SNPs")

    snps <- causal.snps(summary, mode = "default")
    colnames(snps)[3] <- "V3"

    message("Merging together and converting from Oxford to R format...")

    comb <- as.data.frame(merge(gen, snps, by = "V3"))

    comb$rsid <- NULL
    comb$chromosome <- NULL
    comb$all_maf <- NULL
    comb$k <- NULL
    comb$chromosomes <- NULL

    WAS <- calculate_was(gen = comb, snps = snps)

    samp$Z <- as.character(foreach(q = 1:length(WAS), .combine = 'c') %do% WAS[q] + rnorm(1, 0, sd = sqrt(0.55)))


    var <- data.frame(0, 0, 0, "P")
    samp$Z <- as.character(samp$Z)
    colnames(var) <- colnames(samp)
    samp <- rbind(var, samp)

    message("Writing out temp files")

    fwrite(samp, paste0(path,"phen_test.sample"), quote = FALSE, col.names = T, sep = "\t")
    fwrite(gen, paste0(path,"gen_test.gen"), quote = FALSE, col.names = F, sep = "\t")

    message("Cleaning up")

    if(!safe){
      for(k in 1:5){
        system(paste0("rm chr1_block_",i, "_perm_", j,"_k_", k, ".controls.gen"))
      }
    }

    message("Bash calls")

    system(paste0("/home/hpc2862/Programs/binary_executables/gtool -G --g gen_test.gen --s phen_test.sample --ped ", i, "_", j, "_out.ped --map ", i, "_", j, "_out.map --phenotype Z"))

    if(!safe){
      system("rm gtool.log")
      system("rm gen_test.gen")
      system("rm phen_test.sample")
    }

    system(paste0("/home/hpc2862/Programs/binary_executables/plink --noweb --file ",path, i, "_", j, "_out --assoc --allow-no-sex --out ", path, "plink"))

    if(!safe){
      system("rm plink.log")
      system("rm plink.nosex")
      system(paste0("rm ", i, "_", j, "_out.ped"))
      system(paste0("rm ", i, "_", j, "_out.map"))
    }
    # -----------------------------------------

	message("Calculating LD...")

	#write out a list of causal SNPs
  snps %>% select(rsid) %>% as.vector -> snp_list
  write.table(snp_list, paste0(path, "list.txt"), col.names = F, row.names = F, quote = F)

  system(paste0("/home/hpc2862/Programs/binary_executables/plink2 --file ", path, i, "_", j, "_out --r2 --ld-snp-list ", path ,"list.txt --ld-window 99999 --ld-window-kb 500 --ld-window-r2 0.2 --allow-no-sex"))

  ld <- fread(paste0(path, "list.txt"), h = T)

	message("Performing correction")

    n_strata <- 2
    strata <- stratify(snp_list = snp_list, summary = summary, p = 0.5, n_strata = n_strata)

  #th = threshold

  strata$k <- as.double(strata$k)
  strata$k <- 0

  for(th in c(0.2, 0.4, 0.6, 0.8, 0.9, 1)){

  	snp_b <- ld %>% filter(R2 > th) %>% select(SNP_B)
  	
  	# old, untested, does not conform to grouping to k	
  	#strata %<>% SE_mutate(col1 = rsid, col2 = snp_b,new_col_name = paste0("th", th))
	
	# New, attempt to conform to group to k.
  	# Not dplyr but maybe depricate later

  	strata$k[strata$rsid %in% snp_b] <- th

  }

    out <- correct(strata=strata, n_strata = n_strata, assoc = "plink.qassoc", group = TRUE, group = "k")


  }




  if(!file.exists(output)) suppressWarnings(write.table(out, output, row.names = F, col.names = TRUE, quote = F, append = T)) else if(file.exists(output)) write.table(out, output, row.names = F, col.names = F, quote = F, append = T)
}
