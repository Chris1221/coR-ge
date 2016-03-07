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