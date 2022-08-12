gridPlot = function(type = NULL, 
                    singleBinPerType.mat = NULL,
                    printInfo = FALSE,
                    clusterAssign = NULL,
                    unknown = NULL,
                    colours = c("white",  "#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28")){
  
  if(max(clusterAssign) > 1 & !is.null(unknown)){
    subtype = clusterAssign[unknown]
    subtypeElt = which(clusterAssign == subtype)
    subtypeMaxElt = which(clusterAssign == max(clusterAssign))
    clusterAssign[subtypeElt] = max(clusterAssign)
    clusterAssign[subtypeMaxElt] = subtype
    if(length(subtypeElt) > 1){
      clusterAssign[unknown] = max(clusterAssign) + 1
    }
  }
  
  singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  
  
  # if(length(unknown) == 0){
  #   singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  # }else{
  #   singleBinPerType.mat[-unknown, ] = singleBinPerType.mat[-unknown, ]*clusterAssign[-unknown]
  #   singleBinPerType.mat[unknown, ] = singleBinPerType.mat[unknown, ]*(max(clusterAssign) + 1)
  # }
  
  
  orderByCluster = order(clusterAssign)
  
  image(t(singleBinPerType.mat[orderByCluster,]),
        col = colours, 
        axes = FALSE,
        main = type)
  box(which = "plot",lty = "solid")
  grid(nx = 27 , ny = nrow(singleBinPerType.mat) , lty = "solid", lwd = 0.5)
  abline (v = 4.5 /26); 
  abline (v = 11.5 / 26) ; 
  abline (v = 16.5 / 26) ; 
  abline (v = 21.5 /26)
  
}


processParts = function(z){
  tmp1 = gsub(z, pattern="[[", replace = "", fixed = T)
  tmp1 = gsub(tmp1, pattern="]]", replace = "", fixed = T)
  partSets = 
    lapply(sapply(unlist(strsplit(tmp1, split="], [", fixed = T)), strsplit, split = ", "), 
           as.numeric)
  
  clusterIndicator = c()
  for(clusterIndex in 1:length(partSets)){
    clusterIndicator[partSets[[clusterIndex]]+1] = clusterIndex
  }
  return(clusterIndicator)
}


getclusterAssignIndex = function(partStr = NULL, unknownLabel = NULL, newUnknownLabel = NULL){
  partStr = gsub(gsub(partStr, 
                      pattern = unknownLabel, 
                      replace = newUnknownLabel),
                 pattern = ",", replace = ", ")
  partStr = unname(partStr)
  clusterAssignIndex = unname(t(sapply(partStr, processParts)))
  rownames(clusterAssignIndex) = NULL
  colnames(clusterAssignIndex) = NULL
  
  return(list(parts = partStr, index = clusterAssignIndex))
}


getSubtypeSize = function(partition = NULL , unknownLabel = NULL){
  subTypes = unname(unlist(strsplit(partition, split = "], [", fixed = T)))
  
  subTypeSize = length(unlist(strsplit(subTypes[grep(subTypes , pattern =  unknownLabel)], split=", ")))
  subTypeSize = unname(subTypeSize)
  return(subTypeSize)
}




getPartsPerType = function(partition = NULL, targetStr = NULL, replaceStr = NULL){
  partStr = gsub(partition, 
                 pattern = targetStr, replace = replaceStr)
  parts = gsub(partStr, pattern = ",", replace = ", ")
  return(parts)
}

getSubtypeSizeOfTarget = function(partition = NULL, targetStr = NULL){
  subTypes = unlist(strsplit(partition, split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = targetStr)], split=", ")))
}
