serverDownloader <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$requestData, {
      data_csv <- readr::format_csv(getData())
      session$sendCustomMessage("dataForDownload", data_csv)
    })
  })
}
