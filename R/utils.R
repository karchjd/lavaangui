#simulate Data for on OpenMx Model
#' @export
simulateData <- function(run,N=1){
  stopifnot(class(run)=='MxModel' |class(run)=='MxRAMModel')
  manifests <- run@manifestVars

  #add fake data
  fake.data <- data.frame(matrix(1:(length(manifests)*2),ncol=length(manifests)))
  names(fake.data)<- manifests
  run@data <- mxData(fake.data,type="raw")
  #run to get exp mean and covariance
  fit <- mxRun(run,useOptimizer=F,silent=T)
  covM <- fit$fitfunction@info$expCov
  mu <- fit$fitfunction@info$expMean

  #generate Data
  simData <- mvrnorm(n=N, mu, covM)
  if (N==1){
    simData <- t(simData)
  }
  colnames(simData) <- manifests
  result <- simData
  return(result)
}


plotSEM <- function(simData,N=1){
  simDataLong <- melt(simData, id="Time")
  print(ggplot(simDataLong,aes(x=Time,y=value,colour=variable)) + geom_line())
}

#generate a Latent Growth Curve Model
#' @export
generateAR <-function(N){
  ##define model
  maniFests <- paste('Y',1:N,sep="")
  model<-mxModel("Autoregressive Model Path",
                 type="RAM",
                 manifestVars=maniFests,
                 #Y_j=b_0
                 mxPath(from="one",
                        to=maniFests[2:N],
                        arrows=1,
                        free=T,
                        values=rep(1,N-1),
                        labels=rep('b0',N-1)
                 ),
                 #Y_j=b_1Y_{j-1}
                 mxPath(from=maniFests[1:(N-1)],
                        to=maniFests[2:N],
                        arrows=1,
                        free=TRUE,
                        values=rep(.8,N-1),
                        labels=rep("b1",N-1)
                 ),
                 #Y_j=e_j
                 mxPath(from=maniFests,
                        arrows=2,
                        free=TRUE,
                        values=rep(.1,N),
                        labels=rep('sigma',N),
                        lbound=0),
                 #distribution for first time point
                 mxAlgebra(name="cstrM", expression=b0/(1-b1)),
                 mxPath(from="one",
                        to=maniFests[1],
                        arrows=1,
                        free=FALSE,
                        labels="cstrM[1,1]"
                 ),
                 mxAlgebra(name="cstrV", expression=sigma/(1-b1^2)),
                 mxPath(from=maniFests[1],arrows=2,free=F,labels="cstrV[1,1]")
  ) # close model
  return(model)
}

#generate a Latent Growth Curve Model
#' @export
generateLGCM <-function(p){
  manifests <- paste('Y',1:p,sep="")
  latents <-c("intercept","slope")
  growthCurveModel <- mxModel("Linear Latent Growth Curve Model",
                              type="RAM",
                              manifestVars=manifests,
                              latentVars=latents,
                              # latent means
                              mxPath(
                                from="one",
                                to=latents,
                                arrows=1,
                                free=c(TRUE,TRUE),
                                values=c(1,0),
                                labels=c("muI",'muS')
                              ),

                              # latent variances and covariance
                              mxPath(
                                from=latents,
                                arrows=2,
                                free=TRUE,
                                connect="unique.pairs",
                                values=c(1,0.5,1),
                                labels=c("varI",'covIS',"varS")
                              ),
                              # intercept loadings
                              mxPath(
                                from="intercept",
                                to=manifests,
                                arrows=1,
                                free=FALSE,
                                values=rep(1,p)
                              ),

                              #slope loadings
                              mxPath(
                                from="slope",
                                to=manifests,
                                arrows=1,
                                free=FALSE,
                                values=0:(p-1)
                              ),

                              #measurement error
                              mxPath(
                                from=manifests,
                                arrows=2,
                                free=TRUE,
                                values = 1,
                                labels=c('sigma')
                              )
  ) # close growthCurveModel
  return(growthCurveModel)
}




