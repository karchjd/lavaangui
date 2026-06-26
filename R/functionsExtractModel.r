getOVNames <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$observed
    } else {
        lavaanNames(fit, type = "ov")
    }
}

getLVNames <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$latents
    } else {
        lavaanNames(fit, type = "lv.regular")
    }
}

myParameterEstimates <- function(fit, ...) {
    if (inherits(fit, "fake_lavaan")) {
        fit$table
    } else {
        parameterEstimates(fit, ...)
    }
}

getParTable <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$table
    } else {
        parTable(fit)
    }
}

standardizedEstimates <- function(fit, ...) {
    if (inherits(fit, "fake_lavaan")) {
        fit$table
    } else {
        standardizedSolution(fit, ...)
    }
}


getNGroups <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$ngroups
    } else {
        lavInspect(fit, "ngroups")
    }
}

getOrdered <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$ordered
    } else {
        lavInspect(fit, what = "ordered")
    }
}
