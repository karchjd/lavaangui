#' Initialize and Run lavaan GUI Shiny Application
#'
#' The `start_gui` function launches a Shiny application for lavaan GUI.
#' It sets up the UI from an HTML template and starts the application server.
#'
#' @param fit An optional argument to pass the fit object to the Shiny application.
#' This is `NULL` by default.
#'
#' @usage start_gui(fit = NULL)
#'
#' @details
#' This function performs the following tasks:
#' 1. Locates the "index.html" file within the "www" directory of the "lavaangui" package.
#' 2. Adds a resource path for the "assets" directory.
#' 3. Initializes and runs the Shiny application using the `lavaan_gui_server` server function.
#' 4. Optionally uses the `fit` argument to pass a fit object to the Shiny application.
#'
#' @export
start_gui <- function(fit = NULL) {
  start_app(fit = fit, full = TRUE, where = "browser")
}
