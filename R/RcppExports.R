# This file was generated by Rcpp::compileAttributes
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' @export
gen_cor <- function(causal, all) {
    .Call('coRge_gen_cor', PACKAGE = 'coRge', causal, all)
}

#' @export
returnLD <- function(cIndex, gen, bpVec) {
    .Call('coRge_returnLD', PACKAGE = 'coRge', cIndex, gen, bpVec)
}

#' @export
assoc <- function(gen, y) {
    .Call('coRge_assoc', PACKAGE = 'coRge', gen, y)
}

#' @export
fun <- function(input_field, id) {
    .Call('coRge_fun', PACKAGE = 'coRge', input_field, id)
}

#' @export
th <- function(strata_rsid, rsid, r2) {
    .Call('coRge_th', PACKAGE = 'coRge', strata_rsid, rsid, r2)
}

