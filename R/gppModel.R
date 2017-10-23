newSeq <- function(from,to){
  if (to>=from){
    return(from:to)
  }else{

    return(c())
  }
}

#returns  the names of the parameters as string vectors and adds dollars to all stuff the needs to be replace, that is stuff in the data

betterRegMatches <- function(modString,resGreg,value=' '){
  stopifnot(length(resGreg)==1)
  resGreg <- resGreg[[1]]
  for (i in 1:length(resGreg)){
    substr(modString,resGreg[i],resGreg[i]+attributes(resGreg)$match.length[i]-1) <- paste0(rep(value,attributes(resGreg)$match.length[i]),collapse = '')
  }
  return(modString)
}

mParse <- function(meanFunction,myData){
  specialChar <- '!'

  #get rid of all reserved chars
  splitters <- c('\\^','%\\^%','\\+','-','%\\*%','\\*','/','%x%','%&%','\\(','\\)',',','[[:alnum:]]*\\(')
  regExp <- paste0(splitters,'|',collapse = '')
  regExp <- substr(regExp,1,nchar(regExp)-1)
  grepRes <- gregexpr(regExp,meanFunction)
  newMeanFunction <- meanFunction
  newMeanFunction <- betterRegMatches(newMeanFunction, grepRes)

  #find all vars in the data
  dataNames <- setdiff(unique(gsub('[[:digit:]]','',names(myData))),'Y') #get all variables in wide data set without Y
  dataNames <- paste0(dataNames,c('',specialChar)) #add special char
  regExp <- paste0(dataNames,'|',collapse = '') #looking for all chars
  regExp <- substr(regExp,1,nchar(regExp)-1)
  regExp <- paste0('(?<=^| )(',regExp,')(?=$| )',collapse = '') #only look for stuff with whitespace before and after
  grepRes <- gregexpr(regExp,newMeanFunction,perl = TRUE)

  #extract vars in data
  vars <- regmatches(newMeanFunction,grepRes)[[1]]
  vars <- gsub(specialChar,'',vars)
  vars <- unique(vars)


  #extract parameters
  newMeanFunction <- betterRegMatches(newMeanFunction, grepRes)
  params <- strsplit(newMeanFunction,'[[:space:]]+')[[1]]
  isnotNumber <- suppressWarnings(is.na(as.double(params)))
  params <- params[isnotNumber]

  #add dollars to orginal  function for the later replacement funtions
  toReplace <- grepRes[[1]]
  meanReturn <- meanFunction
  dollarPosition <- c(toReplace,toReplace+attributes(toReplace)$capture.length)
  dollarPosition <- sort(dollarPosition)
  for (i in 1:length(dollarPosition)){
    meanReturn <- paste0(substr(meanReturn,1,dollarPosition[i]-1),'$',substr(meanReturn,dollarPosition[i],nchar(meanReturn)),collapse='')
    dollarPosition <- dollarPosition+1
  }
  return(list(params=params,modelF=meanReturn,vars=vars))
}

parseModel <- function(meanFunction,covFunction,myData){
  #parse kernel function
  covRes <- mParse(covFunction,myData)

  #parse mean funnction
  meanRes <- mParse(meanFunction,myData)

  #join information
  params <- union(meanRes$params,covRes$params)
  vars <- union(meanRes$vars,covRes$vars)
  return(list(params=params,meanFunction=meanRes$modelF,covFunction=covRes$modelF,vars=vars))
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

#' @export
#' @import OpenMx
gppModel <- function(meanFunction,covFunction,data){

  ##create empty open mx model
  N <- nrow(data)
  maxColNumber <- max(ysize)
  dataForOpenMx <- data
  manifests <- paste0('Y',1:maxColNumber)
  model <- mxModel(model="GPPM",
          manifestVars = manifests,
          mxData(dataForOpenMx,type="raw"),
          mxMatrix(type='Full',nrow=1,ncol=maxColNumber,labels=paste0("data.time",1:maxColNumber),name='T'))





  parsedModel <- parseModel(meanf,covf,myData)

  ##add params to the model
  allParams <- parsedModel <-
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
      browser()
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
