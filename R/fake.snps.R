#' Create a vector of fake non-sense SNPs
#'
#' @param summary Summary sheet with info on SNPs
#' @param n Number to generate
#' @param group Optional grouping paramter. Reports as a list

fake.snps <- function(summary = NULL, n= 3000, group = NULL){

	library(dplyr, warn.conflicts = FALSE, quietly = TRUE)

	if(is.null(summary)) stop("Please input a list of SNPs with characteristics to select based off of.")
	if(is.null(n)) stop("Input number of fake snps")
	if(is.null(group)) message("No grouping parameter selected")

	# will have to change the SELECT statement if change the group...
	# dont know how to do this yet.

	fake_snps <- list()

	if(!is.null(group)){
		for(i in group){

		summary %>% 
			filter(k == i) %>%
			sample_n(n) %>%
			select(rsid) %>%
			as.vector ->
			fake_snps[[i]]
		}
	}

	return(fake_snps)
}
