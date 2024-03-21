testStats <- list(
    "Standard" = "standard",
    "Browne Residual ADF Theory" = "Browne.residual.adf",
    "Browne Residual Normal Theory" = "Browne.residual.nt",
    "Satorra-Bentler" = "Satorra.Bentler",
    "Yuan-Bentler" = "Yuan.Bentler",
    "Mean-variance Adjusted" = "mean.var.adjusted",
    "Satterthwaite" = "Satterthwaite",
    "Scaled-Shifted" = "scaled.shifted",
    "Bootstrap" = "bootstrap",
    "Bollen-Stine" = "Bollen.Stine"
)


exactTestUI <- function(id) {
    ns <- NS(id)
    tabPanel( # nolint: indentation_linter.
        title = "Exact Test",
        sidebarLayout(
            sidebarPanel(
                width = 2,
                h3("Test of exact fit"),
                selectInput(ns("test"), "Test Statistic",
                    choices = testStats,
                    selected = "standard",
                    multiple = TRUE
                ),
            ),
            mainPanel(
                verbatimTextOutput(NS(id, "result"))
            )
        )
    )
}

exactTestServer <- function(id, fit) {
    moduleServer(id, function(input, output, session) {
        output$result <- renderPrint({
            req(input$test)
            cat(paste0(capture.output(lavaan::lavTest(fit(),
                test = input$test, output = "text"
            )), collapse = "\n"))
        })
    })
}

# ui <- fluidPage(
#     exactTestUI("exact")
# )
#
#
# server <- function(input, output, session) {
#     fit <- reactiveVal()
#     HS.model <- " visual  =~ x1 + x2 + x3
#               textual =~ x4 + x5 + x6
#               speed   =~ x7 + x8 + x9 "
#     fit_local <- cfa(HS.model, data = HolzingerSwineford1939)
#     fit(fit_local)
#     exactTestServer("exact", fit)
# }
#
# shinyApp(ui = ui, server = server)
