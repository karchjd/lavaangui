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

getGroupLabels <- function(fit) {
    labels <- if (inherits(fit, "fake_lavaan")) {
        if (!is.null(fit$group.label)) {
            fit$group.label
        } else {
            character()
        }
    } else {
        lavInspect(fit, "group.label")
    }
    n_groups <- getNGroups(fit)
    if (length(labels) != n_groups) {
        labels <- as.character(seq_len(n_groups))
    }
    labels
}

getGroupVariable <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$group
    } else {
        group <- lavInspect(fit, "group")
        if (length(group) == 0L || !nzchar(group[[1L]])) NULL else group[[1L]]
    }
}

getGroupEqual <- function(fit) {
    value <- if (inherits(fit, "fake_lavaan")) {
        fit$group.equal
    } else {
        lavInspect(fit, "options")$group.equal
    }
    if (is.null(value)) character() else as.character(value)
}

getGroupPartial <- function(fit) {
    value <- if (inherits(fit, "fake_lavaan")) {
        fit$group.partial
    } else {
        lavInspect(fit, "options")$group.partial
    }
    if (is.null(value)) character() else as.character(value)
}

getFirstModelGroup <- function(parTable) {
    if (!"group" %in% names(parTable)) {
        return(parTable)
    }

    group_ids <- suppressWarnings(as.integer(parTable$group))
    model_groups <- group_ids[!is.na(group_ids) & group_ids > 0L]
    if (length(model_groups) == 0L) {
        return(parTable)
    }

    first_group <- min(model_groups)
    keep <- !is.na(group_ids) & group_ids == first_group
    parTable[keep, , drop = FALSE]
}

getImportedData <- function(fit) {
    data <- lavInspect(fit, what = "data")
    if (getNGroups(fit) == 1L) {
        return(as.data.frame(data))
    }

    group_variable <- getGroupVariable(fit)
    if (is.null(group_variable)) {
        stop("Could not determine the grouping variable used by the lavaan model.")
    }

    group_labels <- getGroupLabels(fit)
    if (!is.list(data) || length(data) != length(group_labels)) {
        stop("Could not reconstruct the grouped data from the lavaan model.")
    }

    grouped_data <- lapply(seq_along(data), function(index) {
        group_data <- as.data.frame(data[[index]])
        group_data[[group_variable]] <- group_labels[[index]]
        group_data
    })
    data <- do.call(rbind, grouped_data)
    rownames(data) <- NULL
    data
}

getOrdered <- function(fit) {
    if (inherits(fit, "fake_lavaan")) {
        fit$ordered
    } else {
        lavInspect(fit, what = "ordered")
    }
}
