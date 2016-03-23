
SNPTEST_2_R <- function(genfile, local = TRUE) {

	#install.packages("data.table", repos = "http://cran.utstat.utoronto.ca/");library(data.table)

	#Read in genfile
  if(local == TRUE){
	gen <- genfile
  } else if(local == FALSE){
	gen <- fread(genfile, sep = " ", h = F); gen <- as.data.frame(gen)
  }

  #read in samplefile
#   samp <- fread(samplefile, sep = " ", h = T); samp <- as.data.frame(samp)

  #clean up gen files
	#gen[,1] <- NULL; gen[,3] <- NULL; gen[,4] <- NULL; gen[,5] <- NULL
	#remove variable type in sample
#   samp <- samp[-1,]
	output <- data.frame(matrix(nrow=((ncol(gen)-5)/3),ncol=(nrow(gen))))

	for(row in 1:nrow(gen)) {
		# go from 2 so not include index column
		#subtract two so that last i is the third last element in the table, thus getting all people
		for(i in seq(6,((ncol(gen)-2)),by=3)) {
			#print(row)
			j <- i + 1
			h <- i + 2

			one <- gen[row,i]
			two <- gen[row,j]
			three <- gen[row,h]

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

			output[(i/3-1),row] <- final
		}
	}
	colnames(output) <- gen[,3]
	#R_table <- cbind(samp,output)
	return(output)
	#rm(gen,samp,output)
	}