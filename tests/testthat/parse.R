#returns  the names of the parameters as string vectors and adds dollars to all stuff the needs to be replace, that is stuff in the data

getParamsBoth <- function(meanFunction,covFunction,data){
  bothFs <- paste(meanFunction,covFunction)
  #everything that is in the data is not a param
  #everything that is a reservered word or a operator is not a param

  #rest should be params
  return()
}

betterRegMatches <- function(modString,resGreg,value=' '){
  stopifnot(length(resGreg)==1)
  resGreg <- resGreg[[1]]
  for (i in 1:length(resGreg)){
    substr(modString,resGreg[i],resGreg[i]+attributes(resGreg)$match.length[i]-1) <- paste0(rep(value,attributes(resGreg)$match.length[i]),collapse = '')
  }
  return(modString)
}

getParams <- function(meanFunction,data){


  #get rid of all reserved chars
  splitters <- c('\\^','%\\^%','\\+','-','%\\*%','\\*','/','%x%','%&%','\\(','\\)',',','[[:alnum:]]*\\(')
  regExp <- paste0(splitters,'|',collapse = '')
  regExp <- substr(regExp,1,nchar(regExp)-1)
  grepRes <- gregexpr(regExp,meanFunction)
  newMeanFunction <- meanFunction
  newMeanFunction <- betterRegMatches(newMeanFunction, grepRes)

  #find all vars in the data
  dataNames <- setdiff(unique(gsub('[[:digit:]]','',names(data))),'Y') #get all variables in wide data set without Y
  dataNames <- paste0(dataNames,c('','!')) #add special char
  regExp <- paste0(dataNames,'|',collapse = '') #looking for all chars
  regExp <- substr(regExp,1,nchar(regExp)-1)
  regExp <- paste0('(?<= )(',regExp,')(?= )',collapse = '') #only look for stuff with whitespace before and after
                                                            #TODO: Beginning of the word
  grepRes <- gregexpr(regExp,newMeanFunction,perl = TRUE)

  #extract parameters, only thing left in the string
  newMeanFunction <- betterRegMatches(newMeanFunction, grepRes)
  params <- strsplit(newMeanFunction,'[[:space:]]+')

  #add dollars to orginal  function for the later replacement funtions
  toReplace <- grepRes[[1]]
  meanReturn <- meanFunction
  dollarPosition <- c(toReplace,toReplace+attributes(toReplace)$capture.length)
  dollarPosition <- sort(dollarPosition)
  for (i in 1:length(dollarPosition)){
    meanReturn <- paste0(substr(meanReturn,1,dollarPosition[i]-1),'$',substr(meanReturn,dollarPosition[i],nchar(meanReturn)),collapse='')
    dollarPosition <- dollarPosition+1
  }
  return(params[[1]])
}

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

# model
meanf <-'muI+muS*t'
covf <- 'varI+covIS*(t+t!)+varS*t*t!+delta(t,t!)*sigma'
test <- getParams(covf,myData)
