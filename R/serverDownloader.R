serverDownloader <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$requestData, {
      data_csv <- readr::format_csv(getData())
      if(input$requestData$goal == "download"){
        session$sendCustomMessage("dataForDownload", data_csv)  
      }else if(input$requestData$goal == "saveData"){
        session$sendCustomMessage("dataForSave", data_csv)  
      }else {
        stop("invalid goal")
      }
    })
  })
}
