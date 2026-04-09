rebuild_frontend <- !nzchar(Sys.getenv("GITHUB_ACTIONS"))
build_target <- "deploy"

if (rebuild_frontend) {
  print("Rebuilding Svelte front end...")
  build_cmd <- if (build_target == "dev") "build:dev" else "build:deploy"
  ret_val <- system2("npm", c("--prefix", "frontend", "run", build_cmd))
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }
}

golem::detach_all_attached()
pkgload::load_all()
options(shiny.port = 3245)
app <- lavaangui:::start_app(full = TRUE, where = "shinyapps.io", layout = NULL, export_filepath = NULL)
runApp(app, launch.browser = TRUE)
