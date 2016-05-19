#' Oxford style genotype conversion
#' 
#' @param genfile File to convert
#' @param local TRUE is the file is already in the R workspace. FALSE if the file is a path which must be read in.


gen2r.par <- function(genfile, local = TRUE) {

	# Set up multi core backend.
	library(doMC)
	registerDoMC(cores=4)

	#Read in genfile
  if(local == TRUE){
	gen <- genfile
  } else if(local == FALSE){
	gen <- fread(genfile, sep = " ", h = F); gen <- as.data.frame(gen)
  }

	output <- data.frame(matrix(nrow=((ncol(gen)-5)/3),ncol=(nrow(gen))))

	foreach(row = 1:nrow(gen), .combine = rbind) {

		# go from 2 so not include index column
		#subtract two so that last i is the third last element in the table, thus getting all people
		for(i = seq(6,((ncol(gen)-2)),by=3), .combine = rbind) {
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
