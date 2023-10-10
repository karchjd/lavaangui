library(shiny)

# Compile Svelte front end
ret_val <- system("npm run build")
if (ret_val != 0) {
  stop("Failed to compile Svelte front end.")
}

runApp(launch.browser = TRUE)
