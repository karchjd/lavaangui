server <- function(input, output, session) { 
  library(lavaan)
  node0 <- rnorm(100)
  node1 <- rnorm(100)
  node2 <- node0 + node1 + rnorm(100)
  the_data <- data.frame(node0 = node0, node1 = node1, node2 = node2)
  
  R_script <- reactive({input$R_script}) 
  
  output$lavaan_syntax_R <- renderPrint({
    if(!is.null(R_script())){
      if(input$run){
        eval(parse(text = R_script()))
        session$sendCustomMessage("lav_results", parameterestimates(result))
        print(parameterestimates(result))
        summary(result)
      }else{
        cat(R_script())
      }
    }
  })
}
