#' Remove Saved Layouts for a Lavaan Model
#'
#' Removes layout files previously saved by [plot_lavaan()] for a given lavaan model.
#'
#' @param fit A lavaan model, as returned by the `lavaan`, `sem`, or `cfa` functions from the `lavaan` package.
#' @param layout A character string specifying which layout to remove.
#'   If `NULL` (the default), all saved layouts for the model are removed.
#'   If a character string, only the layout with that name is removed.
#'
#' @return Invisibly returns the paths of removed files.
#'
#' @seealso [plot_lavaan()] which creates and saves layouts.
#'
#' @examplesIf interactive()
#' library(lavaan)
#' model <- "
#'   visual  =~ x1 + x2 + x3
#'   textual =~ x4 + x5 + x6
#' "
#' fit <- cfa(model, data = HolzingerSwineford1939)
#' remove_layouts(fit)
#'
#' @export
remove_layouts <- function(fit, layout = NULL) {
    if (!inherits(fit, "lavaan")) {
        stop("'fit' must be a lavaan model object.")
    }
    if (!is.null(layout) && (!is.character(layout) || length(layout) != 1)) {
        stop("'layout' must be NULL or a single character string.")
    }

    layout_hash <- digest::digest(parameterEstimates(fit))
    layouts_dir <- file.path("layouts")

    if (!dir.exists(layouts_dir)) {
        message("No layouts directory found.")
        return(invisible(character(0)))
    }

    if (is.null(layout)) {
        pattern <- sprintf("^layout_%s_.+\\.json$", layout_hash)
        files <- list.files(layouts_dir, pattern = pattern, full.names = TRUE)
    } else {
        safe_name <- gsub("[^a-zA-Z0-9_-]", "", layout)
        filename <- sprintf("layout_%s_%s.json", layout_hash, safe_name)
        filepath <- file.path(layouts_dir, filename)
        if (file.exists(filepath)) {
            files <- filepath
        } else {
            files <- character(0)
        }
    }

    if (length(files) == 0) {
        message("No matching layout files found.")
        return(invisible(character(0)))
    }

    message("The following layout file(s) will be removed:")
    for (f in files) {
        message("  ", f)
    }
    answer <- readline("Proceed? (y/n): ")
    if (!tolower(answer) %in% c("y", "yes")) {
        message("Aborted.")
        return(invisible(character(0)))
    }

    file.remove(files)
    message(sprintf("Removed %d layout file(s).", length(files)))
    invisible(files)
}
