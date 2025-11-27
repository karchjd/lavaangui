serverUserLayoutSaver <- function(id, export_plot, filename) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$user_layout, {
            if (export_plot) {
                return(NULL)
            }
            req(input$user_layout)
            layout <- input$user_layout$model
            jsonlite::write_json(layout, filename)
            message(sprintf("Saved layout to %s", filename))
        })
    })
}
