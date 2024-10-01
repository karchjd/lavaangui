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
  separator_candidates <- c("\t", ",", ";", " ", "\\|")
  
  lines <- readLines(filepath, n = 10)
  if (length(lines) < 10) {
    warning("File has fewer than 10 lines; accuracy may decrease.")
  }
  
  # Collapse Whitespace
  collapse_whitespace <- function(line) {
    gsub("\\s{2,}", " ", line)
  }
  lines <- sapply(lines, collapse_whitespace)
  
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
  has_header <- all(sapply(header, is.character) | sapply(header, is.na))
  list(separator = separator, has_header = has_header)
}


read_auto <- function(filepath) {
  # Determine file extension
  file_ext <- tools::file_ext(filepath)
  read_csv <- function(filepath) {
    sep_head <- determine_seperator_header(filepath)
    data <- readr::read_delim(filepath,
      delim = sep_head$separator,
      col_names = sep_head$has_header,
      trim_ws = TRUE
    )
    return(data)
  }


  # Load appropriate package and read data based on file extension
  switch(file_ext,
    csv = {
      data <- read_csv(filepath)
    },
    txt = {
      data <- read_csv(filepath)
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


serverDataUploader <- function(id) {
  moduleServer(id, function(input, output, session) {
    loadedData <- reactiveVal(NULL)
    import <- logical(1)

    observeEvent(input$fileInput, {
      tryCatch(
        {
          if (!is.null(input$fileInput$datapath)) {
            loadedData(list(df = read_auto(input$fileInput$datapath), name = input$fileInput$name))
            showData <- TRUE
          } else {
            content <- input$fileInput$content
            decoded <- base64enc::base64decode(content)
            loadedData(list(df = readr::read_csv(decoded), name = "data.csv"))
            showData <- FALSE
          }
          propagateData(loadedData(), session, showData)
        },
        error = function(e) {
          session$sendCustomMessage(
            "lav_warning_error",
            list(origin = "loading data", message = e$message, type = "danger")
          )
        }
      )
    })
    return(loadedData)
  })
}
