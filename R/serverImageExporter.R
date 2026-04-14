serverImageExporter <- function(id) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$image, {
            req(input$image)
            img_raw_data <- base64enc::base64decode(input$image$data)
            writeBin(img_raw_data, input$image$filepath)
            message(sprintf("Saved image to %s", input$image$filepath))
            session$sendCustomMessage("close", "")
        })
    })
}
