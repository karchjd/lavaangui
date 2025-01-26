recompile_front <- T # nolint
release <- F

if (recompile_front) {
  # Compile Svelte front end
  if(!release){
    ret_val <- system("cd frontend && npm run build:dev")  
  }else{
    ret_val <- system("cd frontend && npm run build:deploy")  
  }
  
  if (ret_val != 0) {
    stop("Failed to compile Svelte front end.")
  } 
}
  
  
# Detach all loaded packages and clean your environment
golem::detach_all_attached()

# Document and reload your package
# roxygen2::roxygenise()
pkgload::load_all()


library(lavaan)
model <- ' 
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
'

fit <- sem(model, data = PoliticalDemocracy)
lavaangui(fit)
