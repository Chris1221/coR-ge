#' Calculates FDR given a data frame
#' 
#' @param df Data frame of input
#'
#' @return A vector of results
#' 
#' @export

fdr <- function(df = NULL){

	if(is.null(df)) stop("Please input a data frame")

	fp <- sum(df$p.adj[df$p.adj < 0.05 && !(df$h1])
	tp <- sum(df$p.adj[df$p.adj < 0.05 && df$h1])
	fdr <- fp / (tp + fp)

	return(c(fp, tp, fdr))
}
