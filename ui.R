library(shiny)
library(shinyjs)

rawHTML <- paste(readLines("main.html"), collapse="\n")

ui <- fluidPage(
  tags$head(
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.20/lodash.min.js"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.9/cytoscape.min.js"),
    tags$script(src="https://cdn.rawgit.com/cytoscape/cytoscape.js-edgehandles/master/cytoscape-edgehandles.js"),
    tags$script(src="https://cdn.rawgit.com/konvajs/konva/1.6.3/konva.min.js"),
    tags$script(src="https://unpkg.com/cytoscape-context-menus@3.0.1"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.5.0/jszip.min.js"),
    tags$script(src="https://unpkg.com/dagre@0.8.2/dist/dagre.min.js"),
    tags$script(src="https://cdnjs.cloudflare.com/ajax/libs/bootbox.js/5.5.3/bootbox.min.js"),
    tags$script(src="cytoscape-dagre.js"),
    tags$link(href="https://unpkg.com/cytoscape-context-menus@3.0.1/cytoscape-context-menus.css", rel="stylesheet", type="text/css"),
    tags$link(href="styleContextMenus.css", rel="stylesheet", type="text/css"),
    tags$link(href="styleMainMenu.css", rel="stylesheet", type="text/css"),
    tags$link(href="styleMainWindows.css", rel="stylesheet", type="text/css"),
    tags$link(href="styleToolbar.css", rel="stylesheet", type="text/css"),
  ),
  useShinyjs(),
  shinyFeedback::useShinyFeedback(),
  HTML(rawHTML),
  fileInput("fileInput", multiple = FALSE, accept = ".csv", label = NULL),
  downloadButton("downloadData", "Download Model and Data"),
  tags$script(src="init.js"),
  tags$script(src="io.js"),
  tags$script(src="appState.js"),
  tags$script(src="graphManipulation.js"),
  tags$script(src="onEvents.js"),
  tags$script(src="contextMenus.js"),
  tags$script(src="toolbar.js"),
  tags$script(src="mainMenus.js"),
  tags$script(src="RModelInterface.js"),
  tags$script(src="RDataInterface.js")
)