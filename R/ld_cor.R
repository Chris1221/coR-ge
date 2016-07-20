#' LD True Postiive Thresholding function
#' 
#' Wrapper for the returnLD function
#'
#' @export

ld_cor <- function(snp, gen){

	snp$rsid -> snp_list

	cIndex <- which(gen[,2] %in% snp_list)

	LdList <- returnLD(cIndex, as.matrix(gen))
	

}
