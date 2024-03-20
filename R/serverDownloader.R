serverDownloader <- function(id, getData) {
  moduleServer(id, function(input, output, session) {
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
  })
}
