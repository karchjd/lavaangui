server <- function(input, output, session) {
  library(lavaan)
  library(zip)
  library(reader)
  library(tools)
  library(vtable)
  shinyjs::useShinyjs(html = TRUE)
  library(future)
  library(promises)
  library(semPlot)
  library(dplyr)
  plan(multisession)
  library(rvest)
  library(xml2)
  library(base64enc)
  
  
  # normal functions
  create_summary <- function(df){
    sum_table <- paste0(capture.output(sumtable(df, out = "htmlreturn", title = "")), collapse = "")
    remove_string <- "<table class=\"headtab\"> <tr><td style=\"text-align:left\">sumtable {vtable}</td> <td style=\"text-align:right\">Summary Statistics</td></tr></table> <h1>  </h1>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    remove_string <- "<title>Summary Statistics</title>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    sum_table
  }
  
  read_auto <- function(filepath) {
    # Determine file extension
    file_ext <- tools::file_ext(filepath)
    
    # Load appropriate package and read data based on file extension
    switch(file_ext,
           csv = {
             library(readr, quietly = TRUE)
             data <- readr::read_csv(filepath)
           },
           xlsx = {
             library(readxl, quietly = TRUE)
             data <- readxl::read_excel(filepath)
           },
           sav = {
             library(haven, quietly = TRUE)
             data <- haven::read_sav(filepath)
           },
           rds = {
             data <- readRDS(filepath)
           },
           stop("Unsupported or unhandled file format.")
    )
    return(data)
  }
  
  checkVarsInData <- function(model_parsed, data){
    names_model <- lavNames(model_parsed, type = "ov")
    names_data <- names(data)
    var_not_in_data <- !(names_model %in% names_data)
    names(var_not_in_data) <- names_model
    return(var_not_in_data)
  }
  
  checkDataAvail <- function() {
    return(!is.null(getData()))
  }
  
  
  # constants
  help_text <- paste(
    "Command               Action",
    "--------------------------------------------------",
    "Right-Click           Right-Click Anywhere to get an Appropriate Menu",
    "o                     Create Observed Variable at Mouse Location",
    "l                     Create Latent Variable at Mouse Location",
    "c                     Create Constant Variable at Mouse Location",
    "Hold Shift            Draw Undirected Arrows by Connecting Variables With Mouse",
    "Hold CTRL             Draw Directed Arrows by Connect Variables With Mouse",
    "Hold CTRL             Click on Multiple Elements to Select",
    "Hold CTRL             Click on Canvas to Activate Select Box",
    "Backspace             Remove Selected Elements",
    "CTRL+Z                Undo Node Move(s)",
    "CTRL+Y                Undo Node Move(s)",
    "",
    "Mac Users Replace CTRL with CMD",
    sep = "\n"
  )
  class(help_text) <- "help_text"
  print.help_text <- function(helpt_text){
    cat(help_text)
  }
  
  # state vars
  abort_file <- tempfile()
  imported <- FALSE
  
  # import model if present
  if ((!imported) && (exists("model_for_lavaangui_192049124"))) {
    model <- model_for_lavaangui_192049124
    session$sendCustomMessage("imported_model", message = model)
    session$sendCustomMessage("lav_results", model$est)
    imported <- TRUE
    rm(model_for_lavaangui_192049124, envir = .GlobalEnv)
  }
  
  # data upload
  data_content <- reactive({
    if(!is.null(input$fileInput)){
      if (is.null(input$fileInput$content)) {
        data <- list(df = read_auto(input$fileInput$datapath), name = input$fileInput$name)
      } else {
        content <- input$fileInput$content
        decoded <- base64enc::base64decode(content)
        # Read content into a data frame
        data <- list(df = read.csv(textConnection(rawToChar(decoded))), name = "data.csv")
      }
      
      df <- data$df
      data_info <- list(
        name = data$name, columns = colnames(df),
        summary = create_summary(data$df)
      )
      session$sendCustomMessage(type = "dataInfo", message = data_info)
      return(data)  
    }
    else{
      return(NULL)
    }
  })
  
  # renaming data columns
  getData <- reactive({
    local_data <- data_content()
    if (!is.null(input$newnames)) {
      names(local_data$df) <- jsonlite::fromJSON(input$newnames)
    }
    return(local_data$df)
  })
  
  # showing help
  observeEvent(input$show_help,{
    to_render(help_text)}
  )
  
  # layout helper
  observeEvent(input$layout,{
    req(input$layout)
    fromJavascript <- jsonlite::fromJSON(input$layout)
    model <- eval(parse(text = fromJavascript$syntax))
    semPlotModel <- semPlotModel(model)
    semPlotRes <- semPaths(semPlotModel, layout = fromJavascript$name, nCharNodes = 0, nCharEdges = 0, DoNotPlot = TRUE)
    coordinates <- data.frame(name = semPlotModel@Vars$name, x = semPlotRes$layout[,1], y = semPlotRes$layout[,2])
    session$sendCustomMessage("semPlotLayout", coordinates)
  })
  
  # result window
  to_render <- reactiveVal(help_text)
  
  output$lavaan_syntax_R <- renderPrint({
    req(to_render())
    print(to_render())
  })
  
  # needed, for mysterios reasons
  observeEvent(data_content(), {
    
  })
  
  
  # extract results from model
  getResults <- function(result){
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    fromJavascript$fitted_model = NULL
    res <- list(normal = parameterestimates(result), std = standardizedsolution(result), 
                fitted_model = base64enc::base64encode(serialize(result, NULL)), model = digest::digest(fromJavascript$model),
                data = digest::digest(getData()))
    session$sendCustomMessage("lav_results", res)
    sum_model <- summary(result, fit.measures = TRUE, modindices = TRUE)
    sum_model$pe <- NULL
    sum_model
  }
  
  # main part for fitting lavaan
  observeEvent(input$runCounter, {
    ## construct model and send to javascript
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
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
        print(checkDataAvail())
        if(checkDataAvail()){
          data <- getData()
          missing_vars <- checkVarsInData(model_parsed, data)  
          if(!any(missing_vars)){
            ## fit model
            session$sendCustomMessage("fitting", "")
            lavaan_string <- paste0("lavaan(model, data, ", modelJavascript$options)
            fut <- future_promise({
              original_function <- lavaan:::lav_model_objective
              original_function_string <- deparse(original_function)
              new_function <- append(original_function_string, "if (file.exists(abort_file)) {quit()}", after = 3)
              new_function <- eval(parse(text = new_function))
              
              environment(new_function) <- asNamespace('lavaan')
              assignInNamespace("lav_model_objective", new_function, ns = "lavaan")
              eval(parse(text = lavaan_string))
            }, packages = "lavaan", globals = c("data", "abort_file", "model", "lavaan_string"), seed = TRUE)
            prom <- fut %...>% getResults %...>% to_render
            prom <- catch(fut,
                          function(e){
                            to_render(NULL)
                            session$sendCustomMessage("lav_failed", "stopped")
                            to_render("stopped by user")
                            showNotification("Task Stopped")
                          })
            prom <- finally(prom, function(){
              if(file.exists(abort_file)){
                file.remove(abort_file)  
              }
            })
          }else{
            session$sendCustomMessage("missing_vars", names(missing_vars)[missing_vars])
          }
        } else{
          print("send msg")
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
  })
  
  
  # allows uploading
  observeEvent(input$abort,{
    print("abort")
    file.create(abort_file)
  })
  
  ## download stuff, still needed?
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
      write.csv(getData(), csvFile, row.names = FALSE)
      
      # Create a zip archive of the directory containing the JSON and CSV files
      zip::zip(zipfile = file, files = c("model.json", "data.csv"), root = tempDir)
    }
  )
}
