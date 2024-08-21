# Detach all loaded packages and clean your environment
if (!requireNamespace("golem", quietly = TRUE)) {
  install.packages("golem")
}
if (!requireNamespace("pkgload", quietly = TRUE)) {
  install.packages("pkgload")
}

golem::detach_all_attached()
pkgload::load_all()
options(shiny.port = 3245)
lavaangui()