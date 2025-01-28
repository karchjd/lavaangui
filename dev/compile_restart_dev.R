recompile_front <- T # nolint
release <- T

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
'

fit <- sem(model, data = PoliticalDemocracy)


HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
lavaangui(fit)