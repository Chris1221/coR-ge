#' Convenience function for recompilling Rcpp and reloading package
#'
#' NA
#'
#' @importFrom Rcpp compileAttributes
#' @importFrom devtools document
#' @export

rebuild <- function(){
	detach("package:coRge", unload = TRUE)

	compileAttributes()
	document()

	install.packages(".", type = "source", repo = NULL)

	library(coRge)
}
