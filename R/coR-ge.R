# this R script puts all the functions together into one
# this one run should be all that is needed

# this has not been error checked yet, see PR #3

################ !!! Create Genomes !!! ####################

nj <- 10
container = "/scratch/hpc2862/CAMH/perm_container/" 
repo = "/home/hpc2862/repos/coR-ge/R/"

for(i in 1:nj){
	for(j in 1:nj){

		sim.gen(i = i, j = j, nj = nj, container = container, repo = repo) 

	}
}

################ !!! Analyze !!! ####################

for(i in 1:nj){
	for(j in 1:nj){
		
		while (!file.exists(paste0("/scratch/hpc2862/CAMH/perm_container/container_", i, "_", j, "/", i, "_", j, "_done.txt") )) {
  			Sys.sleep(1)
		}
		analyze(i = i, j = j)	

	}
}


