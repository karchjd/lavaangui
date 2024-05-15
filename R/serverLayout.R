serverLayout <- function(id, fit, full, imported) {
  moduleServer(id, function(input, output, session) {
    first_run_layout <- reactiveVal(TRUE)
    observeEvent(input$layout, {
      tryCatch(
        {
          req(input$layout)
          fromJavascript <- jsonlite::fromJSON(input$layout)
          fitObject <- FALSE
          if (imported && first_run_layout() && !full) {
            semPlotModel <- semPlotModel_lavaanModel(fit())
            first_run_layout(FALSE)
            fitObject <- TRUE
          } else {
            model <- eval(parse(text = fromJavascript$model$syntax))
            semPlotModel <- semPlotModel_lavaanModel(model)
          }
          semPlotRes <- semPaths(semPlotModel,
            layout = fromJavascript$name,
            nCharNodes = 0, nCharEdges = 0,
            DoNotPlot = TRUE, reorder = TRUE
          )
          if (!fitObject) {
            ngroups <- 1
          } else {
            ngroups <- lavInspect(semPlotModel@"Original"[[1]], "ngroups")
          }
          if (ngroups == 1) {
            coordinates <- data.frame(
              name = semPlotModel@Vars$name, x = semPlotRes$layout[, 1],
              y = semPlotRes$layout[, 2]
            )
            session$sendCustomMessage("semPlotLayout", coordinates)
          } else {
            for (i in 1:ngroups) {
              coordinates <- data.frame(
                name = paste0(semPlotModel@Vars$name, ".", i), x = semPlotRes[[i]]$layout[, 1] + 2.5 * (i - 1),
                y = semPlotRes[[i]]$layout[, 2]
              )
              session$sendCustomMessage("semPlotLayout", coordinates)
            }
          }
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
