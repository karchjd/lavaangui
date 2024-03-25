serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderPrint({
      req(to_render())
      out <- to_render()

      if (is.character(out)) {
        cat(out)
        return(NULL)
      }

      if ("lavaan" %in% class(out) ) {
        modificationIndices(fit)
        sum_model <- summary(out, fit.measures = TRUE)
        sum_model$pe <- NULL
        return(sum_model)
      }
      
      if("error" %in% class(out)){
        stop(out)
      }
    })
  })
}
