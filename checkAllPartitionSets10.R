allPartSets10 = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/allPartitionSets.txt",
     what = character(), sep="\n")

allPartSets10List = sapply(allPartSets10, function(z){
  tmp1 = gsub(z, pattern="[[", replace = "", fixed = T)
  tmp1 = gsub(tmp1, pattern="]]", replace = "", fixed = T)
  partSets = 
    lapply(sapply(unlist(strsplit(tmp1, split="], [", fixed = T)), strsplit, split = ", "), 
           as.numeric)
  return(partSets)
})


allPartSets10Mat = lapply(allPartSets10List, function(z){
  vec = vector(length = 10)
  for(i in 1:length(z)){
    vec[unlist(z[i])] = i
  }
  return(vec)
})

allPartSets10Mat = do.call(rbind, allPartSets10Mat)
rownames(allPartSets10Mat) = NULL

allPartSets10Str = sort(apply(allPartSets10Mat, 1, paste, collapse= ""))
allPartSets10Str2 = sort(apply(allPartSets10MatV2, 1, paste, collapse= ""))

library(salso)
allPartSets10MatV2 = enumerate.partitions(10)
all(allPartSets10Str == allPartSets10Str2)

save(allPartSets10List,
     file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/allPartSets10.RData")