## only for shinyapps.io
library(shiny)
pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE, compile = FALSE)
ui_loc <- system.file("www/index.html", package = "lavaangui")
addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
.GlobalEnv$.full12849812948124912489128412948 <- TRUE
app <- shinyApp(server = lavaangui:::lavaan_gui_server,
                ui = htmlTemplate(ui_loc))
