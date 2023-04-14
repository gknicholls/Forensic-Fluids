
getModeTypeESSFromLog = function(logPath = NULL){
  log.df = read.table(file = logPath, header = T, as.is = T, sep = "\t")
  log.df = log.df[-c(1:ceiling(nrow(log.df)/10)), ]
  
  return(getModeTypeESSFromVec(log.df$unknownType.0))
}


getModeTypeESSFromVec = function(typeTrace = NULL){
  typeFreqTab = table(typeTrace)
  
  if(length(typeFreqTab) == 1){
    return(NA)
  }
  
  modeType = as.numeric(names(typeFreqTab)[which.max(typeFreqTab)])  
  isModeType = as.numeric(typeTrace == modeType)
  
  return(ESS(isModeType))
}

typeLabels = c("cvf", "mtb", "slv", "bld", "smn")

# Bayesian analysis with LOOCV on training set
trainLOOCVBayesModeTypeESSList = list()
for(type in typeLabels){
  trainLoocvBayesFolderPath = paste("/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/", type, "/", sep = "")
  trainLoocvBayesFileNames = list.files(path = trainLoocvBayesFolderPath)
  trainLoocvBayesLogFileNames = trainLoocvBayesFileNames[grep(trainLoocvBayesFileNames, pattern = ".log")]
  trainLoocvBayesLogFileNames = trainLoocvBayesLogFileNames[-grep(trainLoocvBayesLogFileNames, pattern = ".ops")]
  trainLoocvBayesLogFilePaths = paste(trainLoocvBayesFolderPath, trainLoocvBayesLogFileNames, sep = "")
  trainLOOCVBayesModeTypeESSList[[type]] = sapply(trainLoocvBayesLogFilePaths, getModeTypeESSFromLog)
  
}


lapply(trainLOOCVBayesModeTypeESSList, summary)
summary(unlist(trainLOOCVBayesModeTypeESSList))
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 2772    4500    4500    4374    4500    4500      41 


# Cut-Model analysis with LOOCV on training set
trainLOOCVCutModeTypeESSList = list()
for(type in typeLabels){
  trainLoocvCutFolderPath = paste("/Users/chwu/Documents/research/bfc/paper/analysis/CutModel/", type, "/", sep = "")
  trainLoocvCutFileNames = list.files(path = trainLoocvCutFolderPath)
  trainLoocvCutLogFileNames = trainLoocvCutFileNames[grep(trainLoocvCutFileNames, pattern = ".log")]
  trainLoocvCutLogFileNames = trainLoocvCutLogFileNames[-grep(trainLoocvCutLogFileNames, pattern = ".ops")]
  trainLoocvCutLogFileNames = trainLoocvCutLogFileNames[grep(trainLoocvCutLogFileNames, pattern = "_side_")]
  trainLoocvCutLogFilePaths = paste(trainLoocvCutFolderPath, trainLoocvCutLogFileNames, sep = "")
  trainLOOCVCutModeTypeESSList[[type]] = sapply(trainLoocvCutLogFilePaths, getModeTypeESSFromLog)
  
}

lapply(trainLOOCVCutModeTypeESSList, summary)
summary(unlist(trainLOOCVCutModeTypeESSList))
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 2412    4468    4500    4363    4500    4500      42


testBayesJoint.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log",
                               header = T, as.is = T, sep = "\t")
testBayesJoint.df = testBayesJoint.df[-c(1:ceiling(nrow(testBayesJoint.df)/10)),]
testBayesJointModeTypeESS = 
  apply(testBayesJoint.df[,paste("unknownType", c(0:45), sep = ".")], 
        2, getModeTypeESSFromVec)
summary(testBayesJointModeTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 1672    3085    3955    3609    4234    4500       9 

testCutJoint.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/test_cut_side_all/testSamplesBin_2022_09_22_cut_side_all.log",
                               header = T, as.is = T, sep = "\t")
testCutJoint.df = testCutJoint.df[-c(1:ceiling(nrow(testCutJoint.df)/10)),]
testCutJointModeTypeESS = 
  apply(testCutJoint.df[,paste("unknownType", c(0:45), sep = ".")], 
        2, getModeTypeESSFromVec)
summary(testCutJointModeTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 2402    4295    4500    4263    4500    4500       8 

testBayesSingleFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/test/bayes/"
testBayesSingleFileNames = list.files(path = testBayesSingleFolderPath)
testBayesSingleLogFileNames = testBayesSingleFileNames[grep(testBayesSingleFileNames, pattern = ".log")]
testBayesSingleLogFileNames = testBayesSingleLogFileNames[-grep(testBayesSingleLogFileNames, pattern = ".ops")]
testBayesSingleLogFilePaths = paste(testBayesSingleFolderPath, testBayesSingleLogFileNames, sep = "")
testBayesSingleModeTypeESS = sapply(testBayesSingleLogFilePaths, getModeTypeESSFromLog)
summary(testBayesSingleModeTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 1313    4455    4500    4253    4500    4500      11 

testCutSingleFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/test/cut/"
testCutSingleFileNames = list.files(path = testCutSingleFolderPath)
testCutSingleLogFileNames = testCutSingleFileNames[grep(testCutSingleFileNames, pattern = ".log")]
testCutSingleLogFileNames = testCutSingleLogFileNames[grep(testCutSingleLogFileNames, pattern = "side")]
testCutSingleLogFilePaths = paste(testCutSingleFolderPath, testCutSingleLogFileNames, sep = "")
testCutSingleModeTypeESS = sapply(testCutSingleLogFilePaths, getModeTypeESSFromLog)
summary(testCutSingleModeTypeESS)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 936.1  4500.0  4500.0  4273.6  4500.0  4500.0       9

testBayesJointJ1L1.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_c1e-10_all.log",
                                   header = T, as.is = T, sep= "\t")
testBayesJointJ1L1.df = testBayesJointJ1L1.df[-c(1:ceiling(nrow(testBayesJointJ1L1.df)/10)),]
dim(testBayesJointJ1L1.df )
testBayesJointJ1L1TypeESS = apply(testBayesJointJ1L1.df[,paste("unknownType", c(0:45), sep = ".")], 2, getModeTypeESSFromVec)
summary(testBayesJointJ1L1TypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 3117    4500    4500    4305    4500    4500       9 

testBayesJointJ1LMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_all.log",
                                   header = T, as.is = T, sep= "\t")
testBayesJointJ1LMax.df = testBayesJointJ1LMax.df[-c(1:ceiling(nrow(testBayesJointJ1LMax.df)/10)),]
dim(testBayesJointJ1LMax.df )
testBayesJointJ1LMaxTypeESS = apply(testBayesJointJ1LMax.df[,paste("unknownType", c(0:45), sep = ".")], 2, getModeTypeESSFromVec)
summary(testBayesJointJ1LMaxTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 3496    4088    4500    4302    4500    4500       9 

testBayesJointJ10LMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J10_all.log",
                                     header = T, as.is = T, sep= "\t")
testBayesJointJ10LMax.df = testBayesJointJ10LMax.df[-c(1:ceiling(nrow(testBayesJointJ10LMax.df)/10)),]
dim(testBayesJointJ10LMax.df )
testBayesJointJ10LMaxTypeESS = apply(testBayesJointJ10LMax.df[,paste("unknownType", c(0:45), sep = ".")], 2, getModeTypeESSFromVec)
summary(testBayesJointJ10LMaxTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 1856    2745    3703    3513    4119    4500       6 

testBayesJointJ15LMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J15_all.log",
                                      header = T, as.is = T, sep= "\t")
testBayesJointJ15LMax.df = testBayesJointJ15LMax.df[-c(1:ceiling(nrow(testBayesJointJ15LMax.df)/10)),]
dim(testBayesJointJ15LMax.df )
testBayesJointJ15LMaxTypeESS = apply(testBayesJointJ15LMax.df[,paste("unknownType", c(0:45), sep = ".")], 2, getModeTypeESSFromVec)
summary(testBayesJointJ15LMaxTypeESS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 1277    3107    3765    3531    4226    4500       5 
