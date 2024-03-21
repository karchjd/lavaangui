serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderUI({
      req(to_render())
      out <- to_render()
      warnings_html <- ""
      errors_html <- ""
      results_html <- ""
      
      if (is.character(out)) {
        return(HTML(paste0("<pre style='margin: 0; padding: 0 10px;'>", out, "</pre>")))
      }
      
      if (!is.null(out$warning)) {
        warnings_html <- paste0(
          "<span style='color: #FFC107;'>Beware of the following lavaan warning<br>",
          out$warning$message,
          "</span>"
        )
      }
      if (!is.null(out$error)) {
        errors_html <- paste0(
          "<span style='color: #D32F2F;'>Could not get results because of the following lavaan error.: <br><br>",
          out$error$message,
          "</span>"
        )
      }
      if (!is.null(out$results)) {
        result_string <- paste0(capture.output(print(out$results)), collapse = "\n")
        results_html <- paste0(
          "<pre style='margin: 0; padding: 0 10px;'>",
          result_string,
          "</pre>"
        )
      }
      
      HTML(paste0(warnings_html, errors_html, results_html))
    })
  })
}
