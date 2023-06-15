server <- function(input, output, session) { 
  library(lavaan)
  node0 <- rnorm(100)
  node1 <- rnorm(100)
  node2 <- node0 + node1 + rnorm(100)
  the_data <- data.frame(node0 = node0, node1 = node1, node2 = node2)
  
  R_script <- reactive({input$R_script}) 
  data <- reactive({
    req(input$fileInput)
    read.csv(input$fileInput$datapath)
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
        session$sendCustomMessage("lav_results", parameterestimates(result))
        fitMeasures(fit)
      }else{
        cat(R_script())
      }
    }
  })
}
