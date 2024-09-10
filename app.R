## only for shinyapps.io
library(shiny)
pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE, compile = FALSE)
app <- lavaangui:::start_app(full = TRUE, where = "shinyapps.io")