install.packages("data.table", repos = "http://cran.utstat.utoronto.ca/");library(data.table)
install.packages("dplyr", repos = "http://cran.utstat.utoronto.ca/");library(dplyr)

args<-commandArgs(TRUE)
i <- args[1]
j <- args[2]
path <- paste0("/scratch/hpc2862/CAMH/perm_container/container_",i,"_",j,"/")
setwd(path)

q <- read.table("plink.qassoc", h = T)
snps <- read.table("snptlist.txt", h = T, sep = "\t")
summary <- read.table("/scratch/hpc2862/CAMH/perm_container/snp_summary.out", h = T)
colnames(snps) <- c("SNP", "CHR", "BP", "MAF")

snps_back <- snps
snps <- snps$SNP

q %>% mutate(real = SNP %in% snps[]) -> q2

n_snps <- c(0,10,50,100,500,5000,10000)

for(n in n_snps){

  summary %>% filter(all_maf > 0.05) %>% filter(all_maf < 0.5) %>% sample_n(n) %>% select(rsid, chromosome, position, all_maf) -> fake_snps

  colnames(fake_snps) <- c("SNP", "CHR", "BP", "MAF")

  q2 %>% mutate(fake = SNP %in% fake_snps$SNP) -> q3

  stratum_1 <- rbind(q3[q3$real == TRUE,], q3[q3$fake == TRUE,])
  minus_stratum <- q3[q3$real == FALSE & q3$fake == FALSE,]
  agg <- q3

  #adjust

  stratum_1 %>% mutate(p.adj = p.adjust(P, method = "BH")) -> stratum_1
  minus_stratum %>% mutate(p.adj = p.adjust(P, method = "BH")) -> minus_stratum

  stratum_1 %>% mutate(p.adj = p.adjust(P, method = "bonferroni")) -> b_stratum_1
  minus_stratum %>% mutate(p.adj = p.adjust(P, method = "bonferroni")) -> b_minus_stratum


  agg %>% mutate(p.adj = p.adjust(P, method = "BH")) -> agg

  agg %>% mutate(p.adj = p.adjust(P, method = "bonferroni")) -> b_agg

  A_TP <- sum(agg$real == TRUE & agg$p.adj < 0.05)
  A_FP <- sum(agg$real == FALSE & agg$p.adj < 0.05)
  A_TN <- sum(agg$real == FALSE & !(agg$p.adj < 0.05))
  A_FN <- sum(agg$real == TRUE & !(agg$p.adj < 0.05))

  Ab_TP <- sum(b_agg$real == TRUE & b_agg$p.adj < 0.05)
  Ab_FP <- sum(b_agg$real == FALSE & b_agg$p.adj < 0.05)
  Ab_TN <- sum(b_agg$real == FALSE & !(b_agg$p.adj < 0.05))
  Ab_FN <- sum(b_agg$real == TRUE & !(b_agg$p.adj < 0.05))

  S_TP <- sum(stratum_1$real == TRUE & stratum_1$p.adj < 0.05) + sum(minus_stratum$real == TRUE & minus_stratum$p.adj < 0.05)
  S_FP <- sum(stratum_1$real == FALSE & stratum_1$p.adj < 0.05) + sum(minus_stratum$real == FALSE & minus_stratum$p.adj < 0.05)
  S_TN <- sum(stratum_1$real == FALSE & !(stratum_1$p.adj < 0.05)) + sum(minus_stratum$real == FALSE & !(minus_stratum$p.adj < 0.05))
  S_FN <- sum(stratum_1$real == TRUE & !(stratum_1$p.adj < 0.05)) + sum(minus_stratum$real == TRUE & !(minus_stratum$p.adj < 0.05))

  Sb_TP <- sum(b_stratum_1$real == TRUE & b_stratum_1$p.adj < 0.05) + sum(b_minus_stratum$real == TRUE & b_minus_stratum$p.adj < 0.05)
  Sb_FP <- sum(b_stratum_1$real == FALSE & b_stratum_1$p.adj < 0.05) + sum(b_minus_stratum$real == FALSE & b_minus_stratum$p.adj < 0.05)
  Sb_TN <- sum(b_stratum_1$real == FALSE & !(b_stratum_1$p.adj < 0.05)) + sum(b_minus_stratum$real == FALSE & !(b_minus_stratum$p.adj < 0.05))
  Sb_FN <- sum(b_stratum_1$real == TRUE & !(b_stratum_1$p.adj < 0.05)) + sum(b_minus_stratum$real == TRUE & !(b_minus_stratum$p.adj < 0.05))

  write <- cbind(n, A_TP,A_FP,A_TN,A_FN,Ab_TP,Ab_FP,Ab_TN,Ab_FN,S_TP,S_FP,S_TN,S_FN,Sb_TP,Sb_FP,Sb_TN,Sb_FN)
  write.table(write, file = "/scratch/hpc2862/CAMH/perm_container/out_DONTDELETE_files/results.txt", append = T, quote = F, sep = " ", row.name = F, col.name = F)
}






##Old

#q %>% mutate(p.adj = p.adjust(P, method = "BH")) -> q2

#snps_backup <- snps

#colnames(snps) <- c("SNP", "CHR", "BP", "MAF")
#snps$CHR <- NULL
#snps$MAF <- NULL
#real <- merge(q2, snps, by = c("BP", "SNP"), all.x = F)

#500 fake snps

#summary %>% filter(all_maf > 0.05) %>% filter(all_maf < 0.5) %>% sample_n(100) %>% select(rsid, chromosome, position, all_maf) -> snps2

#colnames(snps2) <- c("SNP", "CHR", "BP", "MAF")
#snps2$CHR <- NULL
#snps2$MAF <- NULL
#fake <- merge(q2, snps2, by = c("BP", "SNP"), all.x = F)

#strat <- rbind(real, fake)

#strat %>% mutate(p.adj = p.adjust(P, method = "BH")) -> strat

#agg <- q2
