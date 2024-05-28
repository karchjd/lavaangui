#' Create Interactive Path Diagrams for Lavaan Models
#'
#' The `plot_interactive` function creates path diagrams for lavaan model.
#' Crucially, the created path diagram  is interactive.
#' That is, its appearance can be changed easily, for example, by dragging
#' around nodes with the mouse.
#'
#' @param fit A lavaan model, as returned by the functions `lavaan`, `sem`, or `cfa` from the `lavaan` package.
#'
#' @param where A character string to specify where the path diagram should be shown.
#' The default value "gadget" shows it directly in Rstudio. For "browser", it's shown in your default browser.
#'
#' @examples
#' \dontrun{
#' library(lavaan)
#' model <- "
#'   visual  =~ x1 + loadingx2*x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' "
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' plot_interactive(fit)
#' }
#'
#' @export
plot_interactive <- function(fit, where = "gadget", filename = NULL) {
  start_app(fit = fit, full = FALSE, where = where, filename)
}
