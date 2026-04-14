#' Export a Path Diagram of a Lavaan Model to a File
#'
#' Renders the path diagram for a lavaan model and saves it directly to a file
#' without requiring manual interaction.
#'
#' @param fit A lavaan model, as returned by the `lavaan`, `sem`, or `cfa` functions from the `lavaan` package.
#' @param filename A single character string giving the output file path.
#'   The file extension determines the format: `png`, `jpg`/`jpeg`, `svg`, or `pdf`.
#' @param layout A character string specifying the name of a previously saved layout to use
#'   (default: `"default"`).
#' @param scale A positive number controlling the output resolution relative to screen size
#'   (default: `1`). Higher values produce sharper raster images (PNG/JPG) and larger SVG/PDF
#'   output.
#'
#' @return nothing
#'
#' @seealso [plot_lavaan()] to create and interactively edit path diagrams,
#'   [remove_layouts()] to delete saved layouts.
#'
#' @examplesIf interactive()
#' library(lavaan)
#' model <- "
#'   visual  =~ x1 + loadingx2*x2 + x3
#'   textual =~ x4 + x5 + x6
#'   speed   =~ x7 + x8 + x9
#' "
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' # First run plot_lavaan to interactively arrange the diagram and save a layout,
#' # then export it non-interactively:
#' plot_lavaan(fit)
#' export_plot(fit, "diagram.png")
#' export_plot(fit, "diagram.pdf", scale = 2)
#'
#' @export
export_plot <- function(fit, filename, layout = "default", scale = 1) {
  if (!inherits(fit, "lavaan")) {
    stop("'fit' must be a lavaan model object.")
  }
  if (!is.character(filename) || length(filename) != 1 || nchar(filename) == 0) {
    stop("'filename' must be a single non-empty character string.")
  }
  ext <- tolower(tools::file_ext(filename))
  if (!ext %in% c("png", "jpg", "jpeg", "svg", "pdf")) {
    stop("'filename' must have a supported extension: png, jpg, jpeg, svg, or pdf.")
  }
  if (!is.null(layout) && (!is.character(layout) || length(layout) != 1)) {
    stop("'layout' must be NULL or a single character string.")
  }
  if (!is.numeric(scale) || length(scale) != 1 || scale <= 0) {
    stop("'scale' must be a single positive number.")
  }
  start_app(fit, FALSE, "browser", layout, filename, scale)
}
