##set parameter values
library(OpenMx)
library(gppmr)
b0<-10
b1<-3
vErr <- 10
N<- 30

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
fitModel <- mxRun(gpModel,intervals=TRUE)

##make pretty results
print('LM Results:')
resLin <- confint(linearModel)
resLin <- cbind(resLin,linearModel$coefficients)
colnames(resLin)[3] <- 'estimate'
resLin <- resLin[,c(1,3,2)]
rownames(resLin) <- c('b0','b1')
print(resLin)

print('GP Results:')
resGP <- summary(fitModel)$CI
resGP <- resGP[1:2,]
rownames(resGP) <- c('b0','b1')
colnames(resGP) <- c('2.5 %','estimate','97.5 %','')
print(resGP)
stopifnot(all.equal(resLin[,'estimate'],resGP[,'estimate'],
                    tolerance=0.0001,check.names=FALSE))
cat('\nPoint estimates are identical\n\n')
cat('Borders of 95% confidence intervals are not excactly the same
because different strategies are used.
However, they converge  as N grows')

