#' @export
#' @import shiny
start_gui <- function(){
  ui_loc <- system.file("www/index.html", package = "lavaangui")
  addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
  app <- shinyApp(server = lavaan_gui_server,
           ui = htmlTemplate(ui_loc))
  runApp(app, launch.browser = TRUE)
}

