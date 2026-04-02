serverUserLayoutSaver <- function(id, export_plot) {
    moduleServer(id, function(input, output, session) {
        observeEvent(input$user_layout, {
            if (export_plot) {
                return(NULL)
            }
            req(input$user_layout)
            layout <- input$user_layout$model
            name <- input$user_layout$name
            hash <- input$user_layout$hash

            if (is.null(name) || is.null(hash)) {
                return(NULL)
            }

            layouts_dir <- file.path("layouts")
            if (!dir.exists(layouts_dir)) {
                dir.create(layouts_dir, recursive = TRUE)
            }

            safe_name <- gsub("[^a-zA-Z0-9_-]", "", name)
            filename <- sprintf("layout_%s_%s.json", hash, safe_name)
            layout_path <- file.path(layouts_dir, filename)
            jsonlite::write_json(layout, layout_path)
            message(sprintf("Saved layout to %s", layout_path))
        })
    })
}
