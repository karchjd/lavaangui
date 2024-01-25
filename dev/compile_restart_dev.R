recompile_front <- T

if (recompile_front){
  # Compile Svelte front end 
  ret_val <- system("cd src && npm run build:dev")
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
HS.model <- ' visual  =~ x1 + x2 + myLabel * x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
options(shiny.port = 3245)

start_gui(fit)
# plot_interactive(fit)

