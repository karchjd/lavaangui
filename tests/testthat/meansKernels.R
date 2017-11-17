context("gppModel")

#generate data according to the linear change model
b0 <- 3
b1 <- 2
sigma <- 1 #abbreviation for \sigma_\epsilon^2
nTime <- 3
trueModel <- function(t){b0+b1*t+rnorm(n=1,mean=0,sd=sqrt(sigma))}
tVector <- 1:nTime
yVector <- vapply(tVector, trueModel, 1)

#wide data format for GPPM
names(tVector) <- paste0('t',1:nTime)
names(yVector) <- paste0('Y',1:nTime)
myData <- as.data.frame(t(c(tVector,yVector))) #force R to make dataframe with one row


test_that("linear regression", {
  gpModel <- gppModel('b0+b1*t','omxApproxEquals(t,t!,0.0001)*sigma',myData)
  gpModel <- gppFit(gpModel)
})

test_that("Bayesian Linear regression", {
  gpModel <- gppModel('0','(t*t!+1)*sigmab+omxApproxEquals(t,t!,0.0001)*sigma',myData)
  gpModel <- gppFit(gpModel)
})

test_that("squared exponential", {
  gpModel <- gppModel('c','sigmaf*exp(-(t-t!)^2/rho)+omxApproxEquals(t,t!,0.0001)*sigma',myData)
  gpModel <- gppFit(gpModel)
})


