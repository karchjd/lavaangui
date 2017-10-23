##setup
require(gppmr)
require(OpenMx)
require(MASS)

##settings
nP <- 100
nT <- 3

##define latent growth curve model using SEM software
lgcModel <- generateLGCM(nT)
trueModel <- omxSetParameters(lgcModel,labels=c('muI','muS','varI','varS','covIS','sigma'),values=c(10,3,1,2,0.5,0.25))

##simulate data
yMatrix <- simulateData(trueModel,N=nP)
tMatrix <- matrix(rep(0:(nT-1),each=nP),nrow = nP,ncol = nT)
colnames(tMatrix) <- paste0('t',1:3)
myData <- as.data.frame(cbind(tMatrix,yMatrix))

# models
meanf <-'muI+muS*t'
covf <- 'varI+covIS*(t+t!)+varS*t*t!+omxApproxEquals(t,t!,0.001)*sigma'
test <- parseModel(meanf,covf,myData)
expect_equal(test$meanFunction,'muI+muS*$t$')
expect_equal(test$covFunction,'varI+covIS*($t$+$t!$)+varS*$t$*$t!$+omxApproxEquals($t$,$t!$,0.001)*sigma')
expect_equal(test$params,c('muI','muS','varI','covIS','varS','sigma'))
expect_equal(test$covVars,c('t'))
expect_equal(test$meanVars,c('t'))



