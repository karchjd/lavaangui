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
#' Multiple-group models are imported with their grouping variable selected.
#' After estimation, estimates for each group can be selected above the diagram.
#'
#' @export
lavaangui <- function(fit = NULL) {
  start_app(fit = fit, full = TRUE, where = "browser", layout = NULL, export_filepath = NULL, scale = NULL)
}
