args<-commandArgs(TRUE)
i <- args[1]
j <- args[2]
path <- paste0("/scratch/hpc2862/CAMH/perm_container/container_",i,"_",j,"/")
setwd(path)

l <- length(list.files())

while(l != 80){
  l <- length(list.files())
}

command <- paste0("qsub /home/hpc2862/Scripts/sFDR/clean_comb.sh $", i, " $", j)
system(command)
