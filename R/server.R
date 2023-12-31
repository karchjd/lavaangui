lavaan_gui_server <- function(input, output, session) {
  if(exists(".importedModel128498129481249124891284129", where = .GlobalEnv)){
    importedModel <- .GlobalEnv$.importedModel128498129481249124891284129
  }
  full <- .GlobalEnv$.full12849812948124912489128412948 
  
  ## init stuff
  shinyjs::useShinyjs(html = TRUE)
  future::plan(future::multisession)
  `%...>%` <- promises::`%...>%`
  
  checkDataAvail <- function() {
    return(!is.null(getData()))
  }
  
  # state vars
  abort_file <- NULL
  imported <- FALSE
  to_render <- reactiveVal(help_text)
  first_run_layout <- reactiveVal(TRUE)
  
  #set state of front-end to full or reduced
  session$sendCustomMessage("full", message = full)
  data_react <- reactiveVal()
  
  #to send errors to frontend
  op <- options(shiny.error = function() {
    session <- getDefaultReactiveDomain()
    error_message <- geterrmessage()
    session$sendCustomMessage("serverError", list(msg=error_message))
  })

  onStop(function() options(op))
  
  
  propagateData <- function(df){
    data_info <- list(
      name = df$name, columns = colnames(df$df),
      summary = create_summary(df$df)
    )
    session$sendCustomMessage(type = "dataInfo", message = data_info)
  }
  
  # import model if present
  if ((!imported) && (exists("importedModel"))) {
    session$sendCustomMessage("imported_model", message = importedModel[c("parTable", "latent", "obs")])
    session$sendCustomMessage("lav_results", importedModel[c("normal", "std")])
    to_render(getTextOut(importedModel$fit))
    df <- importedModel$df
    df_full <- list(df = df, name = "Imported from R")
    propagateData(df_full)
    data_react(df_full)
    imported <- TRUE
  }
  
  # data upload
  data_content <- observeEvent(input$fileInput,{
    req(input$fileInput)
    if (is.null(input$fileInput$content)) {
      data <- list(df = read_auto(input$fileInput$datapath), name = input$fileInput$name)
    } else {
      content <- input$fileInput$content
      decoded <- base64enc::base64decode(content)
      data <- list(df = readr::read_csv(decoded), name = "data.csv")
    }
    data_react(data)
    propagateData(data)
  })
  
  # renaming data columns
  getData <- reactive({
    local_data <- data_react()
    if (!is.null(input$newnames)) {
      names(local_data$df) <- jsonlite::fromJSON(input$newnames)
    }
    return(local_data$df)
  })
  
  # showing help
  observeEvent(input$show_help,{
    to_render(rep(help_text, 10))}
  )
  # layout helper
  observeEvent(input$layout,{
    req(input$layout)
    fromJavascript <- jsonlite::fromJSON(input$layout)
    if(imported && first_run_layout()){
      semPlotModel <- semPlot::semPlotModel(importedModel$fit)
      first_run_layout(FALSE)
    }else{
      model <- eval(parse(text = fromJavascript$model$syntax))
      semPlotModel <- semPlot::semPlotModel(model)  
    }
    
    semPlotRes <- semPlot::semPaths(semPlotModel, 
                                    layout = fromJavascript$name, 
                                    nCharNodes = 0, nCharEdges = 0, 
                                    DoNotPlot = TRUE, reorder = TRUE)
    coordinates <- data.frame(name = semPlotModel@Vars$name, x = semPlotRes$layout[,1],
                              y = semPlotRes$layout[,2])
    session$sendCustomMessage("semPlotLayout", coordinates)
  })
  
  # result window
  
  output$lavaan_syntax_R <- renderPrint({
    req(to_render())
    ## for user model
    if(is.character(to_render())){
      cat(to_render())
    }else if(any(class(to_render()) == "lavaan.data.frame")){
      print(to_render())
    }else{
      out <- to_render()
      if(!is.null(out$warning)){
        cat("Could not get results because of the following lavaan warning.\nProbably your model is not identified\n")
        cat(out$warning$message)
      }
      if(!is.null(out$error)){
        cat("Could not get results because of the following lavaan error.\nProbably your model is not identified\n")
        print(out$error$message)
      }
      if(!is.null(out$summary)){
        print(out$summary)   
      }
    }
  })
  
  # extract results from model
  getResults <- function(result){
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    fromJavascript$fitted_model = NULL
    text_res <- getTextOut(result)
    if(!text_res$problem){
      out <- tryCatch({
        res <- list(normal = parameterestimates(result), std = standardizedsolution(result), 
                    fitted_model = base64enc::base64encode(serialize(result, NULL)), model = digest::digest(fromJavascript$model),
                    data = digest::digest(getData()))
        session$sendCustomMessage("lav_results", res) 
        return(text_res)
      }, error = function(e) {
        session$sendCustomMessage("lav_failed", "lav_error")  
        return(list(error=e))
      }, warning = function(w) {
        session$sendCustomMessage("lav_failed", "lav_error")  
        return(list(warning=w))
      })
      return(out)
    }else{
      return(text_res)
      session$sendCustomMessage("lav_failed", "lav_error")  
    }
  }
  
  # main functions for fitting lavaan
  observeEvent(input$runCounter, {
    req(input$runCounter)
    ## construct model and send to javascript
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    if(fromJavascript$mode == "user model"){
      to_render(fromJavascript$syntax)
      return(NULL)
    }
    modelJavascript <- fromJavascript$model
    model <- eval(parse(text = modelJavascript$syntax))
    lavaan_parse_string <- paste0("lavaan(model, ", modelJavascript$options)
    lavaan_model <- eval(parse(text = lavaan_parse_string))
    model_parsed <- parTable(lavaan_model)
    session$sendCustomMessage("lav_model", model_parsed)
    
    if (fromJavascript$mode == "full model"){
      to_render(model_parsed)
    }else if(fromJavascript$mode == "estimate"){
      # Check if the cache is valid. The cache is considered valid if:
      # 1) There is a previously fitted model stored in cache
      # 2) The cached model matches with the current model.
      # 3) Either there is no current data, or if there is, it matches the cached data.
      cacheValid =  !is.null(fromJavascript$cache$lastFitModel) && 
        fromJavascript$cache$lastFitModel == digest::digest(fromJavascript$model) &&
        (!checkDataAvail() || fromJavascript$cache$lastFitData == digest::digest(getData()))
      if(!cacheValid){
        if(checkDataAvail()){
          data <- getData()
          missing_vars <- checkVarsInData(model_parsed, data)  
          if(!any(missing_vars)){
            ## fit model
            session$sendCustomMessage("fitting", "")
            abort_file <<- tempfile()
            lavaan_string <- paste0("lavaan(model, data, ", modelJavascript$options)
            fut <- promises::future_promise({
              `%get%` = function(pkg, fun) get(fun, envir = asNamespace(pkg),
                                               inherits = FALSE)
              original_function <- 'lavaan'%get%'lav_model_objective'
              original_function_string <- deparse(original_function)
              new_function <- append(original_function_string, "if (file.exists(abort_file)) {quit()}", after = 3)
              new_function <- eval(parse(text = new_function))
              
              environment(new_function) <- asNamespace('lavaan')
              utils::assignInNamespace("lav_model_objective", new_function, ns = "lavaan")
              eval(parse(text = lavaan_string))
            }, packages = "lavaan", globals = c("data", "abort_file", "model", "lavaan_string"), seed = TRUE)
            prom <- fut %...>% getResults %...>% to_render
            prom <- promises::catch(fut,
                                    function(e){
                                      to_render(NULL)
                                      session$sendCustomMessage("lav_failed", "lav_error")
                                      to_render("stopped by user")
                                    })
            prom <- promises::finally(prom, function(){
              if(file.exists(abort_file)){
                file.remove(abort_file)  
              }
            })
          }else{
            session$sendCustomMessage("missing_vars", names(missing_vars)[missing_vars])
          }
        } else{
          session$sendCustomMessage("data_missing", 1)
        }
      }else{
        # return cached results
        cacheResult <- unserialize(base64enc::base64decode(fromJavascript$cache$lastFitLavFit))
        res <- getResults(cacheResult)
        session$sendCustomMessage("usecache", "")
        to_render(res)
      }
    }
    return(NULL) ## Never ever remove this. This stops the UI from blocking!!!
  })
  
  
  observeEvent(input$abort,{
    file.create(abort_file)
  })
  
  ## download stuff, still needed
  observe({
    req(input$triggerDownload)
    # Start the download
    shinyjs::click("downloadData")
  })
  
  
  
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
}
