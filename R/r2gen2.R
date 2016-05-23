gen[, -(1:5)] %>%
  as.matrix %>%
  t -> genM

# 9 betas
b <- phen(.combR = genM)

for(i in seq(1, nrow(genM), by = 3)){

  genM[i,] <- 0*genM[i,]
  genM[i+1,] <- 1*genM[i+1,]
  genM[i+2,] <- 2*genM[i+2,]

}

p <- genM %*% b

p2 <- vector()

for(i in seq(1, length(p), by = 3)){

  p2[(i+2)/3] <- p[i]+p[i+1]+p[i+2]

}
