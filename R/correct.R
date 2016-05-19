#' Correct strata 
#'
#' @param strata Strata
#' @param n_strata Number of strata
#' @param assoc Assoc file path
#' 
#' @export

correct <- function(strata = NULL, n_strata = NULL, assoc = NULL){

	assoc.df <- fread(assoc, h = T)
	strata %<>% 
		merge(assoc.df, by.x = "rsid", by.y = "SNP")
	
	message("Calculating sFDR and FDR")

# ------------------------------------------------------------------
	strata %>% 
		filter(s == 1) %>% 
		mutate(p.adj = p.adj(P, method = "BH")) %>%
		fdr ->
		s1
	
	strata %>% 
		filter(s == 2) %>% 
		mutate(p.adj = p.adj(P, method = "BH")) %>%
		fdr ->
		s2

	strata %>% 
		mutate(p.adj = p.adj(P, method = "BH")) %>%
		fdr ->
		agg
		
			
	sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
	fdr <- agg[3]
	
	return(c(sfdr, fdr))
}
