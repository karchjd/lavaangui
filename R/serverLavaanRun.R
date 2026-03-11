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

sendResultsFront <- function(session, result, fromJavascript, df) {
  result$fit@Data@X <- list()
  res <- list(
    fitted_model = base64enc::base64encode(serialize(result, NULL)),
    model = digest::digest(fromJavascript$model[c("options", "syntax")]), data = getHashData(df)
  )
  session$sendCustomMessage("lav_results", res)
}


serverLavaanRun <- function(id, to_render, forceEstimateUpdate, getData, fit) { # nolint: cyclocomp_linter.
  moduleServer(id, function(input, output, session) {
    abort_file_global <- reactiveVal()
    future::plan(future::multisession)
    ## main loop
    observeEvent(input$fromJavascript, {
      req(input$fromJavascript)
      ## Mode == "User Model", just send R_script to output
      fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
      if (fromJavascript$mode == "user model") {
        to_render(fromJavascript$model$R_script)
        return(NULL)
      }

      ## Mode = "Full Model" or "Estimate", send model
      modelJavascript <- fromJavascript$model
      model <- modelJavascript$syntax # nolint: object_usage_linter.
      optsList <- modelJavascript$optionsList
      if (length(modelJavascript$ordered_labels) > 0) { ## ordinal data present
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
        lavaan_args <- c(list(model = model), optsList)
      }


      ## gotta love R error handling...
      wasError <- tryCatch(
        withCallingHandlers(
          {
            if (length(modelJavascript$ordered_labels) > 0) {
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

      session$sendCustomMessage("lav_model", model_parsed)

      ## Mode = "Full Model" send script to render and stop
      if (fromJavascript$mode == "full model") {
        to_render(modelJavascript$R_script)
        return(NULL)
      }

      ## Mode == "Estimate", estimate model and send results or send results from cache
      stopifnot(fromJavascript$mode == "estimate")
      # cache is valid, return cached results
      cacheValid <- !is.null(fromJavascript$cache$lastFitModel) &&
        fromJavascript$cache$lastFitModel == digest::digest(fromJavascript$model[c("options", "syntax")]) &&
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
        sendResultsFront(session, cacheResult, fromJavascript, getData())
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
              lastWarning <<- c(lastWarning, w)
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
            sendResultsFront(session, value, fromJavascript, getData())
            to_render(value)
            session$sendCustomMessage("lav_sucess", "lav_error")
          } else {
            print(value$error)
            session$sendCustomMessage("lav_error_fitting", list(origin = "fitting the model the model", message = value$error$message, type = "danger"))
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
          session$sendCustomMessage("lav_error_fitting", list(origin = "fitting the model the model", message = e$message, type = "danger"))
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
