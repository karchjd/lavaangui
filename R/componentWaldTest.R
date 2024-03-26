waldTestUI <- function(id) {
  tabPanel(
    title = "Wald Test",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        br(),
        h5("User-Specified Wald Test"),
        helpText("This field can be used to specify Wald tests based on names of model parameters."),
        helpText("Example:", tags$br(), "par1 == 0", tags$br(), "par2 == 0"),
        textAreaInput(inputId = NS(id, "syntax"), label = NULL, value = "", rows = 5)
      ),
      mainPanel(
        verbatimTextOutput(NS(id, "result"))
      )
    )
  )
}

tabPanel("Wald Test", )


waldTestServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    output$result <- renderPrint({
      if (input$syntax == "") {
        cat("No user-defined Wald test specified")
      } else {
        con <- input$syntax
        wtest <- data.frame(lavaan::lavTestWald(fit(), con)[1:3])
        row.names(wtest) <- "Wald Test"
        names(wtest) <- c("Wald Chi-Square", "df", "p-value")
        print(wtest, digits = 3, print.gap = 3)
      }
    })
  })
}
