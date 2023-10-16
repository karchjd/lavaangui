recompile_front <- FALSE

if (recompile_front){
  # Compile Svelte front end
  ret_val <- system("cd src && npm run build")
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }  
}


# Detach all loaded packages and clean your environment
golem::detach_all_attached()
rm(list=ls(all.names = TRUE))

# Document and reload your package
roxygen2::roxygenise()
pkgload::load_all()
# Run the application
start_gui()
