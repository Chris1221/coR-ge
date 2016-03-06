#' Correction of Genomes in R
#'
#' Software for the Examination of Multiple Correction Methodologies in Accurate Genomic Environments
#'
#' @param i Index 1
#' @param j Index 2
#' @param k Index 3

mineR <- function(i = double(), j = double(), k = double()){

	setwd(paste0("/scratch/hpc2862/CAMH/perm_container/container_",i,"_",j))

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
			"rm chr1_block_",i,"_perm_",k,"_k_",j,".controls.legend"))}

########### this is the begining of rand.R ##################

path <- paste0("/scratch/hpc2862/CAMH/perm_container/container_",i,"_",j,"/")

install.packages("data.table", repos = "http://cran.utstat.utoronto.ca/");library(data.table)
install.packages("dplyr", repos = "http://cran.utstat.utoronto.ca/");library(dplyr)

setwd("/home/hpc2862/Raw_Files/CAMH/1kg_hapmap_comb/hapmap3_r2_plus_1000g_jun2010_b36_ceu/test_mar_30")

### initialize functions before
## can only use local cache
## module load Rscript
#want to use this, must modify to get rid of samplefile requirement; make up custom IDs for when translating to R......
#how, not sure.

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

rand <- function(n = NULL, sum = NULL, start = 0){
  v2 <- vector()
  start <- 0
  end <- sum

  v <- runif(n-1, start, sum)
  v[n] <- 0
  v[n+1] <- sum

  v <- sort(v)

  for(i in 1:n){

	v2[i] <- v[i+1]-v[i]
  }

  return(v2)
}

rand0 <- function(){
	num <- vector()
	n <- runif(1,0,1)
	if(n > 0.5){
		num <- 1
	} else if(n < 0.5){
		num <- -1
	} else{
		break("Random generator malfunction in delta")
	}

	return(num)
}

### ---------------- !!!
##                   !!!
# SCRIPT STARTS HERE !!!
##                   !!!
### ---------------- !!!



## hard coded for now, but will switch to relative

#gen <- fread(paste0(path, "chr1_block_", i, "_perm_1_k_", j, "1.controls.gen"), h = F, sep = " ")

gen1 <- fread(paste0(path, "chr1_block_", i, "_perm_1_k_", j, ".controls.gen"), h = F, sep = " ")
gen1 <- as.data.frame(gen1)
gen2 <- fread(paste0(path, "chr1_block_", i, "_perm_2_k_", j, ".controls.gen"), h = F, sep = " ")
gen2 <- as.data.frame(gen2)
gen2[,1:5] <- list(NULL)
gen3 <- fread(paste0(path, "chr1_block_", i, "_perm_3_k_", j, ".controls.gen"), h = F, sep = " ")
gen3 <- as.data.frame(gen3)
gen3[,1:5] <- list(NULL)
gen4 <- fread(paste0(path, "chr1_block_", i, "_perm_4_k_", j, ".controls.gen"), h = F, sep = " ")
gen4 <- as.data.frame(gen4)
gen4[,1:5] <- list(NULL)
gen5 <- fread(paste0(path, "chr1_block_", i, "_perm_5_k_", j, ".controls.gen"), h = F, sep = " ")
gen5 <- as.data.frame(gen5)
gen5[,1:5] <- list(NULL)
gen6 <- fread(paste0(path, "chr1_block_", i, "_perm_6_k_", j, ".controls.gen"), h = F, sep = " ")
gen6 <- as.data.frame(gen6)
gen6[,1:5] <- list(NULL)
gen7 <- fread(paste0(path, "chr1_block_", i, "_perm_7_k_", j, ".controls.gen"), h = F, sep = " ")
gen7 <- as.data.frame(gen7)
gen7[,1:5] <- list(NULL)
gen8 <- fread(paste0(path, "chr1_block_", i, "_perm_8_k_", j, ".controls.gen"), h = F, sep = " ")
gen8 <- as.data.frame(gen8)
gen8[,1:5] <- list(NULL)
gen9 <- fread(paste0(path, "chr1_block_", i, "_perm_9_k_", j, ".controls.gen"), h = F, sep = " ")
gen9 <- as.data.frame(gen9)
gen9[,1:5] <- list(NULL)
gen10 <- fread(paste0(path, "chr1_block_", i, "_perm_10_k_", j, ".controls.gen"), h = F, sep = " ")
gen10 <- as.data.frame(gen10)
gen10[,1:5] <- list(NULL)

## get rid of meta columns on gen files
## hard coded for now but will switch to relative

#for(i in 2:10){
#  get(paste0("gen", i))[,1:5] <- NULL
#}


cbind(gen1,gen2) %>% cbind(.,gen3) %>% cbind(.,gen4) %>% cbind(.,gen5) %>% cbind(.,gen6) %>% cbind(.,gen7) %>% cbind(.,gen8) %>% cbind(.,gen9) %>% cbind(.,gen10) -> gen

colnames(gen) <- paste0("V",1:ncol(gen))
## Select SNPs
# Based on MAF 0.05 - 0.5, uniform

summary <- fread("/scratch/hpc2862/CAMH/perm_container/snp_summary2.out", h = T, sep = " ")
#summary %>% filter(all_maf > 0.05) %>% filter(all_maf < 0.5) %>% sample_n(50) %>% select(rsid, chromosome, position, all_maf) -> snps

#k = 1

snps <- NULL

# add in each 1000 sample sequentially
for(i in 1:max(summary$k)){

	summary %>% filter(k==i) %>% sample_n(1000) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps

}


colnames(snps) <- c("rsid", "chromosomes", "V3", "all_maf", "k")

comb <- merge(gen, snps, by = "V3")
comb <- as.data.frame(comb)

## eliminate overlap

comb$rsid <- NULL; comb$chromosomes <- NULL; comb$all_maf <- NULL; comb$k <- NULL
#comb$V1 <- NULL
#comb$V2 <- NULL
#comb$V4 <- NULL
#comb$V5 <- NULL

##translate snptest to r format
#we need row names here; take them from the smaple file but we just want the row names, not the phenotypes...  dont know how to do this yet/

combR <- SNPTEST_2_R(genfile = comb, local = TRUE)

## add row names to this from the sample file

samp <- vector()
n_people <- nrow(combR) ## make sure this is right...
ID_1 <- paste0("ID_1_", 1:n_people)
ID_2 <- paste0("ID_2_", 1:n_people)
samp <- cbind(ID_2, ID_1)
samp <- as.data.frame(samp)
samp$missing <- 0

row.names(combR) <- samp$ID_1


###calculate phenotypes HERE

pheno <- vector()
WAS <- vector()
Zscore <- vector()

## generate variance residuals

sd2 <- rand(n = ncol(combR), sum = 0.45)

results <- vector()
results <- as.data.frame(results)
b <- vector()
snps <- as.data.frame(snps)
## calulate beta

for(i in 1:ncol(combR)){
  b[i] <- rand0()*sqrt(sd2[i]/(2*snps[i,"all_maf"]*(1-snps[i,"all_maf"])))
}

## calculate WAS

for(i in 1:nrow(combR)){
  for(j in 1:ncol(combR)){
	combR[i,j] <- combR[i,j]*b[j] - b[j]*snps[j,"all_maf"]
  }
}

WAS <- rowSums(combR)
Z <- vector()

for(i in 1:length(WAS)){
  Z[i] <- WAS[i] + rnorm(1, 0, sd = sqrt(0.55))
}

samp$Z <- Z

var <- data.frame(0, 0, 0, "C")
samp$Z <- as.character(samp$Z)
colnames(var) <- colnames(samp)
samp <- rbind(var, samp)

write.table(samp, paste0(path,"phen_test.sample"), quote = FALSE, row.names=F, col.names = T, sep = "\t")
write.table(gen, paste0(path,"gen_test.gen"), quote = FALSE, row.names = F, col.names = F)
write.table(snps, paste0(path,"snptlist.txt"), quote = FALSE, row.names=F, col.names = T, sep = "\t")


#this is the end of the function
}
