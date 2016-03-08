#' Convenience function to select SNPs and groupings


snp.select <- function(summary = character()){
	#this one is for the clusters of snps
	
	.summary <- fread(summary, h = T, sep = " ")
	
	snps <- NULL
	
	#add in each 1000 sample sequentially
        
	for(i in 1:max(summary$k)){
                summary %>% filter(k==i) %>% sample_n(1000) %>% select(rsid, chromosome, position, all_maf, k) %>% rbind(snps, .) -> snps
        }

	return(snps)
	
}
