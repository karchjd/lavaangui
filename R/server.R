lavaan_gui_server <- function(input, output, session) {
  # settings
  # to send errors to frontend
  op <- options(shiny.error = function() {
    session <- getDefaultReactiveDomain()
    error_message <- geterrmessage()
    session$sendCustomMessage("serverError", list(msg = error_message))
  })
  onStop(function() options(op))


  ## init stuff
  shinyjs::useShinyjs(html = TRUE)
  future::plan(future::multisession)
  `%...>%` <- promises::`%...>%`

  # reactive vals
  fit <- reactiveVal()
  to_render <- reactiveVal(help_text)
  first_run_layout <- reactiveVal(TRUE)


  ## import model if present
  importRes <- importModel(session)
  imported <- importRes$imported
  if (imported) {
    fit(importRes$fit)
    to_render(importRes$to_render)
  }

  ## View data
  serverDataViewer("dataViewer", getData)

  ## TODO: investigate this one
  observeEvent(input$sendnames, {
    session$sendCustomMessage("columnames", message = input$newnames)
  })
  
  ## Upload data
  x <- serverDataUploader("dataUpload")
  data_react <- reactive({
    if(isTruthy(x())){
      return(x())
    }else if(imported){
      return(importRes$data_react)
    }else{
      return(NULL)
    }
  })
  
  ## rename data
  getData <- reactive({
    local_data <- data_react()
    if (!is.null(input$newnames)) {
      names(local_data$df) <- input$newnames
    }
    return(local_data$df)
  })
  
  ## layout
  serverLayout("layout", fit)
  
  
  ## update confidence level
  observeEvent(input$confindence_level, {
    req(fit())
    res <- list(
      normal = parameterestimates(fit(), level = input$confindence_level),
      std = standardizedsolution(fit(), level = input$confindence_level)
    )
    session$sendCustomMessage("lav_estimates", res)
  })
  
  
  ## put this and getTextOut into serverExtractResults
  ## cleanup the functions, there seems to be three functions that
  ## extract results
  
  output$lavaan_syntax_R <- renderPrint({
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



  # extract results from model
  getResults <- function(result) {
    fit <- reactiveVal(result)
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    fromJavascript$fitted_model <- NULL
    text_res <- getTextOut(result)
    if (!text_res$problem) {
      out <- tryCatch(
        {
          res <- list(
            normal = parameterestimates(result, level = input$confindence_level), std = standardizedsolution(result, level = input$confindence_level),
            fitted_model = base64enc::base64encode(serialize(result, NULL)), model = digest::digest(fromJavascript$model),
            data = digest::digest(getData())
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
  
  
  ## put this into runModel module
  checkDataAvail <- function() {
    return(!is.null(getData()))
  }

  # state vars
  abort_file <- NULL
  
  ## main loop
  observeEvent(input$fromJavascript,{
    req(input$fromJavascript)
    ## Mode == "User Model", just send R_script to output
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    if (fromJavascript$mode == "user model") {
      to_render(fromJavascript$model$R_script)
      return(NULL)
    }
    
    ## Mode = "Full Model" or "Estimate", send model
    modelJavascript <- fromJavascript$model
    model <- eval(parse(text = modelJavascript$syntax))
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
      (!checkDataAvail() || fromJavascript$cache$lastFitData == digest::digest(getData()))
    if(cacheValid){
      cacheResult <- unserialize(base64enc::base64decode(fromJavascript$cache$lastFitLavFit))
      res <- getResults(cacheResult)
      session$sendCustomMessage("usecache", "")
      to_render(res)
      return(NULL)
    }
    
    # Data missing, stop
    if(!isTruthy(getData())){
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
    abort_file <<- tempfile()
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
        eval(parse(text = lavaan_string))
      },
      packages = "lavaan",
      globals = c("data", "abort_file", "model", "lavaan_string"),
      seed = TRUE
    )
    prom <- fut %...>% getResults %...>% to_render
    prom <- promises::catch(
      fut,
      function(e) {
        to_render(NULL)
        session$sendCustomMessage("lav_failed", "lav_error")
        to_render(e$message)
      }
    )
    prom <- promises::finally(prom, function() {
      if (file.exists(abort_file)) {
        file.remove(abort_file)
      }
    })
    return(NULL) ## Never ever remove this. This stops the UI from blocking!!!
  })
  
  
  observeEvent(input$abort, {
    file.create(abort_file)
  })

  ## put this into downloadModule
  # Define the download handler function
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("lavaangui-", Sys.Date(), ".zip", sep = "")
    },

    # Define the content of the file
    content = function(file) {
      # Create a temporary directory
      tempDir <- tempdir()

      # Define the names of the JSON and CSV files
      jsonFile <- file.path(tempDir, "model.json")
      csvFile <- file.path(tempDir, "data.csv")


      writeLines(input$model, jsonFile)

      # Write the data frame to the CSV file (replace my_data with your data frame)
      utils::write.csv(getData(), csvFile, row.names = FALSE)

      # Create a zip archive of the directory containing the JSON and CSV files
      zip::zip(zipfile = file, files = c("model.json", "data.csv"), root = tempDir)
    }
  )

  outputOptions(output, "downloadData", suspendWhenHidden = FALSE)
  
  # showing help leave as is
  observeEvent(input$show_help, {
    to_render(help_text)
  })
}
