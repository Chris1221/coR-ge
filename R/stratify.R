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

stratify <- function(snp_list = NULL, summary = NULL, p = NULL, n_strata = NULL){

	if(any(c(is.null(snp_list), is.null(summary), is.null(p), is.null(n_strata)))) stop("Missing a required input arguement")

	# Only look at the ones not selected to be either real or fake
	summary %>% filter(!(rsid %in% unlist(snp_list))) %>% mutate(h1 = F) ->
		h0_summary
	summary %>% filter(rsid %in% unlist(snp_list)) %>% mutate(h1 = T) ->
		h1_summary

	s1 <- h0_summary %>% sample_n(floor(nrow(h0_summary)*p) - length(snp_list))
	s1 %<>% rbind(h1_summary) %>% mutate(s = 1)

	s2 <- summary %>% filter(!(rsid %in% s1$rsid)) %>% mutate(s = 2, h1 = F)

	strata <- rbind(s1, s2)
	return(strata)

}
