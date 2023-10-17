#' @import shiny
#' @import lavaan
start_app <- function(fit, full, where){
  if(!is.null(fit)){
    pars <- lavaan::parameterEstimates(fit)
    varNames <- lavaan:::lavaanNames(fit, type = "ov")
    factNames <- lavaan:::lavaanNames(fit, type = "lv")
    factNames <- factNames[!factNames %in% varNames]
    assign("importedModel", list(obs = varNames, latent = factNames, parTable = parTable(fit), est = pars), envir = as.environment("package:lavaangui"))  
  }
  assign("full", full, envir = as.environment("package:lavaangui"))
  
  
  ui_loc <- system.file("www/index.html", package = "lavaangui")
  addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
  app <- shinyApp(server = lavaan_gui_server,
           ui = htmlTemplate(ui_loc))
  if(where == "browser"){
    runApp(app, launch.browser = TRUE) 
  }else{
    runGadget(app, viewer = dialogViewer("lavaangui", width = 10^3, height = 10^3))
  }
}

