#' Phenotype Calculation
#'
#' @param .snps SNPs matrix
#' @param .combR combR matrix
#'
#' 
#' @export

phen <- function(.snps = snps, .combR = combR, .h2 = h2){

	message("Calculating phenotypes...")


	nr = nrow(.combR)
	nc = ncol(.combR)

	if(!exists("nr")) stop("Something went wrong, check the .combR matrix.")


	samp <- vector()
	n_people <- nr/3 ## make sure this is right...
	ID_1 <- paste0("ID_1_", 1:n_people)
	ID_2 <- paste0("ID_2_", 1:n_people)
	samp <- cbind(ID_2, ID_1)
	samp <- as.data.frame(samp)
	samp$missing <- 0

#	row.names(.combR) <- samp$ID_1

	###calculate phenotypes HERE

	pheno <- vector()
	WAS <- vector()
	Zscore <- vector()

	## generate variance residuals

	sd2 <- rand(n = nc, sum = .h2)

	results <- vector()
	results <- as.data.frame(results)
	b <- vector()
	.snps <- as.data.frame(.snps)
	## calulate beta


	# Thirds
	#for(i in seq(1, 3*nc, by = 3)){
	#  	beta <- rand0()*sqrt(sd2[i]/(2*.snps[i,"all_maf"]*(1-.snps[i,"all_maf"])))
	#	b[i] <- beta; b[i+1] <- beta; b[i+2] <- beta
	#}

	for(i in 1:nc){
	  	b[i] <- rand0()*sqrt(sd2[i]/(2*.snps[i,"all_maf"]*(1-.snps[i,"all_maf"])))
	}

	if(any(!is.finite(b))) for(i in which(!is.finite(b))) b[i] <- 0

	message("Done!")
	assign("samp", samp, env = globalenv())
	return(b)



}
