lavaan_gui_server <- function(input, output, session) {
  # settings
  # to send errors to frontend
  op <- options(shiny.error = function() {
    session <- getDefaultReactiveDomain()
    error_message <- geterrmessage()
    session$sendCustomMessage("serverError", list(msg = error_message))
  })
  onStop(function() options(op))


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
  
  serverResultUpdater("res", to_render)
  
  serverDownloader("down", getData)
  
  # showing help leave as is
  observeEvent(input$show_help, {
    to_render(help_text)
  })
}
