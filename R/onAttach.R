.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = packageVersion("coRge")

    packageStartupMessage(paste0("coRge v", v, ".\nGuides, issues, and FAQ: https://github.com/Chris1221/coRge \nPrepublication:\t\t arXiv: XXXXX \nCitation:\t\t citation(\"coRge\")"))


  }
}
