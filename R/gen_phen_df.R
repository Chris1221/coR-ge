#' Gen Phen to Df in preparation for Lm
#' 
#' Takes as input genotype and phenotype files and outputs a df ready to be analyzed through lm
#'
#' @importFrom dplyr %>%
#' @import RcppArmadillo
#'
#' @export

gen_phen_df <- function(gen, samp){

	P <- vector()

	phen <- samp$Z[-1] %>% as.vector
	
	seq1 <- seq(1, ncol(gen)-5, by = 3)
	seq2 <- seq1+1
	seq3 <- seq1+2

	gen2 <- t(gen[, -c(1:5)])	

	for(i in 1:ncol(gen2)){
		snp <- gen2[,i]
		snp <- 0*snp[seq1] + 1*snp[seq2] + 2*snp[seq3]
	
		cse <- fastLmPure(cbind(1,matrix(snp)), as.double(phen), method = 1)[c(1,2)]
		b <- cse[[1]][2]
		se <- cse[[2]][2]

		P[i] <- pt(b / se, df = length(snp) - 2, lower = FALSE)*2

		print(i)

	}
}
