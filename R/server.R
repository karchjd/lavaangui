lavaan_gui_server <- function(input, output, session) {
  # reactive vals
  fit <- reactiveVal(NULL)
  forceEstimateUpdate <- reactiveVal()
  to_render <- reactiveVal(help_text)
  full <- TRUE


  ## import model if present
  importRes <- importModel(session)
  imported <- importRes$imported
  full <- importRes$full
  if (imported) {
    if (!full) {
      fit(importRes$fit)
    }
  }

  ## View data
  serverDataViewer("dataViewer", getData)

  ## TODO: investigate this one
  observeEvent(input$sendnames, {
    session$sendCustomMessage("columnames", message = input$newnames)
  })

  ## Upload data
  x <- serverDataUploader("dataUpload")
  data_react <- reactive({
    if (isTruthy(x())) {
      return(x())
    } else if (imported) {
      return(importRes$data_react)
    } else {
      return(NULL)
    }
  })

  ## rename data
  getData <- reactive({
    local_data <- data_react()
    if (!is.null(input$newnames$newnames)) {
      names(local_data$df) <- unlist(input$newnames$newnames)
    }
    return(local_data$df)
  })

  ## layout
  serverLayout("layout", fit, full, imported)

  ## main server for running ladan
  serverLavaanRun("run", to_render, forceEstimateUpdate, getData, fit)

  serverEstimateUpdater("ests", forceEstimateUpdate, fit, to_render)

  serverResultUpdater("res", to_render)

  serverDownloader("down", getData)

  extendResultsServer("extend", fit)

  # showing help leave as is
  observeEvent(input$show_help, {
    to_render(help_text)
  })
}
