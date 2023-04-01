getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}

exptdType = c(1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 3, 
              5, 1, 1, 5, 5, 4, 1, 1, 1, 5, 4, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 1, 1)

testCutLOOCVTypePost<-matrix(nrow = 46, ncol = 5)
testCutLOOCVFolder = "/Users/chwu/Documents/research/bfc/paper/analysis/test/cut/"
for(sampleIndex in 1:46){
  filePath = paste(testCutLOOCVFolder, "testSamplesBin_2022_09_22_cut_side_", sampleIndex, ".log", sep = "")
  log.df <- read.table(file = filePath, header = T, as.is = T, sep = "\t")
  log.df <- log.df[-c(1:ceiling(nrow(log.df)/10)),]
  testCutLOOCVTypePost[sampleIndex, ] <- getTypeDistr(postTypeVar = log.df$unknownType.0)
  
}
# 
testCutLOOCVIncorrectModeIndex <- which(apply(testCutLOOCVTypePost, 1, which.max) - exptdType != 0)

table(exptdType, apply(testCutLOOCVTypePost, 1, which.max))


# Posterior mode
testCutLOOCVPosteriorMode = apply(testCutLOOCVTypePost, 1, max)
# Posterior odds
testCutLOOCVCorrectTypePost<-apply(cbind(testCutLOOCVTypePost, exptdType), 1, 
      function(vec){
        index = vec[length(vec)]
        return(vec[index])
      })
testCutLOOCVPosteriorOdds = testCutLOOCVCorrectTypePost/(1 - testCutLOOCVCorrectTypePost) 

jittedExptedType = exptdType + rnorm(46, 0, 0.15)
plot(exptdType, log10(testCutLOOCVPosteriorOdds), type = "n")
text(jittedExptedType, log10(testCutLOOCVPosteriorOdds), label = c(1:45), cex = 0.75)


sort(apply(testCutTypePost, 1, max))
order(apply(testCutTypePost, 1, max))
apply(testCutTypePost, 1, max)[setdiff(c(1:46), order(apply(testCutTypePost, 1, max))[1:13])]




testBayesLOOCVFolder = "/Users/chwu/Documents/research/bfc/paper/analysis/test/bayes/"
testBayesLOOCVTypePost<-matrix(nrow = 46, ncol = 5)
for(sampleIndex in 1:46){
  filePath = paste(testBayesLOOCVFolder, "testSamplesBin_2022_09_22_bayes_", sampleIndex, ".log", sep = "")
  log.df <- read.table(file = filePath, header = T, as.is = T, sep = "\t")
  log.df <- log.df[-c(1:ceiling(nrow(log.df)/10)),]
  testBayesLOOCVTypePost[sampleIndex, ] <- getTypeDistr(postTypeVar = log.df$unknownType.0)
}

testBayesLOOCVIncorrectModeIndex <- which(apply(testBayesLOOCVTypePost, 1, which.max) - exptdType != 0)
data.frame(exptdType[testBayesLOOCVIncorrectModeIndex ], 
           testCutLOOCVTypePost[testBayesLOOCVIncorrectModeIndex, ])
# Posterior mode
testBayesLOOCVPosteriorMode = apply(testBayesLOOCVTypePost, 1, max)
# Posterior odds
testBayesLOOCVCorrectTypePost<-apply(cbind(testBayesLOOCVTypePost, exptdType), 1, 
                                   function(vec){ index = vec[length(vec)]; return(vec[index])})
testBayesLOOCVPosteriorOdds = testBayesLOOCVCorrectTypePost/(1 - testBayesLOOCVCorrectTypePost) 
plot(exptdType, log10(testBayesLOOCVPosteriorOdds), type = "n", xlim = c(0.5, 5.5))
text(jittedExptedType, log10(testBayesLOOCVPosteriorOdds), label = c(1:46), cex = 0.75)


testBayesJoint.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log", header = T, as.is =T, sep = "\t")
testBayesJoint.df = testBayesJoint.df[-c(1:ceiling(nrow(testBayesJoint.df)/10)),]
testBayesJointTypePost <- t(apply(testBayesJoint.df[,17:62], 2, getTypeDistr))
testBayesJointPosteriorModeIndex <- which(apply(testBayesJointTypePost, 1, which.max) - exptdType != 0)
data.frame(exptdType[testBayesJointPosteriorModeIndex ], 
           testCutLOOCVTypePost[testBayesJointPosteriorModeIndex, ])

testBayesJointPosteriorMode = apply(testBayesJointTypePost, 1, max)
# Posterior odds
testBayesJointCorrectTypePost<-apply(cbind(testBayesJointTypePost, exptdType), 1, 
                                     function(vec){ index = vec[length(vec)]; return(vec[index])})
testBayesJointPosteriorOdds = testBayesJointCorrectTypePost/(1 - testBayesJointCorrectTypePost) 
plot(exptdType, log10(testBayesJointPosteriorOdds), type = "n", xlim = c(0.5, 5.5))
text(jittedExptedType, log10(testBayesJointPosteriorOdds), label = c(1:46), cex = 0.75)




testCutJoint.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/test_cut_side_all/testSamplesBin_2022_09_22_cut_side_all.log", 
                               header = T, as.is =T, sep = "\t")
testCutJoint.df = testCutJoint.df[-c(1:ceiling(nrow(testCutJoint.df)/10)),]
testCutJointTypePost <- t(apply(testCutJoint.df[,17:62], 2, getTypeDistr))

testCutJointPosteriorModeIndex<-which(apply(testCutJointTypePost, 1, which.max) - exptdType != 0)
data.frame(exptdType[testCutJointPosteriorModeIndex ], 
           testCutLOOCVTypePost[testCutJointPosteriorModeIndex, ])

testCutJointPosteriorMode = apply(testCutJointTypePost, 1, max)
# Posterior odds
testCutJointCorrectTypePost<-apply(cbind(testCutJointTypePost, exptdType), 1, 
                                     function(vec){ index = vec[length(vec)]; return(vec[index])})
testCutJointPosteriorOdds = testCutJointCorrectTypePost/(1 - testCutJointCorrectTypePost) 
plot(exptdType, log10(testCutJointPosteriorOdds), type = "n", xlim = c(0.5, 5.5))
text(jittedExptedType, log10(testCutJointPosteriorOdds), label = c(1:46), cex = 0.75)


postOdds <- cbind(testBayesLOOCVPosteriorOdds,
      testCutLOOCVPosteriorOdds,
      testBayesJointPosteriorOdds,
      testCutJointPosteriorOdds)
data.frame(exptedType = c("CVF", "MTB", "SLV", "BLD", "SMN")[sort(exptdType)], 
           round(postOdds[order(exptdType),], 3))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_03_10/testSMN33.pdf",
    height = 9, width = 10)
par(mfrow = c(2, 2))
barplot(testBayesLOOCVTypePost[33,], las = 1,
        ylab = "Posterior probability", main = "Bayes Single",
        names.arg = c("CVF", "MTB", "SLV", "BLD", "SMN"))
barplot(testCutLOOCVTypePost[33,], las = 1,
        ylab = "Posterior probability", main = "Cut Single",
        names.arg = c("CVF", "MTB", "SLV", "BLD", "SMN"))
barplot(testBayesJointTypePost[33,], las = 1,
        ylab = "Posterior probability", main = "Bayes Joint",
        names.arg = c("CVF", "MTB", "SLV", "BLD", "SMN"))
barplot(testCutJointTypePost[33,], las = 1,
        ylab = "Posterior probability", main = "Cut Joint",
        names.arg = c("CVF", "MTB", "SLV", "BLD", "SMN"))
dev.off()


table(exptdType, apply(testBayesLOOCVTypePost, 1, which.max))
table(exptdType, apply(testCutLOOCVTypePost, 1, which.max))
table(exptdType, apply(testBayesJointTypePost, 1, which.max))
table(exptdType, apply(testCutJointTypePost, 1, which.max))




test2022Bin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/test/2022_09_22/single source samples_29Sept22.csv",
                          header = T, as.is = T)

colnames(testBayesLOOCVTypePost) = paste(typeLabel, "PostProb", sep = "")
testBayesLOOCVCalibr.df = data.frame(sampleID = test2022Bin.df$Sample,
                               trueType = typeLabel[exptdType],
                               testBayesLOOCVTypePost)
rowSums(testBayesLOOCVCalibr.df[, 3:7])
write.csv(testBayesLOOCVCalibr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleBayesCalibr.csv",
          quote = F, row.names = F)

colnames(testCutLOOCVTypePost) = paste(typeLabel, "PostProb", sep = "")
testCutLOOCVCalibr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                     trueType = typeLabel[exptdType],
                                     testCutLOOCVTypePost)
rowSums(testCutLOOCVCalibr.df[, 3:7])
write.csv(testCutLOOCVCalibr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleCutCalibr.csv",
          quote = F, row.names = F)


colnames(testBayesJointTypePost) = paste(typeLabel, "PostProb", sep = "")
testBayesJointCalibr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                     trueType = typeLabel[exptdType],
                                     testBayesJointTypePost)
rowSums(testBayesJointCalibr.df[, 3:7])
write.csv(testBayesJointCalibr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesCalibr.csv",
          quote = F, row.names = F)

colnames(testCutJointTypePost) = paste(typeLabel, "PostProb", sep = "")
testCutJointCalibr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                   trueType = typeLabel[exptdType],
                                   testCutJointTypePost)
rowSums(testCutJointCalibr.df[, 3:7])
write.csv(testCutJointCalibr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointCutCalibr.csv",
          quote = F, row.names = F)