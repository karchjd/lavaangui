server <- function(input, output, session) {
  library(lavaan)
  library(zip)
  shinyjs::useShinyjs(html = TRUE)
  
  imported <- FALSE
  if ((!imported) && (exists("model"))) {
    session$sendCustomMessage("model", message = model)
    imported <- TRUE
  }
  
  data <- reactive({
    req(input$fileInput)
    if (is.null(input$fileInput$content)) {
      list(df = read.csv(input$fileInput$datapath), name = input$fileInput$name)
    } else {
      content <- input$fileInput$content
      decoded <- base64enc::base64decode(content)
      # Read content into a data frame
      list(df = read.csv(textConnection(rawToChar(decoded))), name = "data.csv")
    }
  })
  
  observeEvent(data(), {
    df <- data()
    session$sendCustomMessage(type = "columnNames", message = colnames(df$df))
    session$sendCustomMessage("fname", message = df$name)
  })
  
  output$lavaan_syntax_R <- renderPrint({
    req(input$fromJavascript)
    counter <- counter() #to invalidate cache
    fromJavascript <- jsonlite::fromJSON(input$fromJavascript)
    data <- data()$df
    model <- eval(parse(text = fromJavascript$syntax))
    lavaanify_string <- paste0("lavaanify(model, ", fromJavascript$options)
    model_parsed <- eval(parse(text = lavaanify_string))
    session$sendCustomMessage("lav_model", model_parsed)
    
    if(fromJavascript$mode == 2){
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
  }
  )
  
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
