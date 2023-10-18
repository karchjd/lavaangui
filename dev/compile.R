recompile_front <- T

if (recompile_front){
  # Compile Svelte front end
  ret_val <- system("cd src && npm run build")
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }  
}


# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
#roxygen2::roxygenise()
pkgload::load_all()
# Run the application
library(lavaan)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
# plot_interactive(fit, where = "browserr")
# start_gui(fit)

## linear growth model with a time-varying covariate
model.syntax <- '
  # intercept and slope with fixed coefficients
    i =~ 1*t1 + 1*t2 + 1*t3 + 1*t4
    s =~ 0*t1 + 1*t2 + 2*t3 + 3*t4'
fit <- growth(model.syntax, data = Demo.growth)
# plot_interactive(fit, where = "browserr")
start_gui()
