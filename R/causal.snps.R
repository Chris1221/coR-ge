#' Function for obtaining a vector of causal SNPs.
#'
#' @param .summary List of SNPs with attributes
#' @param mode Mode
#' @param nc Number of causal SNPs
#' @param maf TRUE is selecting via maf
#' @param maf_range Range of the form c(lower, upper)
#'
#' @importFrom dplyr sample_n select filter
#' @importFrom data.table fread fwrite
#'
#' @export

causal.snps <- function(.summary = NULL, mode = "default", nc = NULL, maf = FALSE, maf_range = NULL){

  	snps <- NULL


	if(maf){

		l <- maf_range[1]
		u <- maf_range[2]

		if(mode == "default"){

		.summary %>% filter(all_maf > l & all_maf < u) %>% sample_n(nc) %>% select(rsid, chromosome, position, all_maf) %>% rbind(snps, .) -> snps

		colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf")


		} else if(mode == "grouped"){

		for(i in 1:max(.summary$k)){
			.summary %>% filter(all_maf > l & all_maf < u) %>% filter(k==i) %>% sample_n(nc) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps}

		# Not sure what to make of this right now.
		colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf", "k")
		}

	} else if(!maf) {

		if(mode == "default"){

		.summary %>% sample_n(nc) %>% select(rsid, chromosome, position, all_maf) %>% rbind(snps, .) -> snps

		colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf")


		} else if(mode == "grouped"){

		for(i in 1:max(.summary$k)){
			.summary %>% filter(k==i) %>% sample_n(nc) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps}

		# Not sure what to make of this right now.
		colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf", "k")
		}
	

	}



	return(snps)

}
