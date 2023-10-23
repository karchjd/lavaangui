create_summary <- function(df){
  sum_table <- paste0(capture.output(vtable::sumtable(df, out = "htmlreturn", title = "")), collapse = "")
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
           library(readr, quietly = TRUE)
           data <- readr::read_csv(filepath)
         },
         xlsx = {
           library(readxl, quietly = TRUE)
           data <- readxl::read_excel(filepath)
         },
         sav = {
           library(haven, quietly = TRUE)
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
  sum_model <- summary(result, fit.measures = TRUE, modindices = TRUE)
  sum_model$pe <- NULL
  return(sum_model)
}
