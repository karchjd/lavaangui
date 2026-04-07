#' Create Interactive Path Diagrams for Lavaan Models
#'
#' The `plot_lavaan` function creates path diagrams for lavaan model.
#' The created paths diagrams  are interactive.
#' That is, their appearance can be customized easily, for example, by dragging
#' around nodes representing variable with the mouse.
#'
#' @param fit A lavaan model, as returned by the `lavaan`, `sem`, or `cfa` functions from the `lavaan` package.
#'
#' @param layout A character string specifying the name of the layout to use (default: `"default"`).
#'   If `NULL`, no layout is saved or loaded.
#'
#' @param where A character string to specify where the path diagram should be shown.
#' The default value "gadget" shows it directly in Rstudio. For "browser", it's shown in your default browser.
#' For non-RStudio users, the parameter has no effect, and the path diagram is always shown in the browser.
#' @return nothing
#'
#' @seealso [remove_layouts()] to delete saved layouts.
#'
#' @examplesIf interactive()
#' library(lavaan)
#' model <- "
#'   visual  =~ x1 + loadingx2*x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' "
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' plot_lavaan(fit)
#'
#' @export
plot_lavaan <- function(fit, layout = "default", where = "gadget") {
  if (!is.null(layout)) {
    where <- "browser"
    message("Layout provided: 'where' argument automatically set to 'browser'.")
  }
  start_app(fit = fit, full = FALSE, where = where, layout = layout, export_filepath = NULL, scale = NULL)
}
