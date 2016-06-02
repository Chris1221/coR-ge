#' Function for obtaining a vector of causal SNPs.
#'
#' @param .summary List of SNPs with attributes
#'
#' @import dplyr
#' @import data.table
#'
#' @export

causal.snps <- function(.summary = NULL, mode = "default"){

  snps <- NULL


  if(mode == "default"){

    .summary %>% sample_n(1000) %>% select(rsid, chromosome, position, all_maf) %>% rbind(snps, .) -> snps

    colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf")


  } else if(mode == "grouped"){

  	for(i in 1:max(.summary$k)){
  		.summary %>% filter(k==i) %>% sample_n(1000) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps}

  	# Not sure what to make of this right now.
  	colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf", "k")
  }

	return(snps)

}
