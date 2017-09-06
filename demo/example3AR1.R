##setup
require(gppmr)
require(OpenMx)

##settings
nT <- 20 #number of time points

##define autoregressive model using SEM software
arModel <- generateAR(nT)
trueModel <- omxSetParameters(arModel,labels = c('b0','b1','sigma'),values = c(10,0.5,1))

##simulate data
yVector <- simulateData(trueModel)
tVector <- 1:nT

##fit data using SEM
semModel <- mxModel(arModel,mxData(yVector,type = "raw"))
semModel <- mxRun(semModel)

##fit data using GPPM
gpModel <- gppModel(list(tVector),list(yVector),'$b0$/(1-$b1$)','$b1$^(abs($s$-$t$))*$sigma$/(1-$b1$^2)')
gpModel <- omxSetParameters(gpModel, labels=c("GPPM.b0[1,1]","GPPM.b1[1,1]","GPPM.sigma[1,1]"),
                            values=omxGetParameters(arModel)[c('b0','b1','sigma')]) #same starting values
gpModelFit <- mxRun(gpModel,silent = TRUE)

##check results
arSame <- all.equal(omxGetParameters(gpModelFit),omxGetParameters(semModel)[c('b0','b1','sigma')],check.attributes=FALSE,tolerance=0.0001)
message(sprintf('Estimated parameters for the AR(1) model are the same: %s',arSame))
