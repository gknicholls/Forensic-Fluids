elts5AllPartMat = enumerate.partitions(5)

elts5AllPartSet = apply(elts5AllPartMat, 1, 
                        function(z){
                          setCount = max(z)
                          sets = list()
                          for(setIndex in 1:setCount){
                            sets[[setIndex]] = sort(which(z == setIndex))
                          }
                          
                          return(sets)
                          
                        })
elts5AllPartSetStr = c()
for(partIndex in 1:length(elts5AllPartSet)){
  setsStr = c()
  for(setIndex in 1:length(elts5AllPartSet[[partIndex]])){
    str1 = paste(elts5AllPartSet[[partIndex]][[setIndex]], collapse = ", ")
    setsStr[setIndex] = paste("[", str1, "]", sep="")
  }
  str2 = paste(setsStr, collapse = ", ")
  elts5AllPartSetStr[partIndex] = paste("[", str2, "]", sep="")
}


elts7AllPartMat = enumerate.partitions(7)

elts7AllPartSet = apply(elts7AllPartMat, 1, 
                        function(z){
                          setCount = max(z)
                          sets = list()
                          for(setIndex in 1:setCount){
                            sets[[setIndex]] = sort(which(z == setIndex))
                          }
                          
                          return(sets)
                          
                        })

elts7AllPartSetStr = c()
for(partIndex in 1:length(elts7AllPartSet)){
  setsStr = c()
  for(setIndex in 1:length(elts7AllPartSet[[partIndex]])){
    str1 = paste(elts7AllPartSet[[partIndex]][[setIndex]], collapse = ", ")
    setsStr[setIndex] = paste("[", str1, "]", sep="")
  }
  str2 = paste(setsStr, collapse = ", ")
  elts7AllPartSetStr[partIndex] = paste("[", str2, "]", sep="")
}

write(elts5AllPartSetStr, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt",
      ncolumns = 1,
      append = FALSE, sep = "\n")

write(elts7AllPartSetStr, 
      file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
      ncolumns = 1,
      append = FALSE, sep = "\n")