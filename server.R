server <- function(input, output, session) { 
  library(lavaan)
  
  R_script <- reactive({input$R_script}) 
  
  data <- reactive({
    req(input$fileInput)
    read.csv(input$fileInput$datapath)
  })
  
  counter <- reactive({
    req(input$runCounter)
    input$runCounter
  })
  
  observeEvent(data(), {
    session$sendCustomMessage(type = "columnNames", message = colnames(data()))
    session$sendCustomMessage("fname", input$fileInput$name)
  })
  
  output$lavaan_syntax_R <- renderPrint({
    if(!is.null(R_script())){
      if(input$run){
        data <- data()
        eval(parse(text = R_script()))
        counter <- counter()
        session$sendCustomMessage("lav_results", parameterestimates(result))
        sum_model <- summary(result)
        sum_model$pe <- NULL
        print(sum_model)
      }else{
        cat(R_script())
      }
    }
  })
}
