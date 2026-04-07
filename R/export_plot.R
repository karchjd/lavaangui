#' @export
export_plot <- function(fit, filename, layout = "default", scale = 1){
  start_app(fit, FALSE, "browser", layout, filename, scale)
}

  