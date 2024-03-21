factorScoresUI <- function(id) {
  tabPanel(
    title = "Factor Scores",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectizeInput(NS(id, "fsMethod"), "Factor Score Method", "",
          multiple = FALSE, selected = "EBM",
          choices = c(
            "EBM",
            "Bartlett",
            "regression"
          )
        ),
        createDigitsInput(id),
        checkboxInput(NS(id, "addObsered"), "Add observed variables to factor scores table",
          value = TRUE
        ),
      ),
      mainPanel(
        DT::DTOutput(NS(id, "fScores"))
      )
    )
  )
}


factorScoresServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    fScores <- reactive({
      req(fit())
      return(data.frame(lavaan::lavPredict(fit(), method = input$fsMethod)))
    })

    output$fScores <- DT::renderDataTable({
      if (input$addObsered) {
        ydata <- data.frame(lavaan::lavInspect(fit(), "data"))
        names(ydata) <- lavaan::lavNames(fit())
        fs <- cbind(ydata, fScores())
      } else {
        fs <- fScores()
      }
      fsprint <- DT::datatable(format(fs, digits = input$digits), options = list(pageLength = -1, lengthMenu = list(
        c(15, 50, 100, -1),
        c("15", "50", "100", "All")
      )))
      return(fsprint)
    })
  })
}
