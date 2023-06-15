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
    tags$script(src="https://unpkg.com/cytoscape-node-editing@latest"),
    tags$link(href="https://unpkg.com/cytoscape-context-menus@3.0.1/cytoscape-context-menus.css", rel="stylesheet", type="text/css"),
    tags$link(href="style.css", rel="stylesheet", type="text/css"),
    tags$link(href="style_menu.css", rel="stylesheet", type="text/css")
  ),
  useShinyjs(),
  HTML(rawHTML),
  fileInput("fileInput", multiple = FALSE, accept = ".csv", label = NULL),
  tags$script(src="init.js"),
  tags$script(src="io.js"),
  tags$script(src="graphmanipulation.js"),
  tags$script(src="onEvents.js"),
  tags$script(src="context_menus.js"),
  tags$script(src="toolbar.js"),
  tags$script(src="main_menus.js"),
  tags$script(src="R_model_interface.js"),
  tags$script(src="R_data_interface.js")
)