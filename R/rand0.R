#' Delta Generator Function
#'
#' Creates a random number which is either -1 or 1 with .5 probability of either.
#'
#' @return Delta which either 1 or -1 with equal probability.
#' 
#' @export


rand0 <- function(){
	num <- vector()
	n <- runif(1,0,1)
	if(n > 0.5){
		num <- 1
	} else if(n < 0.5){
		num <- -1
	} else{
		break("Random generator malfunction in delta")
	}

	return(num)
}
