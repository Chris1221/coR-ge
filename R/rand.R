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