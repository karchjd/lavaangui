modificationUI <- function(id) {

  tabPanel(
    title = "Modification indices",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        createDigitsInput(id),
      ),
      mainPanel(
        DT::DTOutput(NS(id, "table"))
      )
    )
  )
}

modificationServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    output$table <- DT::renderDataTable(
      custom_dt(modificationIndices(fit()), input$digits)
    )
  })
}
