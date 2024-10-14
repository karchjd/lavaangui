#' @import shiny
#' @import lavaan
#' @importFrom igraph graph.edgelist layout.reingold.tilford

start_app <- function(fit = NULL, full, where) {
  ## import model if present
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
      if (full) {
        stop("Multipe group models are currently not supported. But you can plot your model using plot_lavaan")
      }
      df <- NULL
    }
    parTable <- parTable(fit)
    parTable <- parTable[!parTable$op %in% c(":=", "<", ">", "==", "|", "<", ">"), ]
    importedModel <- list(obs = varNames, latent = factNames, parTable = parTable, df = df, fit = fit)
  } else {
    importedModel <- NULL
  }

  ## define server, here because we need to pass model, and full
  lavaan_gui_server <- function(input, output, session) {
    options(shiny.maxRequestSize = 20 * 1024^2)
    
    # reactive vals
    fit <- reactiveVal(NULL)
    forceEstimateUpdate <- reactiveVal()
    to_render <- reactiveVal(help_text)
    
    #check whether running on shinyapps or not
    if (Sys.getenv("SHINY_PORT") == "") {
      shinyapps <- FALSE
    } else {
      shinyapps <- TRUE
    }
    
    ## import model if present, also sends whether we are on shinyapps or not to
    ## frontend
    importRes <- importModel(session, full, importedModel, shinyapps)
    imported <- importRes$imported
    if (imported) {
      if (!full) {
        fit(importRes$fit)
      }
    }

    session$sendCustomMessage("version", message = utils::packageVersion("lavaangui"))

    ## View data
    serverDataViewer("dataViewer", getData)

    ## seems needed but probably can be done better
    observeEvent(input$sendnames, {
      session$sendCustomMessage("columnames", message = input$newnames)
    })

    ## Upload data
    x <- serverDataUploader("dataUpload")
    data_react <- reactive({
      if (isTruthy(x())) {
        return(x())
      } else if (imported) {
        return(importRes$data_react)
      } else {
        return(NULL)
      }
    })

    ## rename data
    getData <- reactive({
      local_data <- data_react()
      if (!is.null(input$newnames$newnames)) {
        names(local_data$df) <- unlist(input$newnames$newnames)
      }
      return(local_data$df)
    })

    ## layout
    serverLayout("layout", fit, full, imported)

    ## main server for running lavaan
    serverLavaanRun("run", to_render, forceEstimateUpdate, getData, fit, shinyapps)

    serverEstimateUpdater("ests", forceEstimateUpdate, fit, to_render)

    serverResultUpdater("res", to_render)

    serverDownloader("down", getData)

    extendResultsServer("extend", fit)

    # showing help leave as is
    observeEvent(input$show_help, {
      to_render(help_text)
    })
  }

  ## start app
  ui_loc <- system.file("www/index.html", package = "lavaangui")
  addResourcePath("assets", system.file("www/assets", package = "lavaangui"))
  app <- shinyApp(
    server = lavaan_gui_server,
    ui = htmlTemplate(ui_loc)
  )
  if (where == "browser") {
    runApp(app, launch.browser = TRUE)
  } else if (where == "heroku") {
    runApp(app, port = as.numeric(Sys.getenv("PORT")), host = "0.0.0.0")
  } else if (where == "gadget") {
    runGadget(app, viewer = dialogViewer("lavaangui", width = 10^3, height = 10^3))
  } else if (where == "shinyapps.io") {
    return(app)
  } else {
    stop("Invalid where argument")
  }
}
