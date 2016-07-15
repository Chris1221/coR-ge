#' Gen Phen to Df in preparation for Lm
#' 
#' Takes as input genotype and phenotype files and outputs a df ready to be analyzed through lm
#'
#' @import foreach 

gen_phen_df <- function(gen, samp){

	out <- data.frame()

	for(i in seq(6, ncol(gen), by = 3)) {

#	foreach(i = seq(6, ncol(gen), by = 3)) %do% {
		out[(i/3)-1,] <-t(0*gen[,i]+1*gen[,i+1]+2*gen[,i+2])
		print(i)
	}

	out$Z <- samp$Z[-1]

	return(out)

}
