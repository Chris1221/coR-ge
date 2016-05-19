#' Function for obtaining a vector of causal SNPs.
#'
#' @param summary List of SNPs with attributes

causal.snps <- function(summary = NULL){
	
	snps <- NULL

	for(i in 1:max(summary$k)){

		summary %>% filter(k==i) %>% sample_n(1000) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps

	}

	# Not sure what to make of this right now.
	colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf", "k")

	return(snps)

}