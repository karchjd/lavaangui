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
    callback <- "
var tips = ['Modification Index (Change in χ²)', 'Expected Parameter Change', 'Expected Parameter Change (Standardizing all Latent Variables)',
            'Expected Parameter Change (Standardizing all Variables)', 'Expected Parameter Change (Standardizing all but Exogenous Observed Variables)'],
    header = table.columns().header();
for (var i = 0; i < tips.length; i++) {
  $(header[i+3]).attr('title', tips[i]);
}
"
    output$table <- DT::renderDataTable(
      custom_dt(modifyResTable(modificationIndices(fit())), input$digits, callback = callback)
    )
  })
}
