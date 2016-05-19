#' Random Number Generator 
#'
#' Generates n numbers which add up to sum
#'
#' @param n Number of values to simulate
#' @param sum Sum of n numbers
#' @param start Lower bound of number generation.
#' 
#' @return A vector of n numbers which add up to sum
#'
#' @export

rand <- function(n = NULL, sum = NULL, start = 0){
  v2 <- vector()
  start <- 0
  end <- sum

  v <- runif(n-1, start, sum)
  v[n] <- 0
  v[n+1] <- sum

  v <- sort(v)

  for(i in 1:n){

	v2[i] <- v[i+1]-v[i]
  }

  return(v2)
}
