serverEstimateUpdater <- function(id, forceEstimateUpdate, fit) {
  moduleServer(id, function(input, output, session) {
    ## update estimates
    observe({
      req(fit())
      req(input$confindence_level)
      forceEstimateUpdate()
      res <- list(
        normal = parameterestimates(fit(), level = input$confindence_level),
        std = standardizedsolution(fit(), level = input$confindence_level)
      )
      session$sendCustomMessage("lav_estimates", res)
    })
  })
}
