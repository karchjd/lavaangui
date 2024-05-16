# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
######################################
#### CURRENT FILE: DEPLOY SCRIPT #####
######################################


# Test your app

## fresh compile
ret_val <- system("cd frontend && npm run build:deploy")
if (ret_val != 0) {
  stop("Failed to compile Svelte front end.")
}

# Deploy to Posit Connect or ShinyApps.io
# In command line.
rsconnect::deployApp(
  appName = desc::desc_get_field("Package"),
  appTitle = desc::desc_get_field("Package"),
  appFiles = c(
    # Add any additional files unique to your app here.
    "R/",
    "inst/",
    "NAMESPACE",
    "DESCRIPTION",
    "app.R"
  ),
  appId = rsconnect::deployments(".")$appID,
  lint = FALSE,
  forceUpdate = TRUE,
  account = "solo-fsw"
)
