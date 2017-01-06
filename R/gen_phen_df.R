#' Gen Phen to Df in preparation for Lm
#' 
#' Takes as input genotype and phenotype files and outputs a df ready to be analyzed through lm
#'
#' @importFrom dplyr %>%
#'
#' @export

assoc_wrapper <- function(gen, samp){

	phen <- samp$Z[-1] %>% as.vector %>% as.double

	out <- assoc(as.matrix(gen[,-c(1:5)]), phen)
	t <- out[,1] / out[,2]
	
	P <- pt(t, df = length(phen) -2, lower = FALSE)*2

	return(data.frame(rsid = gen[,2], out[,1], out[,2], P = P))






############################
#	This is the old version
#	It worked pretty well but we're going to try to speed it up

#	P <- vector()
#	
#	phen <- samp$Z[-1] %>% as.vector
#	
#	seq1 <- seq(1, ncol(gen)-5, by = 3)
#	seq2 <- seq1+1
#	seq3 <- seq1+2
#
#	gen2 <- t(gen[, -c(1:5)])	
#
#	for(i in 1:ncol(gen2)){
#		snp <- gen2[,i]
#		snp <- 0*snp[seq1] + 1*snp[seq2] + 2*snp[seq3]
#	
#		cse <- fastLmPure(cbind(1,matrix(snp)), as.double(phen))[c(1,2)]
#		b <- cse[[1]][2]
#		se <- cse[[2]][2]
#
#		P[i] <- pt(b / se, df = length(snp) - 2, lower = FALSE)*2
#
#	}
#	
#	return(data.frame(rsid = gen[,2], P = P))
}
