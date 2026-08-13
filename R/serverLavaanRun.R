checkVarsInData <- function(model_parsed, data) {
  names_model <- lavNames(model_parsed, type = "ov")
  names_data <- names(data)
  var_not_in_data <- !(names_model %in% names_data)
  names(var_not_in_data) <- names_model
  return(var_not_in_data)
}

getHashData <- function(df) {
  attributes(df) <- NULL
  return(digest::digest(df))
}

getHashModel <- function(model) {
  digest::digest(model[c("options", "syntax")])
}

getFitWarningMessages <- function(warnings) {
  if (is.null(warnings)) {
    messages <- character()
  } else if (inherits(warnings, "condition")) {
    messages <- conditionMessage(warnings)
  } else if (is.character(warnings)) {
    messages <- unname(warnings)
  } else if (!is.list(warnings)) {
    messages <- character()
  } else {
    messages <- lapply(warnings, function(warning) {
      if (inherits(warning, "condition")) {
        conditionMessage(warning)
      } else if (is.character(warning)) {
        warning
      } else if (is.list(warning) && !is.null(warning$message)) {
        warning$message
      } else {
        NULL
      }
    })
    messages <- unname(unlist(messages, use.names = FALSE))
  }
  messages
}

sendFitMessages <- function(session, warnings = NULL, error = NULL) {
  messages <- lapply(getFitWarningMessages(warnings), function(message) {
    list(type = "warning", message = message)
  })
  if (!is.null(error)) {
    errorMessage <- if (inherits(error, "condition")) {
      conditionMessage(error)
    } else {
      as.character(error)
    }
    messages <- c(messages, list(list(type = "danger", message = errorMessage)))
  }
  session$sendCustomMessage("fit_messages", messages)
}

sendResultsFront <- function(session, result, fromJavascript, df) {
  result$fit@Data@X <- list()
  res <- list(
    fitted_model = base64enc::base64encode(serialize(result, NULL)),
    model = getHashModel(fromJavascript$model), data = getHashData(df)
  )
  session$sendCustomMessage("lav_results", res)
}


serverLavaanRun <- function(id, to_render, forceEstimateUpdate, getData, fit, fitModelHash, fitModelDetails) { # nolint: cyclocomp_linter.
  moduleServer(id, function(input, output, session) {
    abort_file_global <- reactiveVal()
    future::plan(future::multisession)
    ## main loop
    observeEvent(input$fromJavascript, {
      req(input$fromJavascript)
      ## Mode == "User Model", just send R_script to output
      fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
      sendFitMessages(session)
      if (fromJavascript$mode == "user model") {
        to_render(fromJavascript$model$R_script)
        return(NULL)
      }

      ## Mode = "Full Model" or "Estimate", send model
      modelJavascript <- fromJavascript$model
      model <- modelJavascript$syntax # nolint: object_usage_linter.
      optsList <- modelJavascript$optionsList
      has_group <- !is.null(optsList$group) && nzchar(as.character(optsList$group))
      modelHash <- getHashModel(fromJavascript$model)
      modelDetails <- list(
        syntax = model,
        call = paste0("fit <- lavaan(model, data, ", modelJavascript$options)
      )
      if (length(modelJavascript$ordered_labels) > 0 && !has_group) { ## ordinal data present
        modelParse <- paste0(model, "\n")
        for (i in 1:length(modelJavascript$ordered_labels)) {
          modelParse <- paste0(modelParse, modelJavascript$ordered_labels[i], "|t1\n")
        }
        ordered_opts <- optsList
        ordered_opts$ordered <- NULL
        ordered_opts$missing <- NULL
        ordered_opts$estimator <- NULL
        ordered_opts$se <- NULL
        ordered_opts$bootstrap <- NULL
        ordered_opts$meanstructure <- TRUE
        lavaanify_args <- c(list(model = modelParse), ordered_opts)
      } else {
        lavaan_args <- c(
          list(model = model),
          if (has_group) list(data = getData(), do.fit = FALSE) else list(),
          optsList
        )
      }


      ## gotta love R error handling...
      wasError <- tryCatch(
        withCallingHandlers(
          {
            if (length(modelJavascript$ordered_labels) > 0 && !has_group) {
              model_parsed <- do.call(lavaan::lavaanify, lavaanify_args)
            } else {
              lavaan_model <- do.call(lavaan::lavaan, lavaan_args)
              model_parsed <- parTable(lavaan_model)
            }
          },
          error = function(e) {
            session$sendCustomMessage(
              "lav_warning_error",
              list(origin = "parsing the model", message = e$message, type = "danger")
            )
            to_render(e$message)
          },
          warning = function(w) {
            session$sendCustomMessage(
              "lav_warning_error",
              list(origin = "parsing the model", message = w$message, type = "warning")
            )
          }
        ),
        error = function(e) {
          return(NULL)
        }
      )

      ## there an error, exiting
      if (is.null(wasError)) {
        return(NULL)
      }

      model_front <- model_parsed
      if (has_group && "group" %in% names(model_front)) {
        first_group <- min(model_front$group)
        model_front <- model_front[model_front$group == first_group, , drop = FALSE]
      }
      session$sendCustomMessage("lav_model", model_front)

      ## Mode = "Full Model" send script to render and stop
      if (fromJavascript$mode == "full model") {
        to_render(modelJavascript$R_script)
        return(NULL)
      }

      ## Mode == "Estimate", estimate model and send results or send results from cache
      stopifnot(fromJavascript$mode == "estimate")
      # cache is valid, return cached results
      cacheValid <- !is.null(fromJavascript$cache$lastFitModel) &&
        fromJavascript$cache$lastFitModel == modelHash &&
        (is.null(getData()) || fromJavascript$cache$lastFitData == getHashData(getData()))
      if (cacheValid) {
        cacheResult <- unserialize(base64enc::base64decode(fromJavascript$cache$lastFitLavFit))
        if (isTruthy(getData())) {
          data <- getData()
          cache_args <- c(list(model = model, data = data, do.fit = FALSE), optsList)
          tmp <- do.call(lavaan::lavaan, cache_args)
          cacheResult$fit@Data@X <- tmp@Data@X
        }

        fit(cacheResult$fit)
        fitModelHash(modelHash)
        fitModelDetails(modelDetails)
        sendResultsFront(session, cacheResult, fromJavascript, getData())
        sendFitMessages(session, cacheResult$warning)
        to_render(cacheResult)
        forceEstimateUpdate(stats::rnorm(1))
        session$sendCustomMessage("usecache", "")
        return(NULL)
      }

      # Data missing, stop
      if (!isTruthy(getData())) {
        session$sendCustomMessage("data_missing", 1)
        return(NULL)
      }

      # not all variables available, stop
      data <- getData()
      missing_vars <- checkVarsInData(model_parsed, data)
      if (any(missing_vars)) {
        session$sendCustomMessage("missing_vars", names(missing_vars)[missing_vars])
        return(NULL)
      }

      ## fit model
      session$sendCustomMessage("fitting", "")
      abort_file <- tempfile()
      abort_file_global(abort_file)
      fit_args <- c(list(model = model, data = data), optsList)
      fut <- promises::future_promise(
        {
          `%get%` <- function(pkg, fun) {
            get(fun,
              envir = asNamespace(pkg),
              inherits = FALSE
            )
          }
          original_function <- "lavaan" %get% "lav_model_objective"
          original_function_string <- deparse(original_function)
          new_function <- append(original_function_string, "if (file.exists(abort_file)) {quit()}", after = 3)
          new_function <- eval(parse(text = new_function))

          environment(new_function) <- asNamespace("lavaan")
          utils::assignInNamespace("lav_model_objective", new_function, ns = "lavaan")
          lastWarning <- NULL
          lastError <- NULL

          withCallingHandlers(
            {
              local_fit <- tryCatch(
                do.call(lavaan::lavaan, fit_args),
                error = function(e) {
                  lastError <<- e
                  return(NULL)
                }
              )
            },
            warning = function(w) {
              lastWarning <<- c(lastWarning, conditionMessage(w))
              invokeRestart("muffleWarning")
            }
          )
          list(fit = local_fit, warning = lastWarning, error = lastError)
        },
        packages = "lavaan",
        globals = c("abort_file", "fit_args"),
        seed = TRUE
      )
      ## sucesses fit
      promises::then(
        fut,
        function(value) {
          if (is.null(value$error)) {
            fit(value$fit)
            fitModelHash(modelHash)
            fitModelDetails(modelDetails)
            sendResultsFront(session, value, fromJavascript, getData())
            sendFitMessages(session, value$warning)
            to_render(value)
            session$sendCustomMessage("lav_sucess", "lav_error")
          } else {
            print(value$error)
            sendFitMessages(session, error = value$error)
            session$sendCustomMessage("lav_error_fitting", list())
            to_render(value$error)
          }
        }
      )

      ## fail fit, might not be reachable anymore because of new try in promises, which was needed
      ## because this catch did not catch all errors
      promises::catch(
        fut,
        function(e) {
          if (grepl("No process exists with this PID", e$message) || grepl("failed to receive message results from cluster RichSOCKnode #1")) {
            e$message <- "Fitting cancelled by user"
          }
          sendFitMessages(session, error = e)
          session$sendCustomMessage("lav_error_fitting", list())
          to_render(e)
        }
      )

      ## cleanup
      promises::finally(fut, function() {
        if (file.exists(abort_file)) {
          file.remove(abort_file)
        }
      })
      return(NULL) ## Never ever remove this. This stops the UI from blocking!!!
    })

    observeEvent(input$abort, {
      abort_file_global()
      file.create(abort_file_global())
    })

    list(
      to_render = to_render,
      forceEstimateUpdate = forceEstimateUpdate
    )
  })
}
