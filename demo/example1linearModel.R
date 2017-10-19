  ##setup
require(gppmr)
require(OpenMx)

##generate data according to the linear change model
b0 <- 3
b1 <- 2
sigma <- 1 #abbreviation for \sigma_\epsilon^2
trueModel <- function(t){b0+b1*t+rnorm(n=1,mean=0,sd=sqrt(sigma))}
tVector <- 1:50
yVector <- vapply(tVector, trueModel, 1)

##get results using lm
fittedLM <- lm(yVector ~ tVector)
parasLM <- coefficients(fittedLM)
parasLM[3] <-summary(fittedLM)$sigma
names(parasLM) <- c("LM.b0",'LM.b1','LM.sigma')
print(parasLM)

##get results using GPPM
gpModel <- gppModel(tVector,yVector,'$b0$ + $b1$*$t$','omxApproxEquals($s$,$t$,0.0000001)*$sigma$') #TODO less ugly
gpModel <- suppressWarnings(mxRun(gpModel))
parasGPPM <- omxGetParameters(gpModel) #TODO less ugly
names(parasGPPM) <- c("GPPM.b0",'GPPM.b1','GPPM.sigma')

##check results
coefSame <- all.equal(parasLM[1:2],parasGPPM[1:2],check.attributes = FALSE,tolerance = 0.0001)
message(sprintf('Coefficients of linear model are the same: %s',coefSame))
#residual variances, i.e. parasLM[3] and parasGPPM[3] are not the same  because GPPM uses ML for parameter estimation and lm OLS
