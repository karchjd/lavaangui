serverUserLayoutSaver <- function(id, export_plot) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$user_layout, {
            if (export_plot) {
                return(NULL)
            }
            req(input$user_layout)

            # Parse the incoming data
            # input$user_layout is likely a list if sent as JSON from Shiny
            layout_info <- input$user_layout

            name <- layout_info$name
            hash <- layout_info$hash
            model_data <- layout_info$model

            # Sanitize name to avoid filesystem issues
            safe_name <- gsub("[^a-zA-Z0-9_-]", "", name)
            filename <- sprintf("layout_%s_%s.json", hash, safe_name)

            jsonlite::write_json(model_data, filename)
            message(sprintf("Saved layout to %s", filename))
        })
    })
}
