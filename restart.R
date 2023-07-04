library(shiny)

# compile svelte front end
system("npm run build")

# move frontend to www
unlink("www",recursive = TRUE)
file.rename("dist","www")
runApp(launch.browser = TRUE)
