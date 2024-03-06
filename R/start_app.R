#' @import shiny
#' @import lavaan
start_app <- function(fit = NULL, full, where){
  if(!is.null(fit)){
    pars <- parameterEstimates(fit)
    varNames <- lavaanNames(fit, type = "ov")
    factNames <- lavaanNames(fit, type = "lv")
    factNames <- factNames[!factNames %in% varNames]
    df <- tryCatch({
      as.data.frame(lavInspect(fit, what = "data"))
    }, error = function(e) {
      stop("Could not get data from fit object. Probably you fitted your model with a sample covariance matrix, which is currently not supported")
    })
    model <- list(obs = varNames, latent = factNames, parTable = parTable(fit), normal = pars, std = standardizedSolution(fit), df = df, fit = fit)
    .GlobalEnv$.importedModel128498129481249124891284129 <- model
  }else{
    if (exists(".importedModel128498129481249124891284129", where = .GlobalEnv)) {
      rm(".importedModel128498129481249124891284129", envir = .GlobalEnv)
    }
  }
  .GlobalEnv$.full12849812948124912489128412948 <- full
  
  
  ui_loc <- system.file("www/index.html", package = "lavaangui")
  addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
  app <- shinyApp(server = lavaan_gui_server,
           ui = htmlTemplate(ui_loc))
  if(where == "browser"){
    runApp(app, launch.browser = TRUE) 
  }else if(where == "heroku"){
    runApp(app, port = as.numeric(Sys.getenv('PORT')), host = '0.0.0.0') 
  }
  else if(where == "gadget"){
    runGadget(app, viewer = dialogViewer("lavaangui", width = 10^3, height = 10^3))
  }else{
    stop("Invalid where argument")
  }
  on.exit(rm(.importedModel12849812948124912489128412948,.full12849812948124912489128412948,  envir=.GlobalEnv))
}

