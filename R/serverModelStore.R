serverModelStore <- function(id, fit, fitModelHash, to_render) {
  moduleServer(id, function(input, output, session) {
    storedModels <- reactiveVal(list())

    observeEvent(input$storeCurrent, {
      currentFit <- fit()
      if (is.null(currentFit)) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "storing the model",
            message = "No fitted model is available to store.",
            type = "danger"
          )
        )
        return(NULL)
      }

      modelName <- input$storeCurrent$name
      if (is.null(modelName) || length(modelName) != 1L) {
        modelName <- ""
      }
      modelName <- trimws(as.character(modelName))
      if (!nzchar(modelName)) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "storing the model",
            message = "Provide a name for the model.",
            type = "danger"
          )
        )
        return(NULL)
      }

      models <- storedModels()
      currentHash <- fitModelHash()
      duplicate <- vapply(
        models,
        function(model) identical(model$modelHash, currentHash),
        logical(1)
      )
      if (any(duplicate)) {
        session$sendCustomMessage(
          "model_duplicate",
          list(name = models[[which(duplicate)[1L]]]$name, count = length(models))
        )
        return(NULL)
      }

      models[[length(models) + 1L]] <- list(
        name = modelName,
        fit = currentFit,
        modelHash = currentHash
      )
      storedModels(models)

      session$sendCustomMessage(
        "model_stored",
        list(name = modelName, count = length(models))
      )
    })

    observeEvent(input$compare, {
      models <- storedModels()
      if (length(models) < 2L) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "comparing models",
            message = "Store at least two fitted models before comparing them.",
            type = "danger"
          )
        )
        return(NULL)
      }

      result <- tryCatch(
        withCallingHandlers(
          {
            do.call(
              lavaan::lavTestLRT,
              c(
                lapply(models, function(model) model$fit),
                list(model.names = vapply(models, function(model) model$name, character(1)))
              )
            )
          },
          warning = function(w) {
            session$sendCustomMessage(
              "lav_warning_error",
              list(origin = "comparing models", message = w$message, type = "warning")
            )
          }
        ),
        error = function(e) {
          session$sendCustomMessage(
            "lav_warning_error",
            list(origin = "comparing models", message = e$message, type = "danger")
          )
          to_render(e$message)
          NULL
        }
      )

      if (!is.null(result)) {
        to_render(result)
      }
    })

    observeEvent(input$removeAll, {
      storedModels(list())
      session$sendCustomMessage("models_removed", list(count = 0L))
    })

    storedModels
  })
}
