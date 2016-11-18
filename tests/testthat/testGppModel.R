library(stringr)
context("gppModel")
test_that("gppModel runs", {
  ##set parameter values
  b0<-10
  b1<-3
  vErr <- 10
  N<- 20

  #simualte data
  timePoints <- c(1:N)
  ys <- b0+timePoints*b1+rnorm(N,sd=vErr)
  #use lm
  linearModel <- lm(ys~ 1+timePoints)

  X <- list(timePoints)
  Y <- list(ys)
  #use GPPM
  gpModel <- gppModel(X,Y,'$b0$+$b1$*$t$','omxApproxEquals($s$,$t$,0.0000001)*$vErr$')
  gpModel <- mxModel(gpModel,mxCI(names(omxGetParameters(gpModel))))
})
