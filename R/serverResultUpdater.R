serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderPrint({
      req(to_render())
      out <- to_render()
      if (is.character(out)) {
        cat(out)
      } else {
        if (!inherits(out, "error")) {
          if ("lavaan" %in% class(out$fit)) {
            withCallingHandlers(
              {
                sum_model <- summary(out$fit, fit.measures = TRUE)
                sum_model$pe <- NULL
              },
              warning = function(w) {
                cat("Beware of the following lavaan warning (summary call):\n")
                cat(paste0(conditionMessage(w), "\n"))
                invokeRestart("muffleWarning")
              }
            )
            print(sum_model)
          }

          if ("data.frame" %in% class(out)) {
            print(out)
          }
        }
      }
    })
  })
}
