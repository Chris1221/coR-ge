args<-commandArgs(TRUE)

association_file_name <- args[1]
snp_summary_name <- args[2]
causal_snp_list <- args[3]
n_fake_in_strata <- args[4]
output <- args[5]

q <- read.table(association_file_name, h = T)
q %>% mutate(p.adj = p.adjust(P, method = "BH")) -> q2

snps <- read.table(causal_snp_list, h = T)

colnames(snps) <- c("SNP", "CHR", "BP", "MAF")
snps$CHR <- NULL
snps$MAF <- NULL
real <- merge(q2, snps, by = c("BP", "SNP"), all.x = F)

##500 fake snps

summary <- read.table(snp_summary_name, h = T)

summary %>% filter(MAF > 0.05) %>% filter(MAF < 0.5) %>% sample_n(n_fake_in_strata) %>% select(SNP, CHR, MAF) -> snps2

colnames(snps2) <- c("SNP", "CHR", "MAF")
snps2$CHR <- NULL
snps2$MAF <- NULL
fake <- merge(q2, snps2, by = c("SNP"), all.x = F)

strat <- rbind(real, fake)

strat %>% mutate(p.adj = p.adjust(P, method = "BH")) -> strat

agg <- q2

real_or_not <- function(x){
    if(x %in% snps$SNP){
      x <- 1
    } else {
      x <- 0
    }
}

is_strat <- function(x){
  if(x %in% strat$SNP){
    x <- 1
  } else {
    x <- 0
  }


}
strat$real <- sapply(strat$SNP, FUN = real_or_not)
agg$real <- sapply(agg$SNP, FUN = real_or_not)
agg$is_strat <- sapply(agg$SNP, FUN = is_strat)

agg %>% filter(is_strat == 0) -> agg2

sTP <- sum(strat$p.adj < 0.05 & strat$real == 1) + sum(agg2$p.adj < 0.05 & agg2$real == 1)
sFP <- sum(strat$p.adj < 0.05 & strat$real == 0) + sum(agg2$p.adj < 0.05 & agg2$real == 0)
aTP <- sum(agg$p.adj < 0.05 & agg$real == 1)
aFP <- sum(agg$p.adj < 0.05 & agg$real == 0)

sink(output, append = T, split = F)
cat(sTP, sFP, aTP, aFP, "\n")
sink()
