.onAttach <- function(libname, pkgname) {
  version <- read.dcf(
    file = system.file("DESCRIPTION", package = pkgname),
    fields = "Version"
  )
  packageStartupMessage(
    "This is ", paste(pkgname, version), "\n",
    pkgname, " is BETA software! Please report any bugs at https://github.com/karchjd/lavaangui/issues"
  )
}