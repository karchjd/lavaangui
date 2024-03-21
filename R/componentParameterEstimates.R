parameterEstimatesUI <- function(id) {
  tabPanel(
    title = "Parameter Estimates",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        radioButtons(NS(id, "rawStd"), "Standardized?",
          choices = c(Unstandardized = "raw", Standardized = "std")
        ),
        numericInput(NS(id, "level"), "Confidence level:",
          value = .95, min = 0.01, max = .9999,
          step = 0.01
        ),
        createDigitsInput(id),
      ),
      mainPanel(
        DT::DTOutput(NS(id, "parameterEsts"))
      )
    )
  )
}


parameterEstimatesServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    ests <- reactive({
      if (input$rawStd == "raw") {
        ests <- lavaan::parameterEstimates(fit(), level = input$level)
      } else {
        ests <- lavaan::standardizedSolution(fit(), level = input$level)
      }
      return(ests)
    })

    output$parameterEsts <- DT::renderDataTable({
      req(ests())
      return(custom_dt(ests(), input$digits))
    })
  })
}

tabPanel('Wald Test',
         br(),
         h5("User-Specified Wald Test"),
         helpText('This text can be used to specify an additional (user-specified) Wald test based on names of model parameters.'),
         helpText('Example: par1 == 0 ; par2 == 0'),
         tags$textarea(id="add.syntax.wald", rows=5, cols=40, "")
)
