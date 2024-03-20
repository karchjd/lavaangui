# library(git2r)
#
# # Define the file where you want to save the commit info
# file_path <- "version_info.txt"
#
# # Get repository information
# repo <- repository()
#
# # Get the current commit hash
# current_hash <- revparse_single(repo, "HEAD")$sha
#
# # Check for uncommitted changes
# status <- status(repo)
# changes <- ifelse(length(status$staged) > 0 || length(status$unstaged) > 0, "with changes", "without changes")
#
# # Save the commit hash and changes status to a file
# writeLines(paste("Commit:", current_hash, ", Status:", changes), file_path)



recompile_front <- T

if (recompile_front) {
  # Compile Svelte front end
  ret_val <- system("cd src && npm run build:dev")
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  }
}


# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
# roxygen2::roxygenise()
pkgload::load_all()
# Run the application
library(lavaan)
HS.model <- " visual  =~ x1 + x2 + myLabel * x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 "

fit <- cfa(HS.model, data = HolzingerSwineford1939)

model <- "
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + a*y2 + b*y3 + c*y4
     dem65 =~ y5 + a*y6 + b*y7 + c*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
"

fit <- sem(model, data = PoliticalDemocracy)
options(shiny.port = 3245)

start_gui(fit)
# plot_interactive(fit)
