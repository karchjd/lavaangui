serverDownloader <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$requestData, {
      data_csv <- paste0(utils::capture.output(utils::write.csv(getData(), row.names = FALSE)), collapse = "\n")
      session$sendCustomMessage("dataForDownload", data_csv)
    })
  })
}
