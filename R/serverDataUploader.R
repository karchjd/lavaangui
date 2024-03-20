serverDataUploader <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
    data <- reactiveVal(NULL)
    observeEvent(input$fileInput, {
      if (is.null(input$fileInput$content)) {
        data(list(df = read_auto(input$fileInput$datapath), name = input$fileInput$name))
      } else {
        content <- input$fileInput$content
        decoded <- base64enc::base64decode(content)
        data <- (list(df = readr::read_csv(decoded), name = "data.csv"))
      }
      propagateData(data(), session)
    })
    data
  })
}
