# Detach all loaded packages and clean your environment
if (!requireNamespace("golem", quietly = TRUE)) {
  install.packages("golem")
}
golem::detach_all_attached()

# Document and reload your package
#roxygen2::roxygenise()
pkgload::load_all()
library(lavaan)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
options(shiny.port = 3245)
start_gui(fit)