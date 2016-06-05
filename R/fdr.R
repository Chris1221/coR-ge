#' Calculates FDR given a data frame
#'
#' @param df Data frame of input
#'
#' @importFrom magrittr %<>%
#' @importFrom dplyr %>%
#'
#' @return A vector of results
#'
#' @export

fdr <- function(df = NULL, mode = "default", level = NULL){

	if(is.null(df)) stop("Please input a data frame")

  df %<>% filter(!is.na(p.adj))

  	if(mode == "default"){

		fp <- sum(!is.na(df$p.adj[df$p.adj < 0.05 & !(df$h1)]))
		tp <- sum(!is.na(df$p.adj[df$p.adj < 0.05 & df$h1]))
		fdr <- fp / (tp + fp)

	} else if(mode == "ld"){

		fp <- sum(!is.na(df$p.adj[(df$p.adj < 0.05 & !(df$h1)) | (df$p.adj < 0.05 & df$ld > level)]))
		tp <- sum(!is.na(df$p.adj[(df$p.adj < 0.05 & df$h1) | (df$p.adj < 0.05 & df$ld > level)]))
		fdr <- fp / (tp + fp)

	}

 	return(c(fp, tp, fdr))
}
