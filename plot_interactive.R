plot_interactive <- function(fit) {
  pars <- lavaan::parameterEstimates(fit)
  varNames <- lavaan:::lavaanNames(fit, type = "ov")
  factNames <- lavaan:::lavaanNames(fit, type = "lv")
  factNames <- factNames[!factNames %in% varNames]
  model_for_lavaangui_192049124 <<- list(obs = varNames, latent = factNames, parTable = parTable(fit), est = pars)
  shiny::runApp(launch.browser = TRUE)
}
