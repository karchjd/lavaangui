createDigitsInput <- function(moduleId,  value = 4, min = 0, step = 1) {
  numericInput(NS(moduleId, "digits"), "Number of Digits", value = value, min = min, step = step)
}
