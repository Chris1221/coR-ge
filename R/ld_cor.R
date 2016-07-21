#' LD True Postiive Thresholding function
#' 
#' Wrapper for the returnLD function
#'
#' @export

ld_cor <- function(snp, gen){

	# Get list of Causal SNPs as a vector
	snp$rsid -> snp_list

	# Create index of where each of the causal SNPs are in the gen file.
	# Note that we have to subtract 1 to account for C++ starting at 0 
	# instead of 1.
	cIndex <- which(gen[,2] %in% snp_list)
	cIndex <- cIndex - 1

	# Run through src/ld.cpp and return list with each element of the
	# list being the matching LD with each subsequent causal SNP and their
	# position in the gen matrix.
	LdList <- returnLD(cIndex, as.matrix(gen[,-c(1:5)]), gen[,3])

	# Replace index number with RSID	
	for(i in 1:length(LdList)) LdList[[i]][,1] <- snp_list[LdList[[i]][,1]]
		
	# Combine all into one large list of LD values.
	LdList <- do.call("rbind", LdList)

	# We want to keep the ones with the highest LD preferentially
	# So sort on ID but on reverse of LD, then take the not duplicated
	# ones.

	LdList2 <- LdList[base::order(LdList[,1], -(as.double(LdList[,2]))),]
	LdList3 <- LdList2[ !duplicated(LdList2[,1]), ]

	LdList3 <- as.data.frame(LdList3, stringsAsFactors = FALSE)
	colnames(LdList3) <- c("rsid", "ld")
	LdList3$ld <- as.double(LdList3$ld)

	return(LdList3)

}
