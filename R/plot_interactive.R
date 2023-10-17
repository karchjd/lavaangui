#' @export
plot_interactive <- function(fit, where = "gadget") {
  start_app(fit = fit, full = FALSE, where = where)
}
