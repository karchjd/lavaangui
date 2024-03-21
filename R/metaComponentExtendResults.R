extendResultsUI <- function(id) {
  ns <- NS(id)
  tabsetPanel(
    parameterEstimatesUI(ns("paraEsts")),
    factorScoresUI(ns("factorScores")),
    modificationUI(ns("mod")),
    residualsUI(ns("residuals")),
    waldTestUI(ns("wald")),
    lavInspectUI(ns("inspect")),
  )
}

# Define the overall module server
extendResultsServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    parameterEstimatesServer("paraEsts", fit)
    factorScoresServer("factorScores", fit)
    residualsServer("residuals", fit)
    lavInspectServer("inspect", fit)
    waldTestServer("wald", fit)
    modificationServer("mod", fit)
  })
}
