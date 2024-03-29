recompile_front <- F # nolint

if (recompile_front) {
  # Compile Svelte front end
  ret_val <- system("cd frontend && npm run build:dev")
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

# model <-'
# # measurement model
#  f1 =~ x1 + x2 + x3
#  f2 =~ 2*x2 + x2 + 3*x3 + x3
# '
# fit <- sem(model, sample.cov = cov(PoliticalDemocracy), sample.nobs = nrow(PoliticalDemocracy))
HS.model <- " visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 "

# fit_g <- cfa(HS.model,
#   data = HolzingerSwineford1939,
#   group = "school"
# )
# fit <- sem(model, data = PoliticalDemocracy)
# model.syntax <- '
#   # intercept and slope with fixed coefficients
#     i =~ 1*t1 + 1*t2 + 1*t3 + 1*t4
#     s =~ 0*t1 + 1*t2 + 2*t3 + 3*t4
# 
#   # regressions
#     i ~ x1 + x2
#     s ~ x1 + x2
# 
#   # time-varying covariates
#     t1 ~ c1
#     t2 ~ c2
#     t3 ~ c3
#     t4 ~ c4
# '

# fit <- growth(model.syntax, data = Demo.growth)
start_gui(fit)
#plot_interactive(fit, where = "browser")


library(lavaan)
model <-'
# measurement model
 Intercept =~ 1*x1 + 1*x2 + 1*x3 + 1*x4 + 1*x5
 Slope =~ 1*x2 + 2*x3 + 3*x4 + 4*x5

# intercepts
Intercept ~ 1
Slope ~ 1
'

data <- HolzingerSwineford1939
result <- lavaan(model, data, meanstructure = TRUE,
                 int.ov.free = FALSE, int.lv.free = TRUE,
                 estimator = "default", se = "default",
                 missing = "listwise", auto.fix.first = TRUE ,
                 auto.fix.single = TRUE, auto.var = TRUE,
                 auto.cov.lv.x = TRUE, auto.cov.y = TRUE,
                 fixed.x = TRUE)
