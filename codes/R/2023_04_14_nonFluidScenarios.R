trainBayesJf5LgMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/test_cut_side_all/testSamplesBin_cut_2022_09_22_main.log",
           header = T, as.is = T, sep ="\t")
trainBayesJf5LgMax.df = trainBayesJf5LgMax.df[-c(1:ceiling(nrow(trainBayesJf5LgMax.df))/10 ),]
trainBayesJf10LgMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_cut_2022_09_22_J10_main.log",
                                   header = T, as.is = T, sep ="\t")
trainBayesJf10LgMax.df = trainBayesJf10LgMax.df[-c(1:ceiling(nrow(trainBayesJf10LgMax.df))/10 ),]
trainBayesJf15LgMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_cut_2022_09_22_J15_main.log",
                                    header = T, as.is = T, sep ="\t")
trainBayesJf15LgMax.df = trainBayesJf10LgMax.df[-c(1:ceiling(nrow(trainBayesJf15LgMax.df))/10 ),]


random1_0.5_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_0.5_cut_side.log",
                                   header = T, as.is = T, sep ="\t")
random1_0.5_cut_side.df = random1_0.5_cut_side.df[-c(1:ceiling(nrow(random1_0.5_cut_side.df))/10 ),]

random1_0.6_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_0.6_cut_side.log",
                                     header = T, as.is = T, sep ="\t")
random1_0.6_cut_side.df = random1_0.6_cut_side.df[-c(1:ceiling(nrow(random1_0.6_cut_side.df))/10 ),]

random1_0.7_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_0.7_cut_side.log",
                                     header = T, as.is = T, sep ="\t")
random1_0.7_cut_side.df = random1_0.7_cut_side.df[-c(1:ceiling(nrow(random1_0.7_cut_side.df))/10 ),]


random1_0.8_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_0.8_cut_side.log",
                                     header = T, as.is = T, sep ="\t")
random1_0.8_cut_side.df = random1_0.8_cut_side.df[-c(1:ceiling(nrow(random1_0.8_cut_side.df))/10 ),]

random1_0.9_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_0.9_cut_side.log",
                                     header = T, as.is = T, sep ="\t")
random1_0.9_cut_side.df = random1_0.9_cut_side.df[-c(1:ceiling(nrow(random1_0.9_cut_side.df))/10 ),]

random1_1.0_cut_side.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_04_14/random1_1.0_cut_side.log",
                                     header = T, as.is = T, sep ="\t")
random1_1.0_cut_side.df = random1_1.0_cut_side.df[-c(1:ceiling(nrow(random1_1.0_cut_side.df))/10 ),]


getSubtypeCounts = function(typeList = NULL, obsCount = NULL){
  setList = strsplit(typeList, split = " ")
  setList = lapply(setList, gsub, pattern = "[[", replace = "[", fixed = T)
  setList = lapply(setList, gsub, pattern = "]]", replace = "]", fixed = T)
  setCountList  = lapply(setList , function(z){
    z = strsplit(z, split = "],[", fixed = T)
    z = lapply(z, gsub, pattern = "[", replace ="", fixed = T)
    z = lapply(z, gsub, pattern = "]", replace ="", fixed = T)
    return(z)
  })
  
  subtypeSizeMat = matrix(nrow = length(setCountList), ncol = obsCount)
  prevCum = c(0, 59, 90, 170, 235)
  for(sampleIndex in 1:length(setCountList)){
    for(typeIndex in 1:5){
      
      subtypes = setCountList[[sampleIndex]][[typeIndex]]
      for(subtypeIndex in 1:length(subtypes)){
        subtypeElts = as.numeric(unlist(strsplit(subtypes[subtypeIndex], split = "," )))
        obsIndex = subtypeElts + as.numeric(subtypeElts<321)*prevCum[typeIndex] + 1
        subtypeSizeMat[sampleIndex, obsIndex] = length(subtypeElts)
      }
    }
  }
  
  return(subtypeSizeMat)
}

trainBayesJf5LgMaxSubtypeSizePostDistr = getSubtypeCounts(typeList = trainBayesJf5LgMax.df$typeList, obsCount = 321)
trainBayesJf5LgMaxSingletonPostProbs = apply(trainBayesJf5LgMaxSubtypeSizePostDistr, 2, 
                           function(size){length(which(size==1)) })/nrow(trainBayesJf5LgMaxSubtypeSizePostDistr)
plot(sort(trainBayesJf5LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf5LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))

trainBayesJf10LgMaxSubtypeSizePostDistr = getSubtypeCounts(typeList = trainBayesJf10LgMax.df$typeList, obsCount = 321)
trainBayesJf10LgMaxSingletonPostProbs = 
  apply(trainBayesJf10LgMaxSubtypeSizePostDistr , 2, 
        function(size){
          length(which(size==1)) })/nrow(trainBayesJf10LgMaxSubtypeSizePostDistr )
summary(trainBayesJf10LgMaxSingletonPostProbs)
plot(sort(trainBayesJf10LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf10LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))



trainBayesJf15LgMaxSubtypeSizePostDistr =
  getSubtypeCounts(typeList = trainBayesJf15LgMax.df$typeList, obsCount = 321)
trainBayesJf15LgMaxSingletonPostProbs = 
  apply(trainBayesJf15LgMaxSubtypeSizePostDistr , 2, 
        function(size){
          length(which(size==1)) })/nrow(trainBayesJf15LgMaxSubtypeSizePostDistr )
summary(trainBayesJf15LgMaxSingletonPostProbs)
plot(sort(trainBayesJf15LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf15LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))

par(mfrow = c(2,2))
plot(sort(trainBayesJf5LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf5LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))
plot(sort(trainBayesJf10LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf10LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))
plot(sort(trainBayesJf15LgMaxSingletonPostProbs, decreasing = T), type = "n")
text(x = 1:321, y = trainBayesJf15LgMaxSingletonPostProbs, label = 1:321, cex = 0.75,
     col = rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86)))



random1CutSideList = list(random1_0.5_cut_side.df, 
                          random1_0.6_cut_side.df,
                          random1_0.7_cut_side.df, 
                          random1_0.8_cut_side.df,
                          random1_0.9_cut_side.df, 
                          random1_1.0_cut_side.df)

random1CutSingletonPostProbsList = list()
for(aIndex in 1:length(random1CutSideList)){
  random1CutSubtypeSizePostDistr  =
    getSubtypeCounts(typeList = random1CutSideList[[aIndex]]$typeList, obsCount = 322)
  random1CutSingletonPostProbsList[[aIndex]] = 
    apply(random1CutSubtypeSizePostDistr , 2, 
          function(size){
            length(which(size==1)) })/nrow(random1CutSubtypeSizePostDistr)
  
}

par(mfrow = c(3, 2), mar = c(4, 4, 3,2) + 0.2)
for(aIndex in 1:length(random1CutSideList)){
 
  
  plot(x = c(1, 322), range(random1CutSingletonPostProbsList[[aIndex]]), type = "n", ylim = c(0,1),
       xlab = "Obs. index", ylab = "Singleton posterior probability",
       main = paste("Proportion of 1's:", c(4 + aIndex)/10))
  text(x = 1:322, y = random1CutSingletonPostProbsList[[aIndex]], label = 1:322, cex = 0.75,
       col = c(rep(c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"), c(59,31,80,65,86) ),1 ))
}

unlist(lapply(random1CutSingletonPostProbsList, function(z){return(z[322])}))
