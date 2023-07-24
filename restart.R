library(shiny)

# compile svelte front end
system("npm run build")

# move frontend to www
files <- list.files(path = "dist", full.names = TRUE)
file.rename(from = files, to = paste0("www/", basename(files)))
runApp(launch.browser = TRUE)
  