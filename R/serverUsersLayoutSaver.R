serverUserLayoutSaver <- function(id, export_plot, filename) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$user_layout, {
            if (export_plot) {
                return(NULL)
            }
            req(input$user_layout)
            layout <- input$user_layout$model

            layouts_dir <- file.path("layouts")
            if (!dir.exists(layouts_dir)) {
                dir.create(layouts_dir, recursive = TRUE)
            }

            layout_path <- file.path(layouts_dir, filename)
            jsonlite::write_json(layout, layout_path)
            message(sprintf("Saved layout to %s", layout_path))
        })
    })
}
