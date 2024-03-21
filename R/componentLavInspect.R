lavInspectUI <- function(id) {
  tabPanel("lavInspect",
    sidebarLayout(
      sidebarPanel(
        selectizeInput(NS(id,"topic"), "lavInspect Topic", "",
          multiple = FALSE, selected = "All",
          choices = c(
            "All topics",
            "All topics (+ alias)",
            "Information about data",
            "Observed sample statistics",
            "Model features",
            "Model-implied sample statistics",
            "Optimizer information",
            "Gradient, Hessian, Information matrices",
            "Vcov of model parameters",
            "Miscellaneous"
          )
        ),
        selectizeInput(NS(id,"what"), "What to lavInspect",
          choices = NULL,
          selected = "",
          options = list(placeholder = "Choose what to inspect")
        ),
        br()
      ),
      mainPanel(
        verbatimTextOutput(NS(id,"main"))
      )
    )
  )
}







lavInspectServer <- function(id, fit) {
  moduleServer(id, function(input, output, session) {
    li_modmat <- c("","free", "partable", "standard.errors", "starting.values",
                   "estimates", "dx.free", "dx.all", "standardized", "std.lv",
                   "std.nox")
    li_infdata <- c("","data", "group", "ngroups", "group.label", "cluster", "ordered",
                    "nobs", "norig", "ntotal", "case.idx", "empty.idx","patterns",
                    "coverage")
    li_obssampstat <- c("","samplestatistics", "sampstat.h1", "wls.obs", "wls.v",
                        "gamma")
    li_modfeatures <- c("","meanstructure", "categorical", "fixed.x", "parameterization")
    li_modimpliedstat <- c("","fitted", "residuals","cov.lv", "cor.lv", "mean.lv",
                           "cov.ov", "cor.ov", "mean.ov", "cov.all", "cor.all",
                           "thresholds", "wls.est", "vy", "rsquare")
    li_optimizer <- c("","converged", "iterations", "optim", "npar", "coef")
    li_gradhessinfo <- c("","gradient", "hessian", "information", "information.expected",
                         "information.observed", "information.first.order",
                         "augmented.information", "augmented.information.expected",
                         "augmented.information.observed", "augmented.information.first.order",
                         "inverted.information", "inverted.information.expected",
                         "inverted.information.observed", "inverted.information.first.order")
    li_vcovmodpar <- c("","vcov", "vcov.std.all", "vcov.std.lv", "vcov.std.nox")
    li_misc <- c("","UGamma", "list", "fit.measures", "modification.indices", "options",
                 "call", "timing", "test", "post.check", "zero.cell.tables")
    li_alias <- c("se", "std.err","start", "est", "x", "std", "std.all", "sampstat",
                  "samp", "sample", "h1", "missing.h1", "sampstat.nacov",
                  "implied", "res", "resid", "residual","veta", "eeta", "sigma",
                  "sigma.hat", "mu", "mu.hat", "th", "r-square", "r2", "fit",
                  "fitmeasures", "fit.indices", "mi", "modindices")
    li_all <- c(li_modmat, li_infdata[-1], li_obssampstat[-1], li_modfeatures[-1],
                li_modimpliedstat[-1], li_optimizer[-1], li_gradhessinfo[-1],
                li_vcovmodpar[-1], li_misc[-1])
    li_all_alias <- c(li_all, li_alias)

    observe({
      topic <- input$topic

      if(topic == "All topics"){
        updateSelectInput(session, "what",
                          choices = li_all,
                          selected="")

      }else if(topic == "All topics (+ alias)"){
        updateSelectInput(session, "what",
                          choices = li_all_alias,
                          selected="")

      }else if(topic == "Information about data"){
        updateSelectInput(session, "what",
                          choices = li_infdata,
                          selected="")

      }else if(topic == "Observed sample statistics"){
        updateSelectInput(session, "what",
                          choices = li_obssampstat,
                          selected="")

      }else if(topic == "Model features"){
        updateSelectInput(session, "what",
                          choices = li_modfeatures,
                          selected="")

      }else if(topic == "Model-implied sample statistics"){
        updateSelectInput(session, "what",
                          choices = li_modimpliedstat,
                          selected="")

      }else if(topic == "Optimizer information"){
        updateSelectInput(session, "what",
                          choices = li_optimizer,
                          selected="")

      }else if(topic == "Gradient, Hessian, Information matrices"){
        updateSelectInput(session, "what",
                          choices = li_gradhessinfo,
                          selected="")

      }else if(topic == "Vcov of model parameters"){
        updateSelectInput(session, "what",
                          choices = li_vcovmodpar,
                          selected="")

      }else if(topic == "Miscallaneous"){
        updateSelectInput(session, "what",
                          choices = li_misc,
                          selected="")

      }
    })

      output$main <- renderPrint({
        if(input$what== ""){
          cat("choose what to inspect")

        }else{
          lavaan::lavInspect(fit(), what=input$what)
        }
    })
  })
}
