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
trainLoocvBayesBFList[[1]][c(17,41)]
#         17         41 
# 0.09556314 0.07793385
trainLoocvBayesBFList[[2]][c(13,16)]
#         72         75 
# 0.01965163 0.03768506
trainLoocvBayes.df[trainLoocvBayes.df$trueType=="cvf", 3:7][c(17,41),]
cvfPostProb mtbPostProb slvPostProb bldPostProb smnPostProb
# 17  0.02333333   0.9766667           0           0           0
# 41  0.01911111   0.9808889           0           0           0
trainLoocvBayes.df[trainLoocvBayes.df$trueType=="mtb", 3:7][c(13,16),]
cvfPostProb mtbPostProb slvPostProb bldPostProb smnPostProb
# 72   0.9951111 0.004888889           0           0           0
# 75   0.9906667 0.009333333           0           0           0

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
trainLoocvCutBFList[[1]][c(41)]
# 41 
# 0.09463148 
trainLoocvCutBFList[[2]][c(13,16)]
# 72         75 
# 0.02684564 0.04585300

testBayesSingleBFList = calcBFList(data.df = testBayesSingle.df)
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})
lapply(testBayesSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -2)})
testBayesSingleBFList[[1]][[6]]
# [1] 0.07331976
testBayesSingle.df[testBayesSingle.df$trueType=="cvf",][6,]
# sampleID trueType cvfPostProb mtbPostProb slvPostProb bldPostProb  smnPostProb
# 9  BV7_RTP      cvf       0.018   0.9815556           0           0 0.0004444444

testBayesJointBFList = calcBFList(data.df = testBayesJoint.df)
lapply(testBayesJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testBayesJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})

testCutSingleBFList = calcBFList(data.df = testCutSingle.df)
lapply(testCutSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testCutSingleBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})

testCutJointBFList = calcBFList(data.df = testCutJoint.df)
lapply(testCutJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1)})
lapply(testCutJointBFList, function(bayesFactor){which(log10(bayesFactor) < -1.5)})
