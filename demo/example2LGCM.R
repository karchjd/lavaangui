require(gppmr)
require(OpenMx)
require(MASS)

##settings
nP <- 100
nT <- 3

##define latent growth curve model using SEM software
lgcModel <- generateLGCM(nT)
trueModel <- omxSetParameters(lgcModel,labels=c('muI','muS','varI','varS','covIS','sigma'),values=c(10,3,4,10,0.5,10))

##simulate data
yMatrix <- simulateData(trueModel,N=nP)
tMatrix <- matrix(rep(0:(nT-1),each=nP),nrow = nP,ncol = nT)


##fit data using SEM
semModel <- mxModel(lgcModel,mxData(yMatrix,type = "raw"))
semModel <- mxRun(semModel,silent = TRUE)
colnames(tMatrix) <- paste0('t',1:nT)
myData <- as.data.frame(cbind(tMatrix,yMatrix))

# ##fit data using GPPM
gpModel <- gppModel('muI+muS*t','varI+covIS*(t+t!)+varS*t*t!+omxApproxEquals(t,t!,0.0001)*sigma',myData)
gpModelFit <- gppFit(gpModel)

##compare results
lgcmSame <- all.equal(gpModelFit$mlParas,omxGetParameters(semModel)[names(gpModelFit$mlParas)],check.attributes=FALSE,tolerance=0.0001)
message(sprintf('Estimated parameters for the LGCM model are the same: %s',lgcmSame))
