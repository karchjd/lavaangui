recompile_front <- F # nolint

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
              speed   =~ x7 + x8 + x9 "

fit <- cfa(HS.model, data = HolzingerSwineford1939, ordered = c("x4"))
start_gui(fit)
# plot_interactive(fit)


model <-'
# measurement model
 f1 =~ x1 + x2 + x3 + x4 + x5
'

# result <- lavaan(model, meanstructure = "default",
#                  int.ov.free = TRUE, int.lv.free = FALSE,
#                  estimator = "default", se = "default", auto.fix.first = TRUE,
#                  auto.fix.single = TRUE, auto.var = TRUE,
#                  auto.cov.lv.x = TRUE, auto.cov.y = TRUE,
#                  fixed.x = FALSE, ordered = c("x1"))
# plot_interactive(result, where = "browser")
# start_gui(result)
