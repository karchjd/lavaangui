residualsUI <- function(id) {
  tabPanel(
    title = "Residuals",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        selectizeInput(NS(id, "type"), "Residual Type", "",
          multiple = FALSE, selected = "cor.bentler",
          choices = c("raw", "cor.bollen", "cor.bentler")
        ),
        createDigitsInput(id),
      ),
      mainPanel(
        tags$h2("Residuals"),
        DT::DTOutput(NS(id, "main")),
        tags$h2("Summary Statistics"),
        DT::DTOutput(NS(id, "summary"))
      )
    )
  )
}

lavaan_residuals <- function(fit, type) {
  x <- lavaan::lavResiduals(fit, type = type, se = TRUE)
  cov_names <- rownames(x$cov)
  n <- length(cov_names)

  all_pairs <- expand.grid(v1 = cov_names, v2 = cov_names, stringsAsFactors = FALSE)
  all_pairs$pair <- ifelse(all_pairs$v1 <= all_pairs$v2,
    paste(all_pairs$v1, "~~", all_pairs$v2),
    paste(all_pairs$v2, "~~", all_pairs$v1)
  )
  all_pairs <- unique(all_pairs[, c("pair", "v1", "v2")])

  for (result_type in c("cov", "cov.se", "cov.z")) {
    mat <- as.matrix(x[[result_type]])
    all_pairs[[result_type]] <- mapply(function(v1, v2) mat[v1, v2], all_pairs$v1, all_pairs$v2)
  }


  res <- data.frame(
    v1 = all_pairs$v1, v2 = all_pairs$v2, cov = all_pairs$cov,
    cov_abs = abs(all_pairs$cov), cov.se = all_pairs$cov.se, cov.z = all_pairs$cov.z
  )
  if (type != "raw") {
    what <- "Correlation"
  } else {
    what <- "Covariance"
  }

  names(res)[names(res) == "v1"] <- "Variable 1"
  names(res)[names(res) == "v2"] <- "Variable 2"
  names(res)[names(res) == "cov"] <- paste0("Residual ", what)
  names(res)[names(res) == "cov_abs"] <- paste0("Absolute Residual ", what)
  names(res)[names(res) == "cov.se"] <- "Standard Error of Residual"
  names(res)[names(res) == "cov.z"] <- "z-value of Residual"
  return(list(res = res, summary = as.data.frame(x$summary)))
}

residualsServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    residuals <- reactive({
      req(fit())
      lavaan_residuals(fit(), input$type)
    })

    output$main <- DT::renderDataTable({
      req(residuals())
      return(custom_dt(residuals()$res, input$digits))
    })

    output$summary <- DT::renderDataTable({
      req(residuals())
      sum <- format(residuals()$summary, digits = input$digits)
      return(sum)
    })
  })
}
