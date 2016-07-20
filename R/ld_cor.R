#' @importFrom foreach foreach 

ld_cor <- function(snp_list, gen){

	cIndex <- which(snp_list %in% gen[,2])

	LdList <- returnLD(cIndex, as.matrix(gen))
	

}
