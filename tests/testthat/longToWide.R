gpWideToLong <- function(wideData,ID=NA){
  #if no ID create ID
  if (is.na(ID)){
    wideData$ID <- 1:nrow(wideData)
    ID<- 'ID'
  }

  #get maximum number in the data frame
  cNames <- paste0(colnames(wideData))
  nums <- sub('[[:alpha:]]*','',cNames)
  nums <- strtoi(nums)
  maxNum <- max(nums,na.rm=TRUE)

  #get all variabe names
  theNames <- sub('[[:digit:]]','',cNames)
  theNames <- unique(theNames)

  #init data frame
  nWide <- nrow(wideData)
  nVars <- length(theNames)
  longData <- data.frame(matrix(nrow=nWide*maxNum,ncol = nVars))
  lIndex <- 1
  theNames2 <- setdiff(theNames,ID)
  colnames(longData) <- c(ID,theNames2)
  for (i in 1:nrow(wideData)){
    for (j in 1:maxNum){
      longData[lIndex,] <- wideData[i,c(ID,paste0(theNames2,j))]
      lIndex <- lIndex + 1
    }
  }
  return(longData)
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
yVector <- simulateData(trueModel,N=nP)
tVector <- matrix(rep(0:(nT-1),each=nP),nrow = nP,ncol = nT)
colnames(tVector) <- paste0('t',1:nT)
colnames(yVector) <- paste0('y',1:nT)
wideData <- cbind(tVector,yVector)
wideData <- as.data.frame(myData)
longData <- gpWideToLong(wideData)
