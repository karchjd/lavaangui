create_summary <- function(df) {
  sum_table <- paste0(utils::capture.output(vtable::sumtable(df, out = "htmlreturn", title = "")), collapse = "")
  remove_string <- "<table class=\"headtab\"> <tr><td style=\"text-align:left\">sumtable {vtable}</td> <td style=\"text-align:right\">Summary Statistics</td></tr></table> <h1>  </h1>"
  sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
  remove_string <- "<title>Summary Statistics</title>"
  sum_table <- gsub(remove_string, "", sum_table, fixed = TRUE)
  sum_table
}

check_equal <- function(numbers) {
  if (length(numbers) <= 1) {
    return(TRUE)
  }
  nr <- numbers[2] # Use the second element as the reference for comparison
  # Check if all elements, except possibly the first, are equal to 'nr'
  all_equal <- all(numbers[-1] == nr)
  # Allow the first element to be either equal to 'nr' or one more than 'nr'
  first_condition <- numbers[1] == nr || numbers[1] == nr + 1
  return(all_equal && first_condition)
}

determine_seperator_header <- function(filepath) {
  # Potential separators
  separator_candidates <- c("\t", ",", ";", " ", "\\|")

  # Read the first 10 lines of the file
  lines <- readLines(filepath, n = 10)
  if (length(lines) < 10) {
    warning("File has fewer than 10 lines; accuracy may decrease.")
  }

  # Count occurrences of each separator in each line
  counts <- sapply(separator_candidates, function(sep, lines) {
    sapply(lines, function(line) length(strsplit(line, sep)[[1]]) - 1)
  }, lines)

  consistent <- apply(counts, 2, function(column) {
    # Check if the second entry of the column is bigger than 0
    return(column[2] > 0 && check_equal(column))
  })


  if (!any(consistent)) {
    stop("Could not determine a consistent separator")
  }

  # Select the most frequently occurring consistent separator
  separator <- separator_candidates[which.max(rowSums(counts * consistent))]

  # Check if the first line is a header: assume header if all segments are non-numeric
  header <- readr::read_delim(filepath, delim = separator, n_max = 1, col_names = FALSE, trim_ws = TRUE)
  has_header <- all(sapply(header, is.character))
  list(separator = separator, has_header = has_header)
}


read_auto <- function(filepath) {
  # Determine file extension
  file_ext <- tools::file_ext(filepath)



  # Load appropriate package and read data based on file extension
  switch(file_ext,
    csv = {
      sep_head <- determine_seperator_header(filepath)
      data <- readr::read_delim(filepath,
        delim = sep_head$separator,
        col_names = sep_head$has_header,
        trim_ws = TRUE
      )
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

checkVarsInData <- function(model_parsed, data) {
  names_model <- lavNames(model_parsed, type = "ov")
  names_data <- names(data)
  var_not_in_data <- !(names_model %in% names_data)
  names(var_not_in_data) <- names_model
  return(var_not_in_data)
}

getTextOut <- function(result) {
  # Initialize empty lists to hold errors and warnings
  errors <- NULL
  warnings <- NULL

  results <- withCallingHandlers(
    {
      tryCatch(
        {
          sum_model <- summary(result, fit.measures = TRUE, modindices = TRUE)
          sum_model$pe <- NULL
          estimates <- parameterestimates(result)
          list(summary = sum_model, estimates = estimates)
        },
        error = function(e) {
          return(NULL)
        }
      )
    },
    warning = function(w) {
      # Capture warning
      warnings <<- w
    },
    error = function(e) {
      # Capture error
      errors <<- e
    }
  )
  problem <- !is.null(errors)
  return(list(results = results, errors = errors, warnings = warnings, problem = problem))
}
