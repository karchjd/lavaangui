library(shiny)

pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE, compile = FALSE)
print("starting server")
port <- Sys.getenv('PORT')
print(port)
lavaangui:::start_app(full = TRUE, where = "webserver")
