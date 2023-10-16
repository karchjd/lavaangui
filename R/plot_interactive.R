#' @export
plot_interactive <- function(fit) {
  pars <- lavaan::parameterEstimates(fit)
  varNames <- lavaan:::lavaanNames(fit, type = "ov")
  factNames <- lavaan:::lavaanNames(fit, type = "lv")
  factNames <- factNames[!factNames %in% varNames]
  assign("importedModel", list(obs = varNames, latent = factNames, parTable = parTable(fit), est = pars), envir = as.environment("package:lavaangui"))
  start_gui(where = "hihi")
}
