
rebuild_frontend <- TRUE
build_target <- "deplot"

if (rebuild_frontend) {
  build_cmd <- if (build_target == "dev") "build:dev" else "build:deploy"
  ret_val <- system2("npm", c("--prefix", "frontend", "run", build_cmd))
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }
}

golem::detach_all_attached()
pkgload::load_all()
options(shiny.port = 3245)
withr::with_envvar(c(DEPLOY_ENV = "shinyapps"), lavaangui())
