#' @import shiny
#' @import lavaan
#' @importFrom igraph graph.edgelist layout.reingold.tilford

start_app <- function(fit = NULL, full, where, filename) {
  if (!is.null(fit)) {
    varNames <- lavaanNames(fit, type = "ov")
    factNames <- lavaanNames(fit, type = "lv")
    factNames <- factNames[!factNames %in% varNames]
    if (lavInspect(fit, "ngroups") == 1) {
      df <- tryCatch(
        {
          as.data.frame(lavInspect(fit, what = "data"))
        },
        error = function(e) {
          message("Data not available only importing model")
          return(NULL)
        }
      )
    } else {
      if (!full) {
        stop("Multipe group models are currently not supported. But you can plot your model using plot_interactive")
      }
      df <- NULL
    }
    parTable <- parTable(fit)
    parTable <- parTable[!parTable$op %in% c(":=", "<", ">", "==", "|", "<", ">"), ]
    model <- list(
      obs = varNames, latent = factNames, parTable = parTable, df = df, fit = fit,
      filename = filename, wd = getwd()
    )
    .GlobalEnv$.importedModel128498129481249124891284129 <- model
  } else {
    if (exists(".importedModel128498129481249124891284129", where = .GlobalEnv)) {
      rm(".importedModel128498129481249124891284129", envir = .GlobalEnv)
    }
  }
  .GlobalEnv$.full12849812948124912489128412948 <- full


  ui_loc <- system.file("www/index.html", package = "lavaangui")
  app <- shinyApp(
    server = lavaan_gui_server,
    ui = htmlTemplate(ui_loc)
  )
  if (is.null(filename)) {
    addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
    if (where == "browser") {
      runApp(app, launch.browser = TRUE)
    } else if (where == "heroku") {
      runApp(app, port = as.numeric(Sys.getenv("PORT")), host = "0.0.0.0")
    } else if (where == "gadget") {
      runGadget(app, viewer = dialogViewer("lavaangui", width = 10^3, height = 10^3))
    } else {
      stop("Invalid where argument")
    }
  } else {
    # port <- 3333 # getOption("shiny.port", random_port())
    # run_app <- function(port, app) {
    #   library(lavaangui)
    #   setwd("/Users/karch/work/projects/_current/onyx_jamovi/lavaangui")
    #   shiny::addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
    #   shiny::runApp(app, port = port, launch.browser = FALSE)
    # }
    # print(port)
    # # run_app(port = port, app)
    # process <- callr::r_bg(func = run_app, args = list(port = port, app = app), supervise = TRUE)
    # while (process$is_alive()){
    #   pingr::is_up(destination = host, port = port)
    #   Sys.sleep(0.5)
    # }
    # res <- process$get_result()
    port <- 3339
    
    
    fut <- promises::future_promise({
      addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
      runApp(app, launch.browser = FALSE, port = port)
    }, packages = c("lavaangui", "shiny"), globals = c("port", "app"))
    
    
    ## fail fit
    promises::catch(
      fut,
      function(e) {
        stop(e)
      }
    )
    
    promises::then(
      fut,
      function(value){
        print(value)
      }
    )
    print("hallo")
    
  }

  # seems like this code only runs when the app is closed by stopApp, that is, when exporting to filename
  # writeLines(res, con = filename)
  on.exit(rm(.full12849812948124912489128412948, envir = .GlobalEnv))
  # return(res)
}

random_port <- function(lower = 49152L, upper = 65355L) {
  ports <- seq.int(from = lower, to = upper, by = 1L)
  parallelly::freePort(ports = ports, default = NA_integer_)
}
