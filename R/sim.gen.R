#' Haplotpe Simulation Function
#'
#' Generate random simulated haplotypes with Hapgen2 through qsub.
#'
#' @param i Index 1
#' @param j Index 2
#' @param nj Number of jobs
#' @param container Where should the simulated genotypes be put? This should be a root diretory where the function can create nj x i containers to store the different runs.
#'
#' @return nj x i different folders stemming from the root directory specified by container
#'
#' @export

sim.gen <- function(i = integer(), j = integer(), nj = integer(), container = "/scratch/hpc2862/CAMH/perm_container/"){

	k_hapgen <- system.file("bash", "k_hapgen.sh",package = "coRge")

	system(paste0("mkdir ", container, "container_", i, "_", j))
	system(paste0("qsub -N k_jobs_", i, "_", j, " ", k_hapgen, " ", i, " ", j))

}
