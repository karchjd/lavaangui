serverLayout <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$layout, {
      tryCatch(
        {
          req(input$layout)
          req(fit())
          fromJavascript <- jsonlite::fromJSON(input$layout)
          semPlotModel <- semPlot::semPlotModel(fit())
          semPlotRes <- semPlot::semPaths(semPlotModel,
            layout = fromJavascript$name,
            nCharNodes = 0, nCharEdges = 0,
            DoNotPlot = TRUE, reorder = TRUE
          )
          coordinates <- data.frame(
            name = semPlotModel@Vars$name, x = semPlotRes$layout[, 1],
            y = semPlotRes$layout[, 2]
          )
          session$sendCustomMessage("semPlotLayout", coordinates)
        },
        error = function(e) {
          session$sendCustomMessage(
            "lav_warning_error",
            list(origin = "layout", message = e$message, type = "danger")
          )
          print(e$message)
        }
      )
    })
  })
}
