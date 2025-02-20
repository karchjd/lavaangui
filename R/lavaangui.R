#' Start lavaangui Shiny Application
#'
#' The `lavaangui` function launches the lavaangui Shiny application.
#'
#' @param fit A lavaan model, as returned by the `lavaan`, `sem`, or `cfa` functions from the `lavaan` package.
#' If provided, lavaangui imports the model and data. If left empty, lavaangui starts without importing.
#'
#' @return nothing
#'
#' @examplesIf interactive()
#' # Without importing lavaan model
#' lavaangui()
#'
#' # Importing a lavaan model
#' library(lavaan)
#' model <- "
#'   visual  =~ x1 + loadingx2*x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' "
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' lavaangui(fit)
#'

#' @details
#' Currently, multiple-group models are not supported. However, you can create an
#' interactive plot of those models using \code{\link{plot_lavaan}}
#'
#' @export
lavaangui <- function(fit = NULL) {
  start_app(fit = fit, full = TRUE, where = "browser")
}
