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
  abort_file <- tempfile()
  last_model <- NULL
  
  create_summary <- function(df){
    sum_table <- paste0(capture.output(sumtable(df, out = "htmlreturn", title = "")), collapse = "")
    remove_string <- "<table class=\"headtab\"> <tr><td style=\"text-align:left\">sumtable {vtable}</td> <td style=\"text-align:right\">Summary Statistics</td></tr></table> <h1>  </h1>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    remove_string <- "<title>Summary Statistics</title>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    sum_table
  }
  
  
  imported <- FALSE
  if ((!imported) && (exists("model_for_lavaangui_192049124"))) {
    model <- model_for_lavaangui_192049124
    session$sendCustomMessage("imported_model", message = model)
    session$sendCustomMessage("lav_results", model$est)
    imported <- TRUE
    rm(model_for_lavaangui_192049124, envir = .GlobalEnv)
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
  
  
  
  data_content <- reactive({
    req(input$fileInput)
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
  })
  
  observeEvent(data_content(), {
    
  })
  
  data <- reactive({
    local_data <- data_content()
    if (!is.null(input$newnames)) {
      names(local_data$df) <- jsonlite::fromJSON(input$newnames)
    }
    return(local_data)
  })
  
  to_render <- reactiveVal()
  
  getResults <- function(result){
    session$sendCustomMessage("lav_results", parameterestimates(result))
    sum_model <- summary(result, fit.measures = TRUE, modindices = TRUE)
    sum_model$pe <- NULL
    last_model <<- result
    sum_model
  }
  
  observeEvent(input$layout,{
    req(input$layout)
    fromJavascript <- jsonlite::fromJSON(input$layout)
    model <- eval(parse(text = fromJavascript$syntax))
    semPlotModel <- semPlotModel(model)
    semPlotRes <- semPaths(semPlotModel, layout = fromJavascript$name, nCharNodes = 0, nCharEdges = 0, DoNotPlot = TRUE)
    coordinates <- data.frame(name = semPlotModel@Vars$name, x = semPlotRes$layout[,1], y = semPlotRes$layout[,2])
    session$sendCustomMessage("semPlotLayout", coordinates)
  })
  
  observeEvent(input$runCounter, {
    ## construct model and send to javascript
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    model <- eval(parse(text = fromJavascript$syntax))
    lavaan_parse_string <- paste0("lavaan(model, ", fromJavascript$options)
    lavaan_model <- eval(parse(text = lavaan_parse_string))
    model_parsed <- parTable(lavaan_model)
    session$sendCustomMessage("lav_model", model_parsed)
    print(last_model)
    if(!is.null(last_model)){
      last_model_parsed <- select(parTable(last_model), id:plabel)  
    }else{
      last_model_parsed <- NULL 
    }
    
    print(identical(select(model_parsed, id:plabel), last_model_parsed))
    
    ## obtain estimates and send to javascript
    if (fromJavascript$mode == "estimate" && !identical(model_parsed, last_model_parsed)) {
      data <- data()$df
      lavaan_string <- paste0("lavaan(model, data, ", fromJavascript$options)
      
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
    }else if (fromJavascript$mode == "full model"){
      to_render(model_parsed)
    }else if (fromJavascript$mode == "estimate" && !identical(model_parsed, last_model_parsed)){
      print("reusing cached results")
      getResults(last_model)
    }
    NULL
  })
  
  
  ## run lavaan, send results to javascript, show results output windows
  output$lavaan_syntax_R <- renderPrint({
    req(to_render())
    print(to_render())
  })
  
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
      write.csv(data()$df, csvFile, row.names = FALSE)
      
      # Create a zip archive of the directory containing the JSON and CSV files
      zip::zip(zipfile = file, files = c("model.json", "data.csv"), root = tempDir)
    }
  )
}
