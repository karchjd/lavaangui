create_summary <- function(df){
  sum_table <- paste0(utils::capture.output(vtable::sumtable(df, out = "htmlreturn", title = "")), collapse = "")
  remove_string <- "<table class=\"headtab\"> <tr><td style=\"text-align:left\">sumtable {vtable}</td> <td style=\"text-align:right\">Summary Statistics</td></tr></table> <h1>  </h1>"
  sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
  remove_string <- "<title>Summary Statistics</title>"
  sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
  sum_table
}

read_auto <- function(filepath) {
  # Determine file extension
  file_ext <- tools::file_ext(filepath)
  
  # Load appropriate package and read data based on file extension
  switch(file_ext,
         csv = {
           data <- readr::read_csv(filepath)
         },
         xlsx = {
           data <- readxl::read_excel(filepath)
         },
         sav = {
           data <- haven::read_sav(filepath)
         },
         rds = {
           data <- readRDS(filepath)
         },
         stop("Unsupported or unhandled file format.")
  )
  return(data)
}

checkVarsInData <- function(model_parsed, data){
  names_model <- lavNames(model_parsed, type = "ov")
  names_data <- names(data)
  var_not_in_data <- !(names_model %in% names_data)
  names(var_not_in_data) <- names_model
  return(var_not_in_data)
}

getTextOut <- function(result){
  
  # Initialize empty lists to hold errors and warnings
  errors <- NULL
  warnings <- NULL
  
  output <- withCallingHandlers({
    tryCatch({
      sum_model <- summary(result, fit.measures = TRUE, modindices = TRUE)
      sum_model$pe <- NULL
      sum_model
    }, error = function(e) {
      return(NULL)
    })
  },
  warning = function(w) {
    # Capture warning
    warnings <<- w
  },
  error = function(e) {
    # Capture error
    errors <<- e
  })
  problem <- !is.null(warnings) || !is.null(errors)
  return(list(summary = output, errors = errors, warnings = warnings, problem = problem))
}
