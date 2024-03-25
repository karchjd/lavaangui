serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderPrint({
      req(to_render())
      out <- to_render()

      if (is.character(out)) {
        cat(out)
        return(NULL)
      }


      if (!is.null(out$warning)) {
        print("Beware of the following lavaan warning(s) (lavaan call):")
        browser()
        for (i in seq_along(out$warning)) {
          if (!is.null(out$warning[i]$message)) {
            print(out$warning[i]$message)
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
            print("Beware of the following lavaan warning (summary call):")
            print(w$message)
          }
        )
        print(sum_model)
      }

      if ("error" %in% class(out)) {
        stop(out)
      }
    })
  })
}
