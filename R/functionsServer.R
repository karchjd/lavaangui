getGroupTable <- function(parTable) {
  parTable$lhs <- paste0(parTable$lhs, ".", parTable$group)
  parTable$rhs <- paste0(parTable$rhs, ".", parTable$group)
  return(parTable)
}


importModel <- function(session, full, importedModel, shinyapps) {
  imported <- FALSE
  session$sendCustomMessage("fullServer", message = list(full = full, shinyapps = shinyapps))

  makeNewVars <- function(vars, groups) {
    allCombs <- expand.grid(vars, groups)
    paste0(allCombs$Var1, ".", allCombs$Var2)
  }

  # import model if present
  if ((!imported) && !(is.null(importedModel))) {
    parTable <- importedModel$parTable
    observed <- importedModel$obs
    latent <- importedModel$latent
    if (lavInspect(importedModel$fit, "ngroups") > 1) {
      parTable <- getGroupTable(parTable)
      groups <- unique(parTable$group)
      observed <- makeNewVars(observed, groups)
      latent <- makeNewVars(latent, groups)
    }
    if (!is.null(importedModel$layout_name)) {
      safe_name <- gsub("[^a-zA-Z0-9_-]", "", importedModel$layout_name)
      layout_filename <- sprintf("layout_%s_%s.json", importedModel$layout_hash, safe_name)
      ## check whether filename exists
      if (file.exists(layout_filename)) {
        saved_layout <- jsonlite::read_json(layout_filename)
      } else {
        saved_layout <- NULL
      }
    } else {
      saved_layout <- NULL
      layout_filename <- NULL
    }

    session$sendCustomMessage("imported_model", message = list(
      parTable = parTable, latent = latent, obs = observed,
      ordered = lavInspect(importedModel$fit, what = "ordered"), layout_hash = importedModel$layout_hash,
      layout_name = importedModel$layout_name, saved_layout = saved_layout, export_filepath = importedModel$export_filepath
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
    return(list(fit = importedModel$fit, data_react = df_full, imported = imported, full = full, layout_filename = layout_filename))
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
  ests$arrow[ests$arrow == "~"] <- "\u2192" # →
  ests$arrow[ests$arrow == "=~"] <- "\u2192" # →
  ests$arrow[ests$arrow == "~~"] <- "\u2194" # ↔
  return(ests)
}
