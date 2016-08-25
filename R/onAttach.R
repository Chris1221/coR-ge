.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = packageVersion("coRge")

    packageStartupMessage(paste0("coRge v", v, ".  For guides and more information please see https://github.com/chris1221/cor-ge."))


  }
}
