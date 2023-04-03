trainLoocvBayes.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/loocvBayesCalibr.csv",
                            header = T, as.is = T)
trainLoocvCut.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/loocvCutCalibr.csv",
                            header = T, as.is = T)
testBayesSingle.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleBayesCalibr.csv",
                              header = T, as.is = T)
testBayesJoint.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesCalibr.csv",
                                   header = T, as.is = T)
testCutSingle.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleCutCalibr.csv",
                              header = T, as.is = T)
testCutJoint.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointCutCalibr.csv",
                             header = T, as.is = T)

calcBFList = function(types = c("cvf", "mtb", "slv", "bld", "smn"), data.df = NULL){
  bfList = list()
  for(typeIndex in 1:length(types)){
    correctTypePostProb = 
      data.df[data.df$trueType == types[typeIndex], 
              paste(types[typeIndex], "PostProb", sep="")]
    
    otherTypePostProb = rowSums(data.df[data.df$trueType == types[typeIndex], 
                                        paste(types[-typeIndex], "PostProb", sep="")])
    bfList[[typeIndex]] = correctTypePostProb/otherTypePostProb*4
    
  }
  
  return(bfList)
  
}
trainLoocvBayesBFList = calcBFList(data.df = trainLoocvBayes.df)
lapply(trainLoocvBayesBFList, function(bayesFactor){which(log10(bayesFactor/4) < -1)})
lapply(trainLoocvBayesBFList, function(bayesFactor){which(log10(bayesFactor/4) < -1.5)})
1/trainLoocvBayesBFList[[1]][c(17,41)]
trainLoocvBayesBFList[[2]][c(13,16)]
trainLoocvBayes.df[trainLoocvBayes.df$trueType=="cvf", 3:7][c(17,41),]
trainLoocvBayes.df[trainLoocvBayes.df$trueType=="mtb", 3:7][c(13,16),]

# trainLoocvCutBFList = list()
# for(typeIndex in 1:length(types)){
#   correctTypePostProb = 
#     trainLoocvCut.df[trainLoocvCut.df$trueType == types[typeIndex], 
#                      paste(types[typeIndex], "PostProb", sep="")]
#   
#   otherTypePostProb = rowSums(trainLoocvCut.df[trainLoocvCut.df$trueType == types[typeIndex], 
#                                                paste(types[-typeIndex], "PostProb", sep="")])
#   trainLoocvCutBFList[[typeIndex]] = correctTypePostProb/otherTypePostProb*4
#   
# }
trainLoocvCutBFList = calcBFList(data.df = trainLoocvCut.df)
lapply(trainLoocvCutBFList, function(bayesFactor){which(log10(bayesFactor/4) < -1)})
lapply(trainLoocvCutBFList, function(bayesFactor){which(log10(bayesFactor/4) < -1.5)})
trainLoocvBayesBFList[[1]][c(41)]
trainLoocvBayesBFList[[2]][c(13,16)]

testBayesSingleBFList = calcBFList(data.df = testBayesSingle.df)
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -2)})
testBayesSingleBFList[[1]][[6]]
testBayesSingle.df[testBayesSingle.df$trueType=="cvf",][6,]

testBayesJointBFList = calcBFList(data.df = testBayesJoint.df)
lapply(testBayesJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testBayesJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})
testBayesJointBFList[[1]][[6]]

testCutSingleBFList = calcBFList(data.df = testCutSingle.df)
lapply(testCutSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testCutSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})

testCutJointBFList = calcBFList(data.df = testCutJoint.df)
lapply(testCutJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testCutJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})
