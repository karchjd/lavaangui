importModel <- function(session) {
  imported <- FALSE
  if (exists(".importedModel128498129481249124891284129", where = .GlobalEnv)) {
    importedModel <- .GlobalEnv$.importedModel128498129481249124891284129
  }
  full <- .GlobalEnv$.full12849812948124912489128412948
  session$sendCustomMessage("full", message = full)

  # import model if present
  if ((!imported) && (exists("importedModel"))) {
    session$sendCustomMessage("imported_model", message = importedModel[c("parTable", "latent", "obs")])
    to_render <- getTextOut(importedModel$fit)
    df <- importedModel$df
    df_full <- list(df = df, name = "Imported from R")
    propagateData(df_full, session, import = TRUE)
    imported <- TRUE
    session$sendCustomMessage("setToEstimate", message = rnorm(1))
  }
  return(list(fit = importedModel$fit, to_render = to_render, data_react = df_full, imported = imported))
}

propagateData <- function(df, session, import = FALSE) {
  data_info <- list(
    name = df$name, columns = colnames(df$df),
    summary = create_summary(df$df),
    import = import
  )
  session$sendCustomMessage(type = "dataInfo", message = data_info)
}
