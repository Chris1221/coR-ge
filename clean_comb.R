#' Correction of Genomes in R
#'
#' Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments
#'
#' @param i Index 1
#' @param j Index 2

mineR <- function(i = double(), j = double()){

	setwd(paste0("/scratch/hpc2862/CAMH/perm_container/container_",i,"_","j))

	for(i in 1:10){
		#clear out excess files
		system(paste0("rm chr1_block_",i,"_perm_",k,"_k_",j,".cases.gen; ",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".cases.haps;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".cases.sample;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".cases.summary;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".cases.legend;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".controls.sample;",
			"rm chr1_block_",i,"_perm_",k,"_k_",j,".controls.haps;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".controls.summary;",
  			"rm chr1_block_",i,"_perm_",k,"_k_",j,".controls.legend"))

	}

}
