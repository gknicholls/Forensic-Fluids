calLikIntAllPart = function(eltsAllPartSet = NULL, 
                            sample = NULL, 
                            alphaC = NULL, 
                            betaC = NULL){
  
  pXgvColPartVec = vector(length = length(elts5AllPartSet))
  ## Iterate through all possible partitions across 5 columns.
  for(partIndex in 1:length(eltsAllPartSet)){
    
    ## Initiate the likelihood for calculating the product of 
    ## likelihoods across sets within the current partition scheme.
    pXgvColPartVec[partIndex] = 1
    setCount = length(eltsAllPartSet[[partIndex]])
    
    ## Iterate through each set within the current partition scheme for 5 columns.
    for(setIndex in 1:setCount){
      
      ## Extract the columns of the current set.
      setCols = sample[, eltsAllPartSet[[partIndex]][[setIndex]]]
      colPartCellCount = NA
      setColsDim = dim(setCols)
      
      
      if(is.null(setColsDim)){
        
        ## If there is only a single column, then the total number of cells is 
        ## the length of that column.
        colPartCellCount = length(setCols)
        
      }else{
        
        ## Otherwise,the total number of cells is the product 
        ## if the dimensions of the 2-D lattice.
        colPartCellCount = prod(setColsDim)
      }
      
      ## Compute the number of 1's in the columns of the current set.
      colPart1Count = sum(sample[, eltsAllPartSet[[partIndex]][[setIndex]]])
      ## Compute the number of 0's in the columns of the current set.
      colPart0Count = colPartCellCount - colPart1Count
      ## Update the likelihood of that partition.
      pXgvColPartVec[partIndex] = pXgvColPartVec[partIndex] * 
        beta(alphaC + colPart1Count, betaC + colPart0Count)
    }
   
  }
  
  return(sum(pXgvColPartVec))

}

## Calculate the log likelihood of a give fluid subtype
calcLogSubTypeLik = function(eltsAllPartSetList = NULL, sample = NULL, mkrList = NULL, alphaC = NULL, betaC = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each marker group
  for(mkrGrpIndex in 1:length(mkrList)){

    logSubTypeLik = logSubTypeLik + 
      log(calLikIntAllPart(eltsAllPartSet = eltsAllPartSetList[[mkrGrpIndex]], 
                           sample = sample[, mkrList[[mkrGrpIndex]]],
                           alphaC = alphaC, betaC = betaC))
      
    
  }
  
  return(logSubTypeLik)
}

## Calculate the log likelihood of a give fluid type
calcLogTypeLik = function(eltsAllPartSetList = NULL, sample = NULL, subtypeList = NULL, mkrList = NULL, alphaC = NULL, betaC = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each subtype
  for(subtypeIndex in 1:length(subtypeList)){
    if(length(subtypeList[[subtypeIndex]]) > 0){
      logSubTypeLik = logSubTypeLik + 
        calcLogSubTypeLik(eltsAllPartSetList = eltsAllPartSetList, 
                          sample = sample[subtypeList[[subtypeIndex]], ],
                          mkrList = mkrList,
                          alphaC = alphaC, 
                          betaC = betaC)
    }
    
  }
  
  return(logSubTypeLik)
}

## Calculate the MDP prior
calcLogMDPPrior = function(alpha = NULL, subtypeList = NULL){
  setCountMax = length(subtypeList)
  setCount = length(subtypeList)
  setSizes = unlist(lapply(subtypeList, length))
  logFrac1 = lgamma(alpha) - setCount*lgamma(alpha/setCountMax)
  logFrac2 = lfactorial(setCountMax) - lfactorial(setCountMax - setCount)
  logFrac3 = sum(lgamma(alpha/setCountMax + setSizes)) - lgamma(alpha + sum(setSizes))
  
  logPartPrior = logFrac1 + logFrac2 + logFrac3
  
  return(logPartPrior)
    
}

singleRowProposal = function(subtypeList = NULL, obsCount = NULL){
  setCountMax = length(subtypeList)
  currNonEmptySets =  unlist(lapply(subtypeList, length))
  currCumSumSetSize = cumsum(currNonEmptySets)
  currRowIndex = sample(1:obsCount, 1)
  #currRowIndex = 12
  currSet = min(which(currCumSumSetSize >= currRowIndex))
  propSet = sample(c(1:setCountMax)[-currSet], 1)
  prevSetSizeSum = c(0, currCumSumSetSize)[currSet]
  
 
  
  index = currRowIndex - prevSetSizeSum
  currRow = subtypeList[[currSet]][index]
  #message(currRow)
  subtypeList[[currSet]] = subtypeList[[currSet]][-index]
  subtypeList[[propSet]] = c(subtypeList[[propSet]], currRow)
  return(subtypeList)
  
}

# # Work in progress!
# accept = 0
# chainLength = 10000
# sample.df = slv.df[,-1]
# sampleObsCount = nrow(sample.df)
# slvSubtypeList = list(c(1:16), 17:32, 33:48, 49:64, 65:81)
# mkr27EltsAllPartSetList = list(elts5AllPartSet, elts7AllPartSet, elts5AllPartSet, elts5AllPartSet, elts5AllPartSet)
# 
# logPriorCurr = calcMDPPrior(alpha = 1, subtypeList = slvSubtypeList)
# logLikCurr = calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList,
#                             sample = sample.df,
#                             subtypeList = slvSubtypeList,
#                             mkrList = mkrList,
#                             alphaC = 1,
#                             betaC = 1)
# logPostCurr = logPriorCurr + logLikCurr
# 
# postPart = matrix(nrow = chainLength, ncol = nrow(sample.df))
# temp = c()
# for(stepIndex in 1:chainLength){
#   propSubtypeList = singleRowProposal(subtypeList = slvSubtypeList,
#                                       obsCount = sampleObsCount)
# 
#   logPriorProp = calcMDPPrior(alpha = 1, subtypeList = propSubtypeList)
#   logLikProp = calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList,
#                           sample = sample.df,
#                           subtypeList = propSubtypeList,
#                           mkrList = mkrList,
#                           alphaC = 1,
#                           betaC = 1)
#   logPostProp = logLikProp + logPriorProp
# 
#   propSubtypeList
#   logLikProp
#   logLikCurr
#   
#   if(log(runif(1)) <= min((logPostProp - logPostCurr), 0)){
#     logPriorCurr = logPriorProp
#     logLikCurr = logLikProp
#     logPostCurr = logPostProp
#     slvSubtypeList = propSubtypeList
#     accept = accept + 1
# 
#   }
#   temp[stepIndex] = logLikCurr
# 
# 
#   for(setIndex in 1:length(slvSubtypeList)){
#     if(length(slvSubtypeList[[setIndex]]) > 0){
#       postPart[stepIndex, slvSubtypeList[[setIndex]]] = setIndex
#     }
#   }
# 
#   if(stepIndex %% 100 == 0){
#     message(stepIndex)
#   }
# 
# }
# 
# temp = kmeans(sample.df, centers = 3, nstart = 10)
# which(temp$cluster==1)
# calcLogSubTypeLik(eltsAllPartSet = elts5AllPartSet, sample = slv.df, mkrList = mkrList, alphaC = 1, betaC = 1)
# 
# calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
#                sample = slv.df, 
#                subtypeList = slvSubtypeList, 
#                mkrList = mkrList,
#                alphaC = 1, 
#                betaC = 1)
# 
# calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
#                sample = sample.df, 
#                subtypeList = list(which(temp$cluster==1), which(temp$cluster==2), which(temp$cluster==3)), 
#                mkrList = mkrList,
#                alphaC = 1, 
#                betaC = 1)


