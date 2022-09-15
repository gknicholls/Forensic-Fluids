calcLikIntAllPart = function(eltsAllPartSet = NULL, 
                            sample = NULL, 
                            alphaC = NULL, 
                            betaC = NULL){
  
  pXgvColPartVec = vector(length = length(eltsAllPartSet))
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
        beta(alphaC + colPart1Count, betaC + colPart0Count) / beta(alphaC, betaC)
      
      # message(paste(alphaC,  colPart1Count, betaC,  colPartCellCount, colPart0Count, sep = " "))
      # message(lbeta(alphaC + colPart1Count, betaC + colPart0Count))
    }
   
  }
  # message(paste(pXgvColPartVec, collapse=", "))
  
  return(pXgvColPartVec)

}

## Calculate the log likelihood of a give fluid subtype
calcLogSubTypeLik = function(eltsAllPartSetList = NULL, 
                             eltsAllPartSetPriorList = NULL,
                             sample = NULL, mkrList = NULL, alphaC = NULL, betaC = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each marker group
  for(mkrGrpIndex in 1:length(mkrList)){
    
    ## Get the prior for column partitions within a marker group.
    colPartPriorVec = eltsAllPartSetPriorList[[mkrGrpIndex]]
    ## Calculate the likelihoods across all column partitions within a marker group
    colPartLikVec = calcLikIntAllPart(eltsAllPartSet = eltsAllPartSetList[[mkrGrpIndex]], 
                                      sample = sample[, mkrList[[mkrGrpIndex]]],
                                      alphaC = alphaC[mkrGrpIndex], 
                                      betaC = betaC[mkrGrpIndex])
    
    ## Calculate the log integrated posterior 
    ## for a given marker group for a subtype.
    logSubTypeLik = logSubTypeLik + 
      log(sum(colPartPriorVec * colPartLikVec ))
      
    
  }
  
  return(logSubTypeLik)
}

## Calculate the log likelihood of a give fluid type
calcLogTypeLik = function(eltsAllPartSetList = NULL, 
                          eltsAllPartSetPriorList = NULL, 
                          sample = NULL, 
                          subtypeList = NULL, 
                          mkrList = NULL, 
                          alphaC = NULL, 
                          betaC = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each subtype
  for(subtypeIndex in 1:length(subtypeList)){
    
    if(length(subtypeList[[subtypeIndex]]) > 0){
      
      ## Calculate the log subtype likelihood if the subtype is not empty.
      logSubTypeLik = logSubTypeLik + 
        calcLogSubTypeLik(eltsAllPartSetList = eltsAllPartSetList, 
                          eltsAllPartSetPriorList = eltsAllPartSetPriorList,
                          sample = sample[subtypeList[[subtypeIndex]], ],
                          mkrList = mkrList,
                          alphaC = alphaC, 
                          betaC = betaC)
    }
    
  }
  
  return(logSubTypeLik)
}

calcMDPColPrior = function(alpha = NULL, setList = NULL, setCountMax = NULL){
  
  mdpLik = exp(calcLogMDPPrior(alpha = alpha, subtypeList = setList, setCountMax = setCountMax))
  
  return(mdpLik)
  
}


## Calculate the MDP prior
calcLogMDPPrior = function(alpha = NULL, subtypeList = NULL, setCountMax = NULL){
  ## Extract the indexes of the non-empty subtypes.
  nonEmptySets = which(lapply(subtypeList, length) > 0)
  ## Calculate the number of non-empty subtypes.
  setCount = length(nonEmptySets)
  ## Extract the set sizes of the non-empty subtypes
  setSizes = unlist(lapply(subtypeList, length))[nonEmptySets]
  
  ## Calculate the MDP prior
  logFrac1 = lgamma(alpha) - setCount*lgamma(alpha/setCountMax)
  logFrac2 = lfactorial(setCountMax) - lfactorial(setCountMax - setCount)
  logFrac3 = sum(lgamma(alpha/setCountMax + setSizes)) - lgamma(alpha + sum(setSizes))
  logPartPrior = logFrac1 + logFrac2 + logFrac3
  
  return(logPartPrior)
    
}

singleRowProposal = function(subtypeList = NULL, obsCount = NULL){
  ## Get the maximum number of subtypes permitted.
  setCountMax = length(subtypeList)
  ## Extract the indexes of the current non-empty subtypes.
  currSetSizes =  unlist(lapply(subtypeList, length))
  ## Extract the indexes of the current non-empty subtypes.
  currCumSumSetSize = cumsum(currSetSizes)
  ## Select a random observation with uniform probability 1/obsCount.
  currRowIndex = sample(1:obsCount, 1)
  ## Get the current subtype of the selected observation.
  currSet = min(which(currCumSumSetSize >= currRowIndex))
  ## Randomly choose a different subtype for the selected observation
  ## with uniform probability 1/(setCountMax - 1)
  propSet = sample(c(1:setCountMax)[-currSet], 1)
  
  ## Calculate the index of the selected observation within the current cluster. 
  prevSetSizeSum = c(0, currCumSumSetSize)[currSet]
  indexInCurrSet = currRowIndex - prevSetSizeSum
  ## Get the selected observation index
  currRow = subtypeList[[currSet]][indexInCurrSet]
  ## Remove the observation from its original subtype
  subtypeList[[currSet]] = subtypeList[[currSet]][-indexInCurrSet]
  ## Add the observation to proposed subtype
  subtypeList[[propSet]] = c(subtypeList[[propSet]], currRow)
  
  ## Because the number of observations and the setCountMax is fixed throughout the analysis,
  ## both the forward and backward proposals have the same probabilities.
  
  
  return(subtypeList)
  
}
# 
# # Work in progress!
# accept = 0
# chainLength = 10000
# sample.df = slv.df[,-1]
# sampleObsCount = nrow(sample.df)
# slvSubtypeList = list(c(1:16), 17:32, 33:48, 49:64, 65:81)
# mkr27EltsAllPartSetList = list(elts5AllPartSet, elts7AllPartSet, elts5AllPartSet, elts5AllPartSet, elts5AllPartSet)
# 
# elts5AllPartSetMDPPrior = unlist(lapply(mkr27EltsAllPartSetList[[1]], calcLogMDPColPrior, alpha = 1))
# elts7AllPartSetMDPPrior = unlist(lapply(mkr27EltsAllPartSetList[[2]], calcLogMDPColPrior, alpha = 1))
# mkr27EltsAllPartSetPriorList = list(elts5AllPartSetMDPPrior, 
#                                     elts7AllPartSetMDPPrior,
#                                     elts5AllPartSetMDPPrior,
#                                     elts5AllPartSetMDPPrior,
#                                     elts5AllPartSetMDPPrior)
# 
# logPriorCurr = calcLogMDPPrior(alpha = 1, subtypeList = slvSubtypeList)
# logLikCurr = calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList,
#                             eltsAllPartSetPriorList = mkr27EltsAllPartSetPriorList,
#                             sample = sample.df,
#                             subtypeList = slvSubtypeList,
#                             mkrList = mkrList,
#                             alphaC = 1,
#                             betaC = 1)
# logPostCurr = logPriorCurr + logLikCurr
# 
# postPart = matrix(nrow = chainLength, ncol = nrow(sample.df) + 3)
# for(stepIndex in 1:chainLength){
#   propSubtypeList = singleRowProposal(subtypeList = slvSubtypeList,
#                                       obsCount = sampleObsCount)
#   
#   logPriorProp = calcLogMDPPrior(alpha = 1, subtypeList = propSubtypeList)
#   logLikProp = calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList,
#                               eltsAllPartSetPriorList = mkr27EltsAllPartSetPriorList,
#                           sample = sample.df,
#                           subtypeList = propSubtypeList,
#                           mkrList = mkrList,
#                           alphaC = 1,
#                           betaC = 1)
#   logPostProp = logLikProp + logPriorProp
# 
#   if(log(runif(1)) <= min((logPostProp - logPostCurr), 0)){
#     logPriorCurr = logPriorProp
#     logLikCurr = logLikProp
#     logPostCurr = logPostProp
#     slvSubtypeList = propSubtypeList
#     accept = accept + 1
# 
#   }
# 
# 
#   for(setIndex in 1:length(slvSubtypeList)){
#     if(length(slvSubtypeList[[setIndex]]) > 0){
#       postPart[stepIndex, slvSubtypeList[[setIndex]]] = setIndex
#     }
#   }
#   
#   postPart[stepIndex, nrow(sample.df) + 1] = logPriorCurr
#   postPart[stepIndex, nrow(sample.df) + 2] = logLikCurr
#   postPart[stepIndex, nrow(sample.df) + 3] = logPostCurr
# 
#   if(stepIndex %% 100 == 0){
#     message(stepIndex)
#   }
# 
# }
# 
# temp1 = kmeans(sample.df, centers = 3, nstart = 10)
# # which(temp$cluster==1)
# 
# start = Sys.time()
# calcLogSubTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
#                   eltsAllPartSetPriorList = mkr27EltsAllPartSetPriorList,
#                   sample = slv.df[1:16,-1], mkrList = mkrList, alphaC = 1, betaC = 1)
# end = Sys.time()
# end- start
# # 
# # calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
# #                sample = slv.df, 
# #                subtypeList = slvSubtypeList, 
# #                mkrList = mkrList,
# #                alphaC = 1, 
# #                betaC = 1)
# # 
# # calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
# #                sample = sample.df, 
# #                subtypeList = list(which(temp$cluster==1), which(temp$cluster==2), which(temp$cluster==3)), 
# #                mkrList = mkrList,
# #                alphaC = 1, 
# #                betaC = 1)
# 
# par(mfrow = c(3,4), mar = c(5, 4, 1, 1))
# for(i in 0:9){
#   plot(x = 1:1000+1000*i, y = temp[1:1000+1000*i], type = "l",
#        xlab = "MCMC steps", ylab = "log-likelihood")
# }
