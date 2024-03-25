checkVarsInData <- function(model_parsed, data) {
  names_model <- lavNames(model_parsed, type = "ov")
  names_data <- names(data)
  var_not_in_data <- !(names_model %in% names_data)
  names(var_not_in_data) <- names_model
  return(var_not_in_data)
}

sendResultsFront <- function(session, result, fromJavascript, df) {
  res <- list(
    fitted_model = base64enc::base64encode(serialize(result, NULL)),
    model = digest::digest(fromJavascript$model), data = digest::digest(df)
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
      model <- eval(parse(text = modelJavascript$syntax)) # nolint: object_usage_linter.
      lavaan_parse_string <- paste0("lavaan(model, ", modelJavascript$options)

      ## gotta love R error handling...
      wasError <- tryCatch(
        withCallingHandlers(
          {
            lavaan_model <- eval(parse(text = lavaan_parse_string))
            model_parsed <- parTable(lavaan_model)
          },
          error = function(e) {
            session$sendCustomMessage("lav_warning_error", list(origin = "parsing the model", message = e$message, type = "danger"))
            to_render(e$message)
          },
          warning = function(w) {
            session$sendCustomMessage("lav_warning_error", list(origin = "parsing the model", message = w$message, type = "warning"))
            print("there was a warning")
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
        fromJavascript$cache$lastFitModel == digest::digest(fromJavascript$model) &&
        (is.null(getData()) || fromJavascript$cache$lastFitData == digest::digest(getData()))
      if (cacheValid) {
        cacheResult <- unserialize(base64enc::base64decode(fromJavascript$cache$lastFitLavFit))
        fit(cacheResult)
        sendResultsFront(session, cacheResult, fromJavascript, getData())
        to_render(fit())
        forceEstimateUpdate(rnorm(1))
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
      lavaan_string <- paste0("lavaan(model, data, ", modelJavascript$options)
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
          lastWarning <- c()
          withCallingHandlers(
            {
              warning("some lavaan warning")
              warning("some other lavaan warning")
              local_fit <- eval(parse(text = lavaan_string))
            },
            warning = function(w) {
              lastWarning <<- c(lastWarning, w)
            }
          )
          list(fit = local_fit, warning = lastWarning)
        },
        packages = "lavaan",
        globals = c("data", "abort_file", "model", "lavaan_string"),
        seed = TRUE
      )
      ## sucesses fit
      promises::then(
        fut,
        function(value) {
          fit(value$fit)
          sendResultsFront(session, value$fit, fromJavascript, getData())
          to_render(value)
          session$sendCustomMessage("lav_sucess", "lav_error")
        }
      )

      ## fail fit
      promises::catch(
        fut,
        function(e) {
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
