#' Create strata
#'
#' Currently only set up to handle two stata for arbitrary p in [0,1].
#'
#' @param snp_list Vector of true SNPs
#' @param summary Full summmary sheet
#' @param p Proportion in strata 1
#' @param n_strata Number of strata. Currently only supports 2.
#'
#' @importFrom magrittr %<>%
#' @importFrom dplyr filter mutate sample_n %>%
#'
#' @export

stratify <- function(snp_list = NULL, summary = NULL, pnc = NULL, pc = NULL, n_strata = NULL){

	if(any(c(is.null(snp_list), is.null(summary), is.null(p), is.null(n_strata)))) stop("Missing a required input arguement")

	h0_summary <- summary %>% filter(!(rsid %in% unlist(snp_list))) %>% mutate(h1 = F)
	h1_summary <- summary %>% filter(rsid %in% unlist(snp_list)) %>% mutate(h1 = T)
	
	h1_s1 <- h1_summary %>% sample_n(floor(nrow(h1_summary)*pc))
	h1_s2 <- h1_summary %>% filter(!(rsid %in% h1_s1$rsid)) 

	s1 <- h0_summary %>% sample_n(floor(nrow(h0_summary)*pnc) - length(snp_list))
	s2 <- h0_summary %>% filter(!(rsid %in% s1$rsid))

	s1 %<>% rbind(h1_s1) %>% mutate(s = 1)
	s2 %<>% rbind(h1_s2) %>% mutate(s = 2)

	strata <- rbind(s1, s2)
	return(strata)

}
