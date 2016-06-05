#' Correct strata by group
#'
#' Note that group name must be a factor
#'
#' @param strata Strata
#' @param n_strata Number of strata
#' @param assoc Assoc file path
#'
#' @importFrom data.table fread fwrite
#' @importFrom magrittr %<>%
#' @importFrom dplyr mutate filter filter_ %>%
#'
#' @return A data frame of FDR and sFDR by grouping level.
#' @export

correct <- function(strata = NULL, n_strata = NULL, assoc = NULL, group = FALSE, group_name = NULL, mode = "default"){

  if(mode == "default"){

  strata <- as.data.frame(strata)

  if(group && is.null(group_name)) stop("Please name your group")

    out <- data.frame(sfdr = double(), fdr = double(), k = integer())

  	assoc.df <- fread(assoc, h = T)
  	strata %<>%
  		merge(assoc.df, by.x = "rsid", by.y = "SNP")

  	message("Calculating sFDR and FDR")

  	strata %>%
  		filter(s == 1) %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr(.) ->
  		s1

  	strata %>%
  		filter(s == 2) %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr(.) ->
  		s2

  	strata %>%
  		mutate(p.adj = p.adjust(P, method = "BH")) %>%
  		fdr(.) ->
  		agg

  	sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
  	fdr <- agg[3]

  	out[1,] <- c(sfdr, fdr, "all")

  if(group) {

  j <- 1
    for(i in levels(strata[, get(group_name)])){

      strata %>%
        filter(s == 1) %>%
        filter_(paste0(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr(.) ->
        s1

      strata %>%
        filter(s == 2) %>%
        filter_(paste0(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr(.) ->
        s2

      strata %>%
        filter_(paste0(group_name, "==", i)) %>%
        mutate(p.adj = p.adjust(P, method = "BH")) %>%
        fdr(.) ->
        agg


      sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
      fdr <- agg[3]

      out[nrow(out)+1,] <- c(sfdr, fdr, i)
      j <- j+1

    }
  }
  } else if(mode == "ld"){
      strata <- as.data.frame(strata)

      if(group && is.null(group_name)) stop("Please name your group")

      out <- data.frame(sfdr = double(), fdr = double(), k = integer(), th = double())

      assoc.df <- fread(assoc, h = T)
      strata %<>%
        merge(assoc.df, by.x = "rsid", by.y = "SNP")

      for(th in levels(as.factor(strata$ld))){
        k <- 1

        message("Calculating sFDR and FDR")

        strata %>%
          filter(s == 1) %>%
          mutate(p.adj = p.adjust(P, method = "BH")) %>%
          fdr(., mode = "ld", level = th) ->
          s1

        strata %>%
          filter(s == 2) %>%
          mutate(p.adj = p.adjust(P, method = "BH")) %>%
          fdr(.,  mode = "ld", level = th) ->
          s2

        strata %>%
          mutate(p.adj = p.adjust(P, method = "BH")) %>%
          fdr(., mode = "ld", level = th) ->
          agg

        sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
        fdr <- agg[3]

        out[nrow(out)+1,] <- c(sfdr, fdr, "all", th)


        if(group) {

        message("Grouping")
          for(i in levels(as.factor(strata[, group_name]))){

            strata %>%
              filter(s == 1) %>%
              filter_(paste0(group_name, "==", i)) %>%
              mutate(p.adj = p.adjust(P, method = "BH")) %>%
              fdr(., mode = "ld", level = th) ->
              s1

            strata %>%
              filter(s == 2) %>%
              filter_(paste0(group_name, "==", i)) %>%
              mutate(p.adj = p.adjust(P, method = "BH")) %>%
              fdr(., mode = "ld", level = th) ->
              s2

            strata %>%
              filter_(paste0(group_name, "==", i)) %>%
              mutate(p.adj = p.adjust(P, method = "BH")) %>%
              fdr(., mode = "ld", level = th) ->
              agg


            sfdr <- (s1[1]+s2[1]) / (s1[1]+s2[1] + s1[2]+s2[2])
            fdr <- agg[3]

            out[nrow(out)+1,] <- c(sfdr, fdr, i, th)

          }

        }
      }

  }


  	  return(out)

}
