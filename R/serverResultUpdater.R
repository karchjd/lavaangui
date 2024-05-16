serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderPrint({
      req(to_render())
      out <- to_render()
      if (is.character(out)) {
        cat(out)
      } else {
        if (!is.null(out$warning)) {
          cat("Beware of the following lavaan warning(s) (lavaan call):\n")
          for (i in seq_along(out$warning)) {
            if (!is.null(out$warning[i]$message)) {
              cat(paste0(out$warning[i]$message, "\n"))
            }
          }
        }

        summary_warning <- NULL
        if ("lavaan" %in% class(out$fit)) {
          withCallingHandlers(
            {
              sum_model <- summary(out$fit, fit.measures = TRUE)
              sum_model$pe <- NULL
            },
            warning = function(w) {
              cat("Beware of the following lavaan warning (summary call):\n")
              cat(paste0(w$message, "\n"))
            }
          )
          print(sum_model)
        }

        if ("data.frame" %in% class(out)) {
          print(out)
        }

        if ("error" %in% class(out)) {
          stop(safeError(out))
        }
      }
    })
  })
}
