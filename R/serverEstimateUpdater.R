serverEstimateUpdater <- function(id, forceEstimateUpdate, fit, to_render) {
  moduleServer(id, function(input, output, session) {
    ## update estimates
    observe({
      req(fit())
      req(input$confindence_level)
      forceEstimateUpdate()
      tryCatch(
        withCallingHandlers(
          {
            res <- list(
              normal = parameterestimates(fit(), level = input$confindence_level),
              std = standardizedsolution(fit(), level = input$confindence_level)
            )
            if (lavInspect(fit(), "ngroups") > 1) {
              res$normal <- getGroupTable(res$normal)
              res$std <- getGroupTable(res$std)
            }
            session$sendCustomMessage("lav_estimates", res)
          },
          error = function(e) {
            session$sendCustomMessage(
              "lav_warning_error",
              list(origin = "updating estimates", message = e$message, type = "danger")
            )
            to_render(e$message)
          },
          warning = function(w) {
            session$sendCustomMessage(
              "lav_warning_error",
              list(origin = "updating estimates", message = w$message, type = "warning")
            )
          }
        ),
        error = function(e) {
          return(NULL)
        }
      )
    })
  })
}
