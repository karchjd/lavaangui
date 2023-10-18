#' @import shiny
#' @import lavaan
start_app <- function(fit, full, where){
  if(!is.null(fit)){
    pars <- parameterEstimates(fit)
    varNames <- lavaanNames(fit, type = "ov")
    factNames <- lavaanNames(fit, type = "lv")
    factNames <- factNames[!factNames %in% varNames]
    df <- as.data.frame(lavInspect(fit, what = "data"))
    assign("importedModel", list(obs = varNames, latent = factNames, parTable = parTable(fit), normal = pars, std = standardizedSolution(fit), df = df), envir = as.environment("package:lavaangui"))  
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

