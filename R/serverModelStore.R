serverModelStore <- function(id, fit, analysisState) {
  moduleServer(id, function(input, output, session) {
    storedModels <- reactiveVal(list())
    comparisonResult <- reactiveVal(NULL)
    comparisonMessages <- reactiveVal(list())

    addComparisonMessage <- function(message, type) {
      comparisonMessages(c(
        comparisonMessages(),
        list(list(message = message, type = type))
      ))
    }

    output$comparisonMessages <- renderUI({
      messages <- comparisonMessages()
      if (length(messages) == 0L) {
        return(NULL)
      }

      tagList(lapply(messages, function(info) {
        label <- if (identical(info$type, "danger")) "Error" else "Warning"
        tags$div(
          class = paste("alert", paste0("alert-", info$type)),
          role = "alert",
          tags$strong(paste0(label, ": ")),
          info$message
        )
      }))
    })

    output$comparisonTable <- DT::renderDataTable({
      if (is.null(comparisonResult())) {
        return(NULL)
      }
      result <- as.data.frame(comparisonResult())
      result <- data.frame(
        Model = rownames(result),
        result,
        check.names = FALSE,
        row.names = NULL
      )
      custom_dt(
        result,
        digits = 4,
        filter = "none",
        options = list(
          dom = "t",
          paging = FALSE,
          searching = FALSE,
          lengthChange = FALSE,
          info = FALSE
        )
      )
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
      state <- analysisState()
      currentDetails <- state$details
      diagram <- input$storeCurrent$diagram
      if (
        !analysisHasCurrentFit(state) ||
          is.null(currentDetails$syntax) ||
          is.null(currentDetails$call)
      ) {
        session$sendCustomMessage(
          "lav_warning_error",
          list(
            origin = "storing the model",
            message = "The current model or data has changed since the last fit. Fit it again before storing it.",
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
        function(model) {
          identical(model$modelHash, state$fittedModelHash) &&
            identical(model$dataHash, state$fittedDataHash)
        },
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
        modelHash = state$fittedModelHash,
        dataHash = state$fittedDataHash,
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
      comparisonResult(NULL)
      comparisonMessages(list())

      dataHashes <- lapply(models, function(model) model$dataHash)
      if (!all(vapply(
        dataHashes[-1L],
        identical,
        logical(1),
        dataHashes[[1L]]
      ))) {
        addComparisonMessage(
          "Likelihood-ratio tests require models fitted to the same data.",
          "danger"
        )
        session$sendCustomMessage("show_model_comparison", list())
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
            addComparisonMessage(conditionMessage(w), "warning")
            invokeRestart("muffleWarning")
          }
        ),
        error = function(e) {
          addComparisonMessage(conditionMessage(e), "danger")
          NULL
        }
      )

      if (!is.null(result)) {
        comparisonResult(result)
      }
      session$sendCustomMessage("show_model_comparison", list())
    })

    observeEvent(input$modelDetails, {
      models <- storedModels()
      index <- suppressWarnings(as.integer(input$modelDetails$index))
      if (length(index) != 1L || is.na(index) || index < 1L || index > length(models)) {
        return(NULL)
      }

      model <- models[[index]]
      details <- list(
        index = index,
        name = model$name,
        syntax = model$syntax,
        call = model$call,
        diagram = model$diagram
      )
      session$sendCustomMessage("model_details", details)
    })

    observeEvent(input$removeAll, {
      storedModels(list())
      comparisonResult(NULL)
      comparisonMessages(list())
      session$sendCustomMessage("models_removed", list(count = 0L))
    })

    storedModels
  })
}
