#' Initialize and Run lavaan GUI Shiny Application
#'
#' The `start_gui` function launches a Shiny application for lavaan GUI.
#' It sets up the UI from an HTML template and starts the application server.
#'
#' @usage start_gui()
#'
#' @details
#' This function performs the following tasks:
#' 1. Locates the "index.html" file within the "www" directory of the "lavaangui" package.
#' 2. Adds a resource path for the "assets" directory.
#' 3. Initializes and runs the Shiny application using the `lavaan_gui_server` server function.
#'
#' @export
#' @import shiny
#' @import lavaan
start_gui <- function(){
  ui_loc <- system.file("www/index.html", package = "lavaangui")
  addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
  app <- shinyApp(server = lavaan_gui_server,
           ui = htmlTemplate(ui_loc))
  runApp(app, launch.browser = TRUE)
}

