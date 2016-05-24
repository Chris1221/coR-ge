#' Takes gen file and calculates weighted allele scores (WAS)
#'
#' @param gen Truncated gen file with only causal snps
#' @param snps Truncated summary file with only causal snps
#'
#' @import data.table
#' @import dplyr
#'
#' @return A vector of weighted allele scores
#' @export

calculate_was <- function(gen = NULL, snps = NULL){

  if(is.null(gen)) stop("Please input a gen matrix")
  if(is.null(snps)) stop("Please input a snps matrix")

  gen[, -(1:5)] %>%
    t -> genM

  # 9 betas
  b <- phen(.combR = genM)

  for(i in seq(1, nrow(genM), by = 3)){

    genM[i,] <- 0*genM[i,]
    genM[i+1,] <- 1*genM[i+1,]
    genM[i+2,] <- 2*genM[i+2,]

  }

  p <- genM %*% b

  maf <- snps$all_maf
  p2 <- vector()

  for(i in seq(1, length(p), by = 3)){

    j <- (i+2)/3
    p2[j] <- p[i]+p[i+1]+p[i+2]-maf[j] # this might not be perfect

  }

  return(p2)

}
