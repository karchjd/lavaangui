lavaan_gui_server <- function(input, output, session) {
  # settings
  # to send errors to frontend
  op <- options(shiny.error = function() {
    session <- getDefaultReactiveDomain()
    error_message <- geterrmessage()
    session$sendCustomMessage("serverError", list(msg = error_message))
  })
  onStop(function() options(op))


  ## init stuff
  shinyjs::useShinyjs(html = TRUE) ##TODO CHECK NEEDED
  future::plan(future::multisession) ##TODO CHECK MOVE
  `%...>%` <- promises::`%...>%` ##TODO CHECK NEEDED

  # reactive vals
  fit <- reactiveVal(NULL)
  forceEstimateUpdate <- reactiveVal()
  to_render <- reactiveVal(help_text)
  first_run_layout <- reactiveVal(TRUE) ##TODO CHECK NEEDED


  ## import model if present
  importRes <- importModel(session)
  imported <- importRes$imported
  if (imported) {
    fit(importRes$fit)
    to_render(importRes$to_render)
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
    if(isTruthy(x())){
      return(x())
    }else if(imported){
      return(importRes$data_react)
    }else{
      return(NULL)
    }
  })
  
  ## rename data
  getData <- reactive({
    local_data <- data_react()
    if (!is.null(input$newnames)) {
      names(local_data$df) <- input$newnames
    }
    return(local_data$df)
  })
  
  ## layout
  serverLayout("layout", fit)
  
  ## main server for running ladan
  runRes <- serverLavaanRun("run", to_render, forceEstimateUpdate, getData, fit)
  
  serverEstimateUpdater("ests", forceEstimateUpdate, fit)
  
  output$lavaan_syntax_R <- renderPrint({
    req(to_render())
    ## for user model
    if (is.character(to_render())) {
      cat(to_render())
      ## for partable TODO: can be removed i think
    } else if (any(class(to_render()) == "lavaan.data.frame")) {
      print(to_render())
    } else {
      out <- to_render()
      if (!is.null(out$warning)) {
        cat("Beware of the following lavaan warning\n")
        cat(out$warning$message)
        cat("\n\n")
      }
      if (!is.null(out$error)) {
        cat("Could not get results because of the following lavaan error.\nProbably your model is not identified\n")
        print(out$error$message)
      }
      if (!is.null(out$results)) {
        print(out$results)
      }
    }
  })

  ## put this into downloadModule
  # Define the download handler function
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("lavaangui-", Sys.Date(), ".zip", sep = "")
    },

    # Define the content of the file
    content = function(file) {
      # Create a temporary directory
      tempDir <- tempdir()

      # Define the names of the JSON and CSV files
      jsonFile <- file.path(tempDir, "model.json")
      csvFile <- file.path(tempDir, "data.csv")


      writeLines(input$model, jsonFile)

      # Write the data frame to the CSV file (replace my_data with your data frame)
      utils::write.csv(getData(), csvFile, row.names = FALSE)

      # Create a zip archive of the directory containing the JSON and CSV files
      zip::zip(zipfile = file, files = c("model.json", "data.csv"), root = tempDir)
    }
  )

  outputOptions(output, "downloadData", suspendWhenHidden = FALSE)
  
  # showing help leave as is
  observeEvent(input$show_help, {
    to_render(help_text)
  })
}
