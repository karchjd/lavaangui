# Create custom datatable object
round_df <- function(df, digits) {
  nums <- vapply(df, is.numeric, FUN.VALUE = logical(1))

  df[, nums] <- round(df[, nums], digits = digits)

  (df)
}

custom_dt <- function(data, digits, callback = NULL, filter = "top", options = list()) {
  data <- round_df(data, digits)
  if (is.null(callback)) {
    callbackCall <- DT::JS("return table;")
  } else {
    callbackCall <- DT::JS(callback)
  }
  defaultOptions <- list(
    autoWidth = TRUE,
    width = "60%",
    bAutoWidth = TRUE,
    pageLength = 15,
    lengthMenu = list(
      c(15, 50, 100, -1),
      c("15", "50", "100", "All")
    ),
    # scrollX = TRUE,
    dom = '<"top"lf><"datatables-scroll"t><"bottom"pi>'
  )
  DT::datatable(data,
    options = utils::modifyList(defaultOptions, options),
    filter = filter,
    rownames = FALSE,
    class = "compact",
    style = "bootstrap",
    selection = "single",
    callback = callbackCall
  )
}
