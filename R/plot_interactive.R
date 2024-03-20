#' Launch Interactive Plot for Lavaan Models
#'
#' The `plot_interactive` function launches an interactive plotting tool
#' for visualizing lavaan models. The function can operate as either a
#' standalone gadget or within a browser, based on the 'where' argument.
#'
#' @param fit The fit object that needs to be visualized interactively.
#'
#' @param where A character string to specify where the interactive tool should be launched.
#' Takes one of two values: "gadget" or "browser". Default is "gadget".
#'
#' @usage plot_interactive(fit, where = "gadget")
#'
#' @details
#' This function leverages the `start_app` internal function to initialize the interactive
#' plot. It passes the `fit` object for visualization and sets the display location based on the
#' `where` parameter.
#'
#' @export
plot_interactive <- function(fit, where = "gadget") {
  start_app(fit = fit, full = FALSE, where = where)
}
