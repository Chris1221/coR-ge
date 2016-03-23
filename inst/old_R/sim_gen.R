#' Simulate genomes function

sim.gen <- function(i = integer(), j = integer(), nj = integer(), container = "/scratch/hpc2862/CAMH/perm_container/", repo = "/home/hpc2862/repos/coR-ge/"){

	system(paste0("mkdir ", container, "container_", i, "_", j))
	system(paste0("qsub -N k_jobs_", i, "_", j, " ", repo, "k_hapgen.sh ", i, " ", j))

}
