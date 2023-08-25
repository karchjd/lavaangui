library(shiny)

# compile svelte front end
system("npm run build")
runApp(launch.browser = TRUE)