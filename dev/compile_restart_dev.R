recompile_front <- T # nolint

if (recompile_front) {
  # Compile Svelte front end
  ret_val <- system("cd frontend && npm run build:dev")
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }
}
  
  
# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
# roxygen2::roxygenise()
pkgload::load_all()

# Run the application
library(lavaan)
HS.model <- " visual  =~ x1 + x2 + myLabel * x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9"

fit <- cfa(HS.model, data = HolzingerSwineford1939)

data <- read.csv("~/Downloads/bfi (3).csv")
model <-'
# measurement model
 f2 =~ A1 + A2 + A3 + A4 + A5 + C1 + C2 + C3 + C4 + C5 + E1 + E2 + E3 + E4 + 
       E5 + N1 + N2 + N3 + N4 + N5 + O1 + O2 + O3 + O4 + O5
'


result <- lavaan(model, data, meanstructure = "default",
                 int.ov.free = TRUE, int.lv.free = FALSE,
                 estimator = "default", se = "default",
                 missing = "listwise", auto.fix.first = TRUE,
                 auto.fix.single = TRUE, auto.var = TRUE,
                 auto.cov.lv.x = TRUE, auto.cov.y = TRUE,
                 fixed.x = TRUE)
# start_gui(result)
plot_interactive(result)


# model <-'
# # measurement model
#  f1 =~ x1 + x2 + x3 + x4 + x5
# '
# 
# result <- lavaan(model, meanstructure = "default",
#                  int.ov.free = TRUE, int.lv.free = FALSE,
#                  estimator = "default", se = "default", auto.fix.first = TRUE,
#                  auto.fix.single = TRUE, auto.var = TRUE,
#                  auto.cov.lv.x = TRUE, auto.cov.y = TRUE,
#                  fixed.x = FALSE, ordered = c("x1"))
# plot_interactive(result, where = "browser")
# # start_gui(result)
