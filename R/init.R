#' Initialize a testing environment
#' 
#' @export

init <- function(){
	library(dplyr)
	library(data.table)
	library(magrittr)
	library(foreach)

	setwd("/scratch/hpc2862/CAMH/perm_container")

	i = double()
	j = double()
	mode = "default"
	path.base = "/scratch/hpc2862/CAMH/perm_container/container_"
	summary.file = "/scratch/hpc2862/CAMH/perm_container/snp_summary2.out"
	output = "~/repos/coR-ge/data/test_run2.txt"
	test = TRUE
	safe = TRUE

	if(!require(devtools)) install.packages("devtools")
	devtools::install_github("Chris1221/coR-ge", ref = "devel")
}
