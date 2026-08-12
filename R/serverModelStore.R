serverModelStore <- function(id, fit, fitModelHash, fitModelDetails) {
  moduleServer(id, function(input, output, session) {
    storedModels <- reactiveVal(list())
    comparisonResult <- reactiveVal(NULL)

    output$comparisonTable <- DT::renderDataTable({
      req(comparisonResult())
      result <- as.data.frame(comparisonResult())
      result <- data.frame(
        Model = rownames(result),
        result,
        check.names = FALSE,
        row.names = NULL
      )
      custom_dt(result, digits = 4)
    })

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
      currentDetails <- fitModelDetails()
      diagram <- input$storeCurrent$diagram
      if (
        is.null(currentHash) ||
          is.null(currentDetails$syntax) ||
          is.null(currentDetails$call)
      ) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "storing the model",
            message = "The fitted model metadata is not available. Fit the model again before storing it.",
            type = "danger"
          )
        )
        return(NULL)
      }
      if (is.null(diagram) || length(diagram) != 1L || !nzchar(diagram)) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "storing the model",
            message = "The current diagram could not be captured.",
            type = "danger"
          )
        )
        return(NULL)
      }
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
        modelHash = currentHash,
        syntax = currentDetails$syntax,
        call = currentDetails$call,
        diagram = diagram
      )
      storedModels(models)

      session$sendCustomMessage(
        "model_stored",
        list(name = modelName, count = length(models))
      )
    })

    observeEvent(input$requestModels, {
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

      session$sendCustomMessage(
        "comparison_models",
        lapply(seq_along(models), function(index) {
          list(index = index, name = models[[index]]$name)
        })
      )
    })

    observeEvent(input$compare, {
      models <- storedModels()
      selected <- suppressWarnings(as.integer(unlist(input$compare$indices)))
      selected <- selected[!is.na(selected) & selected >= 1L & selected <= length(models)]
      selected <- unique(selected)
      if (length(selected) < 2L) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "comparing models",
            message = "Select at least two fitted models to compare.",
            type = "danger"
          )
        )
        return(NULL)
      }

      models <- models[selected]

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
          NULL
        }
      )

      if (!is.null(result)) {
        comparisonResult(result)
        session$sendCustomMessage("show_model_comparison", list())
      }
    })

    observeEvent(input$modelDetails, {
      models <- storedModels()
      index <- suppressWarnings(as.integer(input$modelDetails$index))
      if (length(index) != 1L || is.na(index) || index < 1L || index > length(models)) {
        return(NULL)
      }

      model <- models[[index]]
      details <- tryCatch(
        {
          list(
            index = index,
            name = model$name,
            syntax = model$syntax,
            call = model$call,
            diagram = model$diagram
          )
        },
        error = function(e) {
          session$sendCustomMessage(
            "lav_warning_error",
            list(origin = "showing model details", message = e$message, type = "danger")
          )
          NULL
        }
      )

      if (!is.null(details)) {
        session$sendCustomMessage("model_details", details)
      }
    })

    observeEvent(input$removeAll, {
      storedModels(list())
      comparisonResult(NULL)
      session$sendCustomMessage("models_removed", list(count = 0L))
    })

    storedModels
  })
}
