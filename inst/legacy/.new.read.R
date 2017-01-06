inputFile <- "../inst/extdata/toy.gen"


system.time({
con  <- file(inputFile, open = "r")

out <- data.table(ID = 1:1000)

while (length(oneLine <- readLines(con, n = 1, warn = FALSE)) > 0) {
  myVector <- (strsplit(oneLine, " "))
  myVector <- as.vector(as.factor(unlist(myVector)))

  foreach(row = 1:nrow(gen)) %:% foreach(i = seq(6,((length(myVector)-2)),by=3), .combine = c) %do% {

    myVector <- gen[row,]

    j <- i + 1
    h <- i + 2

    one <- myVector[i]
    two <- myVector[j]
    three <- myVector[h]

    final <- NA

    if (one > 0.9) {
      final <- 0
    } else if (two > 0.9) {
      final <- 1
    } else if (three > 0.9) {
      final <- 2
    } else {
      final <- NA
    }

    final

  }


  out[, myVector[3] := vec, with = FALSE] -> out
  message(paste0(ncol(out)))

}

close(con)

})

#---------------------------

