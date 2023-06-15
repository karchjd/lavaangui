# Define the UI
ui <- fluidPage(
  titlePanel("CSV Summary"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File")
    ),
    mainPanel(
      verbatimTextOutput("summary")
    )
  )
)

# Define the server
server <- function(input, output) {
  # Read the CSV file and display summary
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  output$summary <- renderPrint({
    head(data())
  })
}

# Run the application
shinyApp(ui = ui, server = server)