#' Automated standard evaluation of mutate with in operator.
#'
#' @param col1 col1 in col2
#' @param col2 col1 in col2
#' @param new_col_name Name of new column. Can be passed as variable.
#' @param df Data frame to append to.
#'
#' @importFrom dplyr mutate_ %>%
#' @importFrom lazyeval interp
#' @importFrom magrittr %<>%
#'
#' @return Data frame with number of columns originally plus one.
#' @export

SE_mutate <- function(df, col1, col2, new_col_name) {
  mutate_call = lazyeval::interp(~ a %in% b, a = as.name(col1), b = as.name(col2))
  df %<>% mutate_(.dots = setNames(list(mutate_call), new_col_name))
  return(df)
}
