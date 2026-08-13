recompile_front <- T # nolint
debug <- F

if (recompile_front) {
  # Compile Svelte front end
  if (debug) {
    ret_val <- system("cd frontend && npm run build:dev")
  } else {
    ret_val <- system("cd frontend && npm run build:deploy")
  }

  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }
}

# Document and reload your package
# roxygen2::roxygenise()
pkgload::load_all()


library(lavaan)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9'

fit <- cfa(HS.model, 
           data = HolzingerSwineford1939,
           group = "school")


lavaangui(fit)
# plot_lavaan(fit)
# export_plot(fit, "test.png", scale = 5)
# export_plot(fit, "test.jpg", scale = 5)

