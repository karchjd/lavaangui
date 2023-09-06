server <- function(input, output, session) {
  library(lavaan)
  library(zip)
  library(reader)
  library(tools)
  library(vtable)
  shinyjs::useShinyjs(html = TRUE)
  
  library(rvest)
  library(xml2)
  
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
    
    data_info <- list(name = data$name, columns = colnames(df),
                      summary = create_summary(data$df))
    cat(data_info$summary, file = stderr())
    session$sendCustomMessage(type = "dataInfo", message = data_info)
    return(data)
    })
  
  observeEvent(data_content(), {
    
  })
               
  data <- reactive({
    local_data = data();
    if(!is.null(input$newnames)){
      names(local_data$df) <- input$newnames;
    }
    return(local_data)
  })

  
  ## run lavaan, send results to javascript, show results output windows
  output$lavaan_syntax_R <- renderPrint({
    req(input$fromJavascript)
    counter <- counter() #to invalidate cache
    
    ## construct model and send to javascript
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    model <- eval(parse(text = fromJavascript$syntax))
    lavaan_parse_string <- paste0("lavaan(model, ", fromJavascript$options)
    lavaan_model <- eval(parse(text = lavaan_parse_string))
    model_parsed <- parTable(lavaan_model)
    session$sendCustomMessage("lav_model", model_parsed)
    
    ## obtain estimates and send to javascript
    if(fromJavascript$mode == 2){
      data <- data()$df
      lavaan_string <- paste0("lavaan(model, data, ", fromJavascript$options)
      # Capture warnings using tryCatch
      result <- tryCatch(
        {
          eval(parse(text = lavaan_string))
        },
        warning = function(w) {
          # Print the warnings
          print(paste("Warning:", w))
        },
        error = function(e) {
          # Print the errors
          print(paste("Error:", e))
        }
      )
      
      # Check if there were no errors
      if (inherits(result, "lavaan")) {
        session$sendCustomMessage("lav_results", parameterestimates(result))
        sum_model <- summary(result, fit.measures = TRUE)
        sum_model$pe <- NULL
        #sum_model
        partable(result)
      }
      
    }
    else{
      model_parsed
    }
  }
  )
  
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
  
  
  counter <- reactive({
    req(input$runCounter)
    input$runCounter
  })
}
