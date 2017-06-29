#simulate Data for on OpenMx Model
#' @export
simulateData <- function(run,N=1){
  stopifnot(class(run)=='MxModel' |class(run)=='MxRAMModel')
  manifests <- run@manifestVars

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
  result <- data.frame(Time=run$data@observed[1,paste0('time',1:length(manifests))],Y=t(simData))
  return(result)
}

plotSEM <- function(simData,N=1){
  simDataLong <- melt(simData, id="Time")
  print(ggplot(simDataLong,aes(x=Time,y=value,colour=variable)) + geom_line())
}




