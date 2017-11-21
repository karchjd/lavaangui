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

##wide data format for GPPM
names(tVector) <- paste0('t',1:nT)
names(yVector) <- paste0('Y',1:nT)
myData <- as.data.frame(t(c(tVector,yVector))) #force R to make dataframe with one row


#get results using GPPM
gpModel <- gppModel('b0/(1-b1)','b1^(abs(t-t!))*sigma/(1-b1^2)',myData)
gpModel <- gppFit(gpModel)

##check results
arSame <- all.equal(gpModel$mlParas,omxGetParameters(semModel)[names(gpModel$mlParas)],check.attributes=FALSE,tolerance=0.0001)
message(sprintf('Estimated parameters for the AR(1) model are the same: %s',arSame))
