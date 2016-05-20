#' Correct strata
#'
#' @param strata Strata
#' @param n_strata Number of strata
#' @param assoc Assoc file path
#'
#' @import magrittr
#' @import dplyr
#'
#' @return A data frame of FDR and sFDR by grouping level.
#' @export

correct <- function(strata = NULL, n_strata = NULL, assoc = NULL, group = FALSE, group_name = NULL){

  if(group && is.null(group_name)) stop("Please name your group")

    out <- data.frame(sfdr = double(), fdr = double(), k = integer())

  	assoc.df <- fread(assoc, h = T)
  	strata %<>%
  		merge(assoc.df, by.x = "rsid", by.y = "SNP")

  	message("Calculating sFDR and FDR")

  	strata %>%
  		filter(s == 1) %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr ->
  		s1

  	strata %>%
  		filter(s == 2) %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr ->
  		s2

  	strata %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr ->
  		agg

  	sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
  	fdr <- agg[3]

  	out[1,] <- c(sfdr, fdr, "all")

  if(group) {

    for(i in 1:max(strata[, group_name])){

      strata %>%
        filter_("s == 1", paste(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr ->
        s1

      strata %>%
        filter_("s == 2", paste(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr ->
        s2

      strata %>%
        filter_(paste(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr ->
        agg


      sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
      fdr <- agg[3]

      out[i+1,] <- c(sfdr, fdr, i)

    }
  }
  return(out)

}
