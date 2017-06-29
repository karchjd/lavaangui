#simulate Data for on OpenMx Model
#' @export
plotSEM <- function(simData,N=1){
  simDataLong <- melt(simData, id="Time")
  print(ggplot(simDataLong,aes(x=Time,y=value,colour=variable)) + geom_line())
}




