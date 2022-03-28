calLikIntAllPart = function(eltsAllPartSet = NULL, sample = NULL){
  
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
calcLogSubTypeLik = function(eltsAllPartSet = NULL, sample = NULL, mkrList = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each marker group
  for(mkrGrpIndex in 1:length(mkrList)){

    logSubTypeLik = logSubTypeLik + 
      log(calLikIntAllPart(eltsAllPartSet = elts5AllPartSet, 
                           sample = sample[, mkrList[[mkrGrpIndex]]]))
      
    
  }
  
  return(logSubTypeLik)
}

## Calculate the log likelihood of a give fluid type
calcLogTypeLik = function(eltsAllPartSet = NULL, sample = NULL, subtypeList = NULL, mkrList = NULL){
  
  logSubTypeLik = 0
  
  ## Iterate through each subtype
  for(subtypeIndex in 1:length(subtypeList)){
    
    logSubTypeLik = logSubTypeLik + 
      calcLogSubTypeLik(eltsAllPartSet = eltsAllPartSet, 
                           sample = sample[subtypeList[[subtypeIndex]],],
                           mkrList = mkrList)
    
    
  }
  
  return(logSubTypeLik)
}


# calcLogSubTypeLik(eltsAllPartSet = elts5AllPartSet, sample = slv.df, mkrList = mkrList)
# calLikIntAllPart(eltsAllPartSet = elts5AllPartSet, sample = slv.sub.col5.df)


