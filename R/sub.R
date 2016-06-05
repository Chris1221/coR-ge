#' Submission Convenience function
#' 
#' @param n Number of jobs to submit. Defaults 
#' 
#' @return Nothing. Submits directly to QSUB; check with qstat.
#' 
#' @export


sub_job <- function(ni = NULL, nj = NULL){

	if (is.null(n)) stop("Give a value for n")

	for(i in ni){
		for(j in nj){
			sh <- system.file(package = "coRge", "bash/submit.sh")
			r <- system.file(package = "coRge", "bash/submit.R")
    			system(paste0("qsub -N ld_run_", i, "_", j, " ", sh, " ", i, " ", j, " ", r))
			message(paste0("Submitted i = ", i, " j = ", j))
		}
	}
}
