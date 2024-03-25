lastWarning <- NULL
withCallingHandlers(
  {
    warning("some lavaan warning")
    x <- 3
  },
  warning = function(w) {
    lastWarning <<- w
  }
)