#' Start lavaangui Shiny Application
#'
#' The `start_gui` function launches the lavaangui Shiny application.
#' 
#' @param fit A lavaan model, as returned by the functions `lavaan`, `sem`, or `cfa` from the `lavaan` package. 
#' If passed, lavaangui imports the model and data. 
#' 
#' @examples 
#' \dontrun{
#' # Without importing lavaan model
#' start_gui()
#'
#' # Importing a lavaan model
#' library(lavaan)
#' model <- ' 
#'   visual  =~ x1 + loadingx2*x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' '
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' start_gui(fit)
#' }

#' @details
#' Currently, multiple-group models are not supported. However, you can create an
#' interactive plot of those models using \code{\link{plot_interactive}}
#' 
#' @export
start_gui <- function(fit = NULL) {
  start_app(fit = fit, full = TRUE, where = "browser")
}
