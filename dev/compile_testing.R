recompile_front <- T

if (recompile_front){
  # Compile Svelte front end 
  ret_val <- system("cd src && npm run build:deploy")
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }  
}


# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
#roxygen2::roxygenise()
pkgload::load_all()
options(shiny.port = 3245)
start_gui()