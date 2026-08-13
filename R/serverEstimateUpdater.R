serverEstimateUpdater <- function(id, forceEstimateUpdate, fit, to_render, full = TRUE) {
  moduleServer(id, function(input, output, session) {
    ## update estimates
    observe({
      req(fit())
      req(input$confindence_level)
      forceEstimateUpdate()
      tryCatch(
        withCallingHandlers(
          {
            group_labels <- getGroupLabels(fit())
            res <- list(
              normal = myParameterEstimates(fit(), level = input$confindence_level),
              std = standardizedEstimates(fit(), level = input$confindence_level),
              groups = lapply(seq_len(getNGroups(fit())), function(index) {
                list(
                  id = index,
                  label = unname(group_labels[[index]])
                )
              })
            )
            if (!full && getNGroups(fit()) > 1) {
              res$normal <- getGroupTable(res$normal)
              res$std <- getGroupTable(res$std)
              res$groups <- list()
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
