#' @export
gppFit <- function(gpModel){
  stopifnot(class(gpModel)=='GPPM')
  #fit
  fittedModel <- gpModel
  fittedModel$omx <- mxRun(gpModel$omx,silent=TRUE)

  #get ML pars out
  omxParas <- omxGetParameters(fittedModel$omx)
  names(omxParas)<-gsub('GPPM.|[1,1]','',names(omxParas))
  fittedModel$mlParas <- omxParas[names(fittedModel$mlParas)]
  return(fittedModel)
}
