lavaan_gui_server <- function(input, output, session) {
  # reactive vals
  fit <- reactiveVal(NULL)
  forceEstimateUpdate <- reactiveVal()
  to_render <- reactiveVal(help_text)
  full <- TRUE
  savedModelHash <- NULL
  print("hallo")

  session$sendCustomMessage("version", message = utils::packageVersion("lavaangui"))


  ## import model if present
  importRes <- importModel(session)
  imported <- importRes$imported
  full <- importRes$full
  if (imported) {
    if (!full) {
      fit(importRes$fit)
      savedModelHash <- importRes$hash
    }
  }

  ## View data
  serverDataViewer("dataViewer", getData)

  ## seems needed but probably can be done better
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
  
  observeEvent(input$modelForR,
               {
                 if (!dir.exists("lavaangui-models-R")) {
                   dir.create("lavaangui-models-R")
                 }
                 fName <- paste0(savedModelHash,'.lvm')
                 fPath <- file.path("lavaangui-models-R", fName)
                 writeLines(input$modelForR, fPath)
               },
               ignoreNULL = TRUE,
               ignoreInit = TRUE
  )

  observeEvent(input$exportedGraph,
    {
      stopApp(input$exportedGraph)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )
}
