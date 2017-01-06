#' Create strata
#'
#' Currently only set up to handle two stata for arbitrary p in [0,1].
#'
#' @param snp_list Vector of true SNPs
#' @param summary Full summmary sheet
#' @param n_strata Number of strata. Currently only supports 2.
#' @param pnc Proportion non causal
#' @param pc Porportion Causal
#'
#' @importFrom magrittr %<>%
#' @importFrom dplyr filter mutate sample_n %>%
#'
#' @export

stratify <- function(snp_list = NULL, summary = NULL, pnc = NULL, pc = NULL, n_strata = NULL, mode = "default", gene_kb = 0){

	flog.debug("Entering into the stratify() function block")

	if(any(c(is.null(snp_list), is.null(summary), is.null(n_strata)))) stop("Missing a required input arguement")

	if(mode == "genes"){

		flog.debug("Gene mode selected")

		h0_summary <- summary %>%
			filter(!(rsid %in% unlist(snp_list))) %>%
			mutate(h1 = F)
		h1_summary <- summary %>%
			filter(rsid %in% unlist(snp_list)) %>%
			mutate(h1 = T)

		flog.trace(paste0("There are ", nrow(h1_summary), " causal SNPs in the current analysis and ", nrow(h0_summary), " non causal SNPs."))

		# Run through each SNP in the h1 summary and give it a gene
		# identifyier to be used in the gene column.

		# Randomly put floor(pc*nrow(h1_summary)) causal into the h1
		# 	and the rest into the second strata.
		h1_s1 <- h1_summary %>%
			sample_n(floor(nrow(h1_summary)*pc))
		h1_s2 <- h1_summary %>%
			filter(!(rsid %in% h1_s1$rsid))

		s1 <- h0_summary %>%
			filter(position > h1_s1$position[1] - gene_kb*1000 & position < h1_s1$position[1] + gene_kb*1000) %>% nrow

		for(i in 2:nrow(h1_s1)){
			s1 <- h0_summary %>%
			filter(position > h1_s1$position[1] - gene_kb*1000 & position < h1_s1$position[1] + gene_kb*1000) %>%
			rbind(s1)
		}

		s2 <- h0_summary[!(h0_summary$rsid %in% s1$rsid),]

		s1 %<>% rbind(h1_s1) %>%
			mutate(s = 1)
		s2 %<>% rbind(h1_s2) %>%
			mutate(s = 2)

		strata <- rbind(s1, s2)



	} else {

		h0_summary <- summary %>%
			filter(!(rsid %in% unlist(snp_list))) %>%
			mutate(h1 = F)
		h1_summary <- summary %>%
			filter(rsid %in% unlist(snp_list)) %>%
			mutate(h1 = T)

		h1_s1 <- h1_summary %>%
			sample_n(floor(nrow(h1_summary)*pc))
		h1_s2 <- h1_summary %>%
			filter(!(rsid %in% h1_s1$rsid))

		s1 <- h0_summary %>%
			sample_n(floor(nrow(h0_summary)*pnc) - length(snp_list))
		s2 <- h0_summary %>%
			filter(!(rsid %in% s1$rsid))

		s1 %<>% rbind(h1_s1) %>%
			mutate(s = 1)
		s2 %<>% rbind(h1_s2) %>%
			mutate(s = 2)

		strata <- rbind(s1, s2)
	}

	return(strata)

}
