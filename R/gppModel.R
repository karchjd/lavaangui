newSeq <- function(from,to){
  if (to>=from){
    return(from:to)
  }else{

    return(c())
  }
}

generateMean <- function(timeIndex,meanFunction){
  #find $t$ expression
  replacement <- paste0('T[1,',timeIndex,']');
  meanFunction <- gsub("\\$t\\$",replacement,meanFunction)
  #remove $
  meanFunction <- gsub("\\$","",meanFunction)
  return(meanFunction)
}

generateCov <- function(sIndex,tIndex,covFunction){
  #find $t$ expression
  replacement <- paste0('T[1,',tIndex,']');
  covFunction <- gsub("\\$t\\$",replacement,covFunction)
  #find $s$ expression
  replacement <- paste0('T[1,',sIndex,']');
  covFunction <- gsub("\\$s\\$",replacement,covFunction)
  #remove $
  covFunction <- gsub("\\$","",covFunction)
  return(covFunction)
}

getVariables <- function(meanFunction){
  result <- c()
  dollarRead <- FALSE
  for (i in 1:nchar(meanFunction)){
    currentChar <- substr(meanFunction,i,i)
    if (!dollarRead){
      if (currentChar=='$'){
        dollarRead <- TRUE
        buffer <- c()
      }
    }else{
      if (currentChar=='$'){
        result <- c(result,buffer)
        dollarRead <- FALSE
      }else{
        buffer <- paste0(buffer,currentChar)
      }
    }
  }
  #remove s and t
  result <- setdiff(result,c('s','t'))
  stopifnot(length(result)==length(unique(result)))
  return(result)
}


#' @export
#' @import OpenMx
gppModel <- function(X,Y,meanFunction,covFunction){
  ##create data matrix for openmx
  N <- length(X)
  stopifnot(N==length(Y))

  xsize <- sapply(X,length)
  ysize <- sapply(Y, length)
  stopifnot(identical(xsize,ysize))
  maxColNumber <- max(ysize)
  dataForOpenMx <- matrix(data=NA,nrow=N,ncol=2*maxColNumber)
  manifests <- paste0('Y',1:maxColNumber)
  colnames(dataForOpenMx) <- c(manifests,paste0('time',1:maxColNumber))
  for (i in 1:N){
    dataForOpenMx[i,newSeq(1,ysize[i])] <- Y[[i]]
    dataForOpenMx[i,newSeq(ysize[i]+1,maxColNumber)] <- NA
    dataForOpenMx[i,newSeq(maxColNumber+1,maxColNumber+ysize[i])] <- X[[i]]
    dataForOpenMx[i,newSeq(maxColNumber+ysize[i]+1,2*maxColNumber)] <- 1000000 #arbitrary value that will be ignored anyway
  }
  model <- mxModel(model="GPPM",
          manifestVars = manifests,
          mxData(dataForOpenMx,type="raw"),
          mxMatrix(type='Full',nrow=1,ncol=maxColNumber,labels=paste0("data.time",1:maxColNumber),name='T'))

  ##get parameters from mean and covariance function and add them to the model
  mParams <- getVariables(meanFunction)
  cParams <- getVariables(covFunction)
  allParams <- union(mParams,cParams)
  stopifnot(length(allParams)==length(mParams)+length(cParams)) #params in mean and covfunction should be unique
  for (i in 1:length(allParams)){
    model <- mxModel(model,
                     mxMatrix(type='Full',nrow=1,ncol=1,free=TRUE,value=1,name=allParams[i]))
  }

  ##generate the mean algebras and the mean matrix
  for (colIndex in 1:maxColNumber){
    theName <- paste0('mus',colIndex)
    theAlgebra <- generateMean(colIndex,meanFunction)
    string <- paste0("model <- mxModel(model,mxAlgebra(",theAlgebra,",name='",theName,"'))")
    eval(parse(text=string))
  }
  model <- mxModel(model,mxMatrix(type='Full',nrow=1,ncol=maxColNumber,free=FALSE,labels=paste0('mus',1:maxColNumber,'[1,1]'),name='expMean'))

  ##generate the covariance algebras and the covariance matrix
  for (colIndex in 1:maxColNumber){
    for (colIndex2 in colIndex:maxColNumber){
      theName <- paste0('cov',colIndex,',',colIndex2)
      theAlgebra <- generateCov(colIndex,colIndex2,covFunction)
      string <- paste0("model <- mxModel(model,mxAlgebra(",theAlgebra,",name='",theName,"'))")
      eval(parse(text=string))
    }
  }
  labelMatrix <- matrix('cov',nrow=maxColNumber,ncol=maxColNumber)
  for (i in 1:maxColNumber){
    for (j in 1:maxColNumber){
      if (i>j){
        labelMatrix[i,j] <- paste0('cov',j,',',i,'[1,1]')
      }else{
        labelMatrix[i,j] <- paste0('cov',i,',',j,'[1,1]')
      }
    }
  }
  model <- mxModel(model,mxMatrix(type='Full',nrow=maxColNumber,ncol=maxColNumber,free=FALSE,labels=labelMatrix,name='expCov'))

  #add fit functions
  exp          <- mxExpectationNormal(covariance="expCov", means="expMean", dimnames=manifests )
  funML        <- mxFitFunctionML()
  model <- mxModel(model,exp,funML)
}
