# extract results from model
getResults <- function(result, fromJavascriptJSON, session, df) {
  fromJavascript <- jsonlite::fromJSON(fromJavascriptJSON)
  fromJavascript$fitted_model <- NULL
  text_res <- getTextOut(result)
  if (!text_res$problem) {
    out <- tryCatch(
      {
        res <- list(
          fitted_model = base64enc::base64encode(serialize(result, NULL)), model = digest::digest(fromJavascript$model),
          data = digest::digest(df)
        )
        session$sendCustomMessage("lav_results", res)
        return(text_res)
      },
      error = function(e) {
        session$sendCustomMessage("lav_failed", "lav_error")
        return(list(error = e))
      },
      warning = function(w) {
        session$sendCustomMessage("lav_failed", "lav_error")
        return(list(warning = w))
      }
    )
    return(out)
  } else {
    session$sendCustomMessage("lav_failed", "lav_error")
    return(text_res)
  }
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
      lavaan_model <- eval(parse(text = lavaan_parse_string))
      model_parsed <- parTable(lavaan_model)
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
        res <- getResults(cacheResult, input$fromJavascript, session, getData())
        forceEstimateUpdate(rnorm(1))
        session$sendCustomMessage("usecache", "")
        to_render(res)
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
      print("watching")
      print(abort_file)
      lavaan_string <- paste0("lavaan(model, data, ", modelJavascript$options)
      print(lavaan_string)
      fut <- promises::future_promise(
        {
          `%get%` <- function(pkg, fun) {
            get(fun,
              envir = asNamespace(pkg),
              inherits = FALSE
            )
          }
          print("watching in promise")
          print(abort_file)
          original_function <- "lavaan" %get% "lav_model_objective"
          original_function_string <- deparse(original_function)
          new_function <- append(original_function_string, "if (file.exists(abort_file)) {quit()}", after = 3)
          new_function <- eval(parse(text = new_function))

          environment(new_function) <- asNamespace("lavaan")
          utils::assignInNamespace("lav_model_objective", new_function, ns = "lavaan")
          eval(parse(text = lavaan_string))
        },
        packages = "lavaan",
        globals = c("data", "abort_file", "model", "lavaan_string"),
        seed = TRUE
      )
      ## sucesses fit
      promises::then(
        fut,
        function(value) {
          fit(value)
          res <- getResults(value, input$fromJavascript, session, getData())
          to_render(res)
          session$sendCustomMessage("lav_sucess", "lav_error")
        }
      )

      ## fail fit
      promises::catch(
        fut,
        function(e) {
          to_render(NULL)
          session$sendCustomMessage("lav_failed", "lav_error")
          to_render(e$message)
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
      print("creating")
      abort_file_global()
      file.create(abort_file_global())
    })

    list(
      to_render = to_render,
      forceEstimateUpdate = forceEstimateUpdate
    )
  })
}
