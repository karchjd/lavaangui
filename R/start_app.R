#' @import shiny
#' @import lavaan
#' @importFrom igraph graph.edgelist layout.reingold.tilford
#'

start_app <- function(fit = NULL, full, where, layout, export_filepath, scale) {
  if (full && !is.null(layout)) {
    stop("layout can only be provided when full = FALSE")
  }
  if (!is.null(export_filepath) && full) {
    stop("export can only be TRUE when full = FALSE")
  }
  ## import model if present
  if (!is.null(fit)) {
    varNames <- getOVNames(fit)
    factNames <- getLVNames(fit)
    factNames <- factNames[!factNames %in% varNames]
    ## temporary fix until lavaanNames(fit, type = "lv.formative") works again
    parTab <- getParTable(fit)
    compositeNames <- unique(parTab$lhs[parTab$op == "<~"])
    group_equal <- getGroupEqual(fit)
    group_partial <- getGroupPartial(fit)
    df <- tryCatch(
      getImportedData(fit),
      error = function(e) {
        message("Data not available; only importing model: ", conditionMessage(e))
        NULL
      }
    )
    if (!full && !is.null(layout)) {
      paraS <- myParameterEstimates(fit)
      layout_hash <- digest::digest(paraS)
    } else {
      layout_hash <- NULL
    }
    parTable <- getParTable(fit)
    if (
      length(group_equal) > 0L &&
        all(c("label", "plabel") %in% names(parTable))
    ) {
      auto_group_labels <- nzchar(parTable$label) &
        parTable$label == parTable$plabel
      parTable$label[auto_group_labels] <- ""
    }
    parTable <- parTable[!parTable$op %in% c(":=", "<", ">", "==", "|"), ]
    importedModel <- list(
      obs = varNames, latent = factNames, parTable = parTable,
      composite = compositeNames,
      group_variable = getGroupVariable(fit),
      group_labels = getGroupLabels(fit),
      group_equal = group_equal,
      group_partial = group_partial,
      df = df, fit = fit,
      layout_hash = layout_hash,
      layout_name = layout,
      export_filepath = export_filepath,
      scale = scale
    )
  } else {
    importedModel <- NULL
  }

  ## define server, here because we need to things from start_app
  ## this seems to be the only way :(
  lavaan_gui_server <- function(input, output, session) {
    options(shiny.maxRequestSize = 20 * 1024^2)

    # reactive vals
    fit <- reactiveVal(NULL)
    analysisState <- reactiveVal(list(
      currentModelHash = NULL,
      currentDataHash = NULL,
      fittedModelHash = NULL,
      fittedDataHash = NULL,
      details = NULL
    ))
    forceEstimateUpdate <- reactiveVal()
    to_render <- reactiveVal(help_text)

    # check whether running on shinyapps or not
    if (Sys.getenv("SHINY_PORT") == "") {
      shinyapps <- FALSE
    } else {
      shinyapps <- TRUE
    }

    ## import model if present, also sends whether we are on shinyapps or not to
    ## frontend
    importRes <- importModel(session, full, importedModel, shinyapps)
    imported <- importRes$imported
    if (imported && !full) {
      fit(importRes$fit)
    }

    session$sendCustomMessage("version", message = utils::packageVersion("lavaangui"))
    session$sendCustomMessage("lavVersion", message = utils::packageVersion("lavaan"))

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
    serverLavaanRun(
      "run", to_render, forceEstimateUpdate, getData, fit,
      analysisState
    )

    ## Store fitted models for later comparison
    serverModelStore("modelStore", fit, analysisState)

    serverEstimateUpdater("ests", forceEstimateUpdate, fit, to_render, full)

    serverResultUpdater("res", to_render)

    serverDownloader("down", getData)

    extendResultsServer("extend", fit)

    serverUserLayoutSaver("layout_saver", !is.null(importedModel$export_filepath))

    serverImageExporter("export")

    # if (where != "shinyapps.io") {
    #   session$onSessionEnded(function() {
    #     stopApp()
    #   })
    # }

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
  } else if (where == "gadget") {
    runGadget(app, viewer = dialogViewer("lavaangui", width = 10^3, height = 10^3))
  } else if (where == "shinyapps.io") {
    return(app)
  } else {
    stop("Invalid where argument")
  }
}
