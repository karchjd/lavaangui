server <- function(input, output, session) {
  library(lavaan)
  library(zip)
  library(reader)
  library(tools)
  library(vtable)
  shinyjs::useShinyjs(html = TRUE)
  
  library(rvest)
  library(xml2)
  abort_file <- tempfile()
  
  create_summary <- function(df){
    sum_table <- paste0(capture.output(sumtable(df, out = "htmlreturn", title = "")), collapse = "")
    remove_string <- "<table class=\"headtab\"> <tr><td style=\"text-align:left\">sumtable {vtable}</td> <td style=\"text-align:right\">Summary Statistics</td></tr></table> <h1>  </h1>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    remove_string <- "<title>Summary Statistics</title>"
    sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
    sum_table
  }
  
  
  imported <- FALSE
  if ((!imported) && (exists("model"))) {
    session$sendCustomMessage("model", message = model)
    imported <- TRUE
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
    partable(result)
    #sum_model <- summary(result, fit.measures = TRUE)
    # sum_model$pe <- NULL
  }
  
  observeEvent(input$runCounter, {
    cat("running", file = stderr())
    ## construct model and send to javascript
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    model <- eval(parse(text = fromJavascript$syntax))
    lavaan_parse_string <- paste0("lavaan(model, ", fromJavascript$options)
    lavaan_model <- eval(parse(text = lavaan_parse_string))
    model_parsed <- parTable(lavaan_model)
    session$sendCustomMessage("lav_model", model_parsed)
    
    ## obtain estimates and send to javascript
    if (fromJavascript$mode == 2) {
      data <- data()$df
      lavaan_string <- paste0("lavaan(model, data, ", fromJavascript$options)
      
      fut <- future_promise({
        original_function <- lavaan:::lav_model_objective
        original_function_string <- deparse(original_function)
        new_function <- append(original_function_string, "print(\"eval\")", after = 3) 
        new_function <- append(new_function, "if (file.exists(abort_file)) {print(\"checking\"); quit()}", after = 4)
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
      to_render(model_parsed)
    }
    NULL
  })
  
  
  ## run lavaan, send results to javascript, show results output windows
  output$lavaan_syntax_R <- renderPrint({
    req(to_render())
    to_render()
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
