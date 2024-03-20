serverResultUpdater <- function(id, to_render) {
  moduleServer(id, function(input, output, session) {
    output$results <- renderPrint({
      req(to_render())
      ## for user model
      if (is.character(to_render())) {
        cat(to_render())
        ## for partable TODO: can be removed i think
      } else if (any(class(to_render()) == "lavaan.data.frame")) {
        print(to_render())
      } else {
        out <- to_render()
        if (!is.null(out$warning)) {
          cat("Beware of the following lavaan warning\n")
          cat(out$warning$message)
          cat("\n\n")
        }
        if (!is.null(out$error)) {
          cat("Could not get results because of the following lavaan error.\nProbably your model is not identified\n")
          print(out$error$message)
        }
        if (!is.null(out$results)) {
          print(out$results)
        }
      }
    })
  })
}
