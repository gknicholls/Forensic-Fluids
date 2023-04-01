getSetSize<- function(setStr = NULL){
  setStr = gsub(setStr, pattern = "[", replace = "", fixed = T)
  setStr = gsub(setStr, pattern = "]", replace = "", fixed = T)
  setSize = length(unlist(strsplit(setStr, split = ",")))
  return(setSize)
}
getSetSize("[1,2,3]")


getSetSizes <- function(setsStr = NULL){
  setsStr = gsub(setsStr, pattern = "[[", replace = "[", fixed = T)
  setsStr = gsub(setsStr, pattern = "]]", replace = "]", fixed = T)
  setsStrVec = unlist(strsplit(setsStr, split = "],[", fixed = T))
  
  setSizes = sapply(setsStrVec, getSetSize)
  names(setSizes) = NULL
  return(setSizes)
}

getSetSizes("[[1,2,3]]")
getSetSizes("[[1,2,3],[1,2]]")

loocvTrain_slv_2_smn_subtypes = sapply(loocvTrain_slv_2.df$typeList,
       function(z, type){
         unlist(strsplit(z, split=" "))[type]
       }, type= 5)
names(loocvTrain_slv_2_smn_subtypes) = NULL
loocvTrain_slv_2_smn_setSizes  = sapply(loocvTrain_slv_2_smn_subtypes, getSetSizes)

hist(unlist(lapply(loocvTrain_slv_2_smn_setSizes, length)))



loocvTrain_slv_2_mode1Index = c(10:2300,9151:12100,14101:16800,18201:19700, 20301:20900, 21101:22400)
loocvTrain_slv_2_mode2Index = c(2301:9149, 12101:14100, 16801:18200, 19701:20300, 20900:21100, 22401:23096)

summary(unlist(lapply(loocvTrain_slv_2_setSizes, length))[loocvTrain_slv_2_mode1Index])
summary(unlist(lapply(loocvTrain_slv_2_setSizes, length))[loocvTrain_slv_2_mode2Index])

hist(unlist(lapply(loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode1Index], length)))
hist(unlist(lapply(loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index], length)))





loocvTrain_slv_2_smn_mode1_rank4_setSize = 
  unlist(lapply(loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode1Index], 
                function(z){
                  setSize = sort(z, decreasing = T)[5]
                  setSize = ifelse(is.na(setSize), 0, setSize)
                  return(setSize)
                }
  ))

loocvTrain_slv_2_smn_mode2_rank4_setSize = 
  unlist(lapply(loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index], 
                function(z){
                  setSize = sort(z, decreasing = T)[5]
                  setSize = ifelse(is.na(setSize), 0, setSize)
                  return(setSize)
                }
  ))


getSizeRankInfo = function(setNameStr = NULL, setSizeVec = NULL, rankNum = NULL){
  setSize = sort(setSizeVec, decreasing = T)[rankNum]
  setSize = ifelse(is.na(setSize), 0, setSize)
  
  setNameVec = unlist(strsplit(setNameStr, split = "],[", fixed = T))
  setName = setNameVec[order(setSizeVec, decreasing = T)[rankNum]]
  setName = gsub(setName, pattern = "[[", replace = "", fixed = T)
  setName = gsub(setName, pattern = "]]", replace = "", fixed = T)
  return(list(setSize, setName))
}

getSizeRankInfo(setNameStr = loocvTrain_slv_2_smn_subtypes[loocvTrain_slv_2_mode2Index][[430]],
                setSizeVec = loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index][[430]], 4)


getSetSizeRankInfo = function(setNameList = NULL, setSizeList = NULL, rankNum = NULL){
  
  temp = mapply(getSizeRankInfo,
                setNameStr = setNameList,
                setSizeVec = setSizeList, 
                rankNum = rankNum )
  setSizeInfo.df = data.frame(size = unlist(temp[1,]), set = unlist(temp[2,]) )
  return(setSizeInfo.df)
}

getSetIDCounts = function(setStrVec = NULL, maxVal = NULL){
  counts = rep(0, maxVal)
  for(setStr in setStrVec){
    setIDs = as.numeric(unlist(strsplit(setStr, split = ",")))
    
    if(!any(is.na(setIDs)) ){
      counts[setIDs+1] = counts[setIDs+1] + 1
    }
  }
  
  return(counts)
}

loocvTrain_slv_2_smn_mode1_setInfo_rank4 = 
  getSetSizeRankInfo(setNameList = loocvTrain_slv_2_smn_subtypes[loocvTrain_slv_2_mode1Index], 
                     setSizeList = loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode1Index], 
                     rankNum = 4)

loocvTrain_slv_2_smn_mode2_setInfo_rank4 = 
  getSetSizeRankInfo(setNameList = loocvTrain_slv_2_smn_subtypes[loocvTrain_slv_2_mode2Index], 
                     setSizeList = loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index], 
                     rankNum = 4)

loocvTrain_slv_2_smn_mode2_setInfo_rank5 = 
  getSetSizeRankInfo(setNameList = loocvTrain_slv_2_smn_subtypes[loocvTrain_slv_2_mode2Index], 
                     setSizeList = loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index], 
                     rankNum = 5)


loocvTrain_slv_2_smn_mode1_setObs_counts = getSetIDCounts(setStrVec = loocvTrain_slv_2_smn_mode1_setInfo_rank4[,2], maxVal = 321)
loocvTrain_slv_2_smn_mode1_setObs_counts = loocvTrain_slv_2_smn_mode1_setObs_counts [-c(87:320)]

loocvTrain_slv_2_smn_mode2_setObs_counts = getSetIDCounts(setStrVec = loocvTrain_slv_2_smn_mode2_setInfo_rank4[,2], maxVal = 321)
loocvTrain_slv_2_smn_mode2_setObs_counts = loocvTrain_slv_2_smn_mode2_setObs_counts[-c(87:320)]

loocvTrain_slv_2_smn_mode2_setObs_rank5_counts = 
  getSetIDCounts(setStrVec = loocvTrain_slv_2_smn_mode2_setInfo_rank5[,2], maxVal = 321)
loocvTrain_slv_2_smn_mode2_setObs_rank5_counts = 
  loocvTrain_slv_2_smn_mode2_setObs_rank5_counts[-c(87:320)]

barplot(loocvTrain_slv_2_smn_mode1_setObs_counts)
barplot(loocvTrain_slv_2_smn_mode2_setObs_counts)
barplot(loocvTrain_slv_2_smn_mode2_setObs_rank5_counts)

order(abs(loocvTrain_slv_2_smn_mode1_setObs_counts/sum(loocvTrain_slv_2_smn_mode1_setObs_counts)-
loocvTrain_slv_2_smn_mode2_setObs_counts/sum(loocvTrain_slv_2_smn_mode2_setObs_counts)))

setNameList = loocvTrain_slv_2_smn_subtypes[loocvTrain_slv_2_mode2Index]
setSizeList = loocvTrain_slv_2_smn_setSizes[loocvTrain_slv_2_mode2Index]

hist(loocvTrain_slv_2_smn_mode1_rank4_setSize, prob = T, nclass = 100)
hist(loocvTrain_slv_2_smn_mode2_rank4_setSize, prob = T, nclass = 100)
