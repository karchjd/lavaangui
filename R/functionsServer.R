getGroupTable <- function(parTable) {
  parTable$lhs <- paste0(parTable$lhs, ".", parTable$group)
  parTable$rhs <- paste0(parTable$rhs, ".", parTable$group)
  return(parTable)
}


importModel <- function(session) {
  imported <- FALSE
  if (exists(".importedModel128498129481249124891284129", where = .GlobalEnv)) {
    importedModel <- .GlobalEnv$.importedModel128498129481249124891284129
  }
  full <- .GlobalEnv$.full12849812948124912489128412948
  session$sendCustomMessage("full", message = full)

  makeNewVars <- function(vars, groups) {
    allCombs <- expand.grid(vars, groups)
    paste0(allCombs$Var1, ".", allCombs$Var2)
  }
  # import model if present
  if ((!imported) && (exists("importedModel"))) {
    parTable <- importedModel$parTable
    observed <- importedModel$obs
    latent <- importedModel$latent
    if (lavInspect(importedModel$fit, "ngroups") > 1) {
      parTable <- getGroupTable(parTable)
      groups <- unique(parTable$group)
      observed <- makeNewVars(observed, groups)
      latent <- makeNewVars(latent, groups)
    }
    session$sendCustomMessage("imported_model", message = list(
      parTable = parTable, latent = latent, obs = observed,
      ordered = lavInspect(importedModel$fit, what = "ordered")
    ))
    if (!is.null(importedModel$df)) {
      df_full <- list(df = importedModel$df, name = "Imported from R")
      propagateData(df_full, session, showData = FALSE)
    } else {
      df_full <- NULL
    }
    imported <- TRUE
    if (!full) {
      session$sendCustomMessage("setToEstimate", message = stats::rnorm(1))
    }
    return(list(fit = importedModel$fit, data_react = df_full, imported = imported, full = full))
  } else {
    return(list(imported = imported))
  }
}

propagateData <- function(df, session, showData = FALSE) {
  data_info <- list(
    name = df$name, columns = colnames(df$df),
    showData = showData
  )
  session$sendCustomMessage(type = "dataInfo", message = data_info)
}


modifyResTable <- function(ests) {
  names(ests)[names(ests) == "lhs"] <- "source"
  names(ests)[names(ests) == "op"] <- "arrow"
  names(ests)[names(ests) == "rhs"] <- "target"
  ests$arrow[ests$arrow == "~"] <- "\u2192" #→
  ests$arrow[ests$arrow == "=~"] <- "\u2192" #→
  ests$arrow[ests$arrow == "~~"] <- "\u2194" #↔
  return(ests)
}
