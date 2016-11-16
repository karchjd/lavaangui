# rm(list=ls())
source('~/mystuff/projects/dissertation/paper/code/extendOpenMx/gppModel.R')
source('~/mystuff/projects/dissertation/paper/code/extendOpenMx/package/simulateData.R')
require(OpenMx)
##set parameter values
b0<-10
b1<-3
vErr <- 50
N<- 30

#time points
timePoints <- c(1:N)
X <- list(timePoints)
Y <- X
#use GPPM
gpModel <- gppModel(X,Y,'$b0$+$b1$*$t$','omxApproxEquals($s$,$t$,0.0000001)*$vErr$')
gpModel <- omxSetParameters(gpModel,names(omxGetParameters(gpModel)),values=c(b0,b1,vErr))
simData <- simulateData(gpModel,3)
simDataLong <- melt(simData, id="Time")
print(ggplot(simDataLong,aes(x=Time,y=value,colour=variable)) + geom_line())

