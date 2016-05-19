#' Submission Convenience function
#' 
#' @param n Number of jobs to submit. Defaults 
#' 
#' @return Nothing. Submits directly to QSUB; check with qstat.
#' 
#' @export


sub <- function(n = NULL){

	if (is.null(n)) stop("Give a value for n")

	for(i in 1:n){
		for(j in 1:n){
			sh <- system.file("bash", "sub.sh")
    			system(paste0("qsub -N ", i, " ", j, " ", sh, " ", i, " ", j))
			message(paste0("Submitted i = ", i, " j = ", j))
		}
	}
}
