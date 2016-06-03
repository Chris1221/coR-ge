#' Automated standard evaluation of mutate with %in% operator.
#'
#' @param col1 col1 %in% col2
#' @param col2 col1 %in% col2
#' @param new_col_name Name of new column. Can be passed as variable.
#' @param df Data frame to append to.
#'
#' @import dplyr
#' @import lazyeval
#'
#' @return Data frame with ncol(df)+1 columns.
#' @export

SE_mutate <- function(col1, col2, new_col_name, df) {
  mutate_call = lazyeval::interp(~ a + b, a = as.name(col1), b = as.name(col2))
  df %<>% mutate_(.dots = setNames(list(mutate_call), new_col_name))
  return(df)
}
