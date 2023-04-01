getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}
typeLabel = c("cvf", "mtb", "slv", "bld", "smn")
log.post.diff.list<-list()
correct.class.bayes.list<-list()
correct.class.cut.list<-list()
type.post.bayes.list<-list()
type.post.cut.list<-list()

for(typeIndex in 1:length(typeLabel)){
  bayesFolderPath = paste("/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/", typeLabel[typeIndex], "/", sep="")
  bayesFolderFiles<-dir(bayesFolderPath)
  bayesFolderFiles <- bayesFolderFiles[grep(bayesFolderFiles, pattern = ".log")]
  bayesFolderFiles <- bayesFolderFiles[-grep(bayesFolderFiles, pattern = ".ops")]
  bayesFolderFiles <-paste(bayesFolderPath, bayesFolderFiles, sep="")
  
  cutFolderPath = paste("/Users/chwu/Documents/research/bfc/paper/analysis/CutModel/", typeLabel[typeIndex], "/", sep="")
  cutFolderFiles<-dir(cutFolderPath)
  cutFolderFiles <- cutFolderFiles[grep(cutFolderFiles, pattern = ".log")]
  cutFolderFiles <- cutFolderFiles[grep(cutFolderFiles, pattern = "_side_")]
  cutFolderFiles <-paste(cutFolderPath, cutFolderFiles, sep="")
  
  log.post.diff<-c()
  type.post.bayes <- matrix(nrow = length(bayesFolderFiles), ncol = 5)
  type.post.cut <- matrix(nrow = length(cutFolderFiles), ncol = 5)
  for(sampleIndex in 1:length(bayesFolderFiles)){
    bayes.df <- read.table(file = bayesFolderFiles[sampleIndex], header = T, as.is = T, sep = "\t")
    bayes.df = bayes.df[-c(1:ceiling(nrow(bayes.df)/10)),]
    cut.df <- read.table(file = cutFolderFiles[sampleIndex], header = T, as.is = T, sep = "\t")
    cut.df = cut.df[-c(1:ceiling(nrow(cut.df)/10)),]
    type.post.bayes[sampleIndex, ] <- getTypeDistr(bayes.df$unknownType.0)
    type.post.cut[sampleIndex, ] <- getTypeDistr(cut.df$unknownType.0)
    log.post.diff[sampleIndex] <- sum(abs(bayes.df$log.posterior - cut.df$log.posterior))
  }
  
  type.post.bayes.list[[typeIndex]] = type.post.bayes
  rownames(type.post.bayes.list[[typeIndex]]) = gsub(bayesFolderFiles, pattern = bayesFolderPath, replace = "")
  colnames(type.post.bayes.list[[typeIndex]]) = typeLabel
  type.post.cut.list[[typeIndex]] = type.post.cut
  rownames(type.post.cut.list[[typeIndex]]) = gsub(cutFolderFiles, pattern = cutFolderPath, replace = "")
  colnames(type.post.cut.list[[typeIndex]]) = typeLabel
  
  correct.class.bayes.list[[typeIndex]] <- type.post.bayes[,typeIndex]
  correct.class.cut.list[[typeIndex]] <- type.post.cut[,typeIndex]
  log.post.diff.list[[typeIndex]] <- log.post.diff
  message(typeLabel[typeIndex])
}



type = c("Cervical Fluid Samples", "Menstrual Blood Samples", 
         "Saliva Samples", "Blood Samples", "Semen Samples")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_02_20/loocvCompareBayesVsCut.pdf",
    width = 7, height = 8)
par(mfrow = c(3, 2), mar = c(4, 4, 1.5, 1) + 0.2)
for(typeIndex in 1:length(typeLabel)){
  plot(correct.class.bayes.list[[typeIndex]], 
       correct.class.cut.list[[typeIndex]], 
       xlab = "Bayes", ylab = "Cut Model",
       main = type[typeIndex], pch = 4, las = 1, cex = 1.5)
  abline(0, 1, col = "red")
}
dev.off()

misClassBayes<-c()
misClassCut<-c()
for(typeIndex in 1:length(typeLabel)){
  misClassBayes[typeIndex]<-mean(1-correct.class.bayes.list[[typeIndex]])
  misClassCut[typeIndex]<-mean(1 - correct.class.cut.list[[typeIndex]])
}

signif(mean(1 - unlist(correct.class.bayes.list)),3)
signif(mean(1 - unlist(correct.class.cut.list)),3)

for(typeIndex in 1:length(typeLabel)){
  misClassBayes[typeIndex]<-mean(1-correct.class.bayes.list[[typeIndex]])
  misClassCut[typeIndex]<-mean(1 - correct.class.cut.list[[typeIndex]])
}



getUniquePatternIndex <- function(data.df = NULL, filePaths = NULL, prefix = NULL){
  uniquePattern<-apply(data.df, 1, paste, collapse = "")
  uniquePatternIndex <- gsub(filePaths, pattern = prefix, replace = "")
  uniquePatternIndex <- as.numeric(gsub(uniquePatternIndex, pattern = ".log", replace = ""))
  return(match(uniquePattern, uniquePattern[uniquePatternIndex]))
  
}

names(type.post.bayes.list) = typeLabel
names(type.post.cut.list) = typeLabel

dataList = list(cvf.df, mtb.df, slv.df, bld.df, smn.df)
loocvCutUniquePatternIndexList = list()
for(typeIndex in 1:length(typeLabel)){
  loocvCutUniquePatternIndexList[[typeIndex]] =
    getUniquePatternIndex(data.df = dataList[[typeIndex]], 
                          filePaths = rownames(type.post.cut.list[[typeIndex]]), 
                          prefix = paste("loocvCut_side_", typeLabel[typeIndex],"_", sep=""))
}
names(loocvCutUniquePatternIndexList) = typeLabel

table(apply(type.post.cut.list[["cvf"]][loocvCut.cvfUniquePatternIndex ,], 1, which.max))
table(apply(type.post.cut.list[["mtb"]][loocvCut.mtbUniquePatternIndex ,], 1, which.max))
table(apply(type.post.cut.list[["slv"]][loocvCut.slvUniquePatternIndex ,], 1, which.max))
table(apply(type.post.cut.list[["bld"]][loocvCut.bldUniquePatternIndex ,], 1, which.max))
table(apply(type.post.cut.list[["smn"]][loocvCut.smnUniquePatternIndex ,], 1, which.max))

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/postDistrCorrectTypeLOOCVCut.pdf",
    height = 6.5, width = 6)
par(mfrow = c(3, 2), mar = c(4.5, 4, 1.5, 2) + 0.2)
hist(type.post.cut.list[["cvf"]][loocvCut.cvfUniquePatternIndex, 1],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from cervical fluid",
     ylab = "Number of profiles")
hist(type.post.cut.list[["mtb"]][loocvCut.mtbUniquePatternIndex, 2],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from menstrual blood ",
     ylab = "Number of profiles")
hist(type.post.cut.list[["slv"]][loocvCut.slvUniquePatternIndex, 3],,
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from saliva",
     ylab = "Number of profiles")
hist(type.post.cut.list[["bld"]][loocvCut.bldUniquePatternIndex, 4],,
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from blood",
     ylab = "Number of profiles")
hist(type.post.cut.list[["smn"]][loocvCut.smnUniquePatternIndex, 5],,
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from semen",
     ylab = "Number of profiles")
par(mar = c(0, 0, 0, 0)+0.5)
loocvBayesPostMode = matrix(c(50, 9, 0, 0, 0, 
                              8, 23, 0, 0, 0,
                              0, 0, 80, 0, 0, 
                              0, 0, 0, 65, 0,
                              0, 0, 0, 0, 86),
                            byrow = T, nrow = 5)
drawPostModeTable(loocvBayesPostMode)
dev.off()




loocvBayes.cvfUniquePatternIndex <- getUniquePatternIndex(data.df = cvf.df, 
                                                          filePaths = rownames(type.post.bayes.list[["cvf"]]), 
                                                          prefix = "loocvTrain_cvf_")
type.post.bayes.list[["cvf"]][cvfUniquePatternIndex ,]

table(apply(type.post.bayes.list[["cvf"]][cvfUniquePatternIndex ,], 1, which.max))


loocvBayesTypePostDistrList = 
  list(cvfBayesLOOCV.typePostDistr.sample,
     mtbBayesLOOCV.typePostDistr.sample,
     slvBayesLOOCV.typePostDistr.sample,
     bldBayesLOOCV.typePostDistr.sample,
     smnBayesLOOCV.typePostDistr.sample)
names(loocvBayesTypePostDistrList) = typeLabel
for(type in typeLabel){
  colnames(loocvBayesTypePostDistrList[[type]]) = typeLabel
}

typeName = c("Cervical\nFluid", "Menstrual\nBlood", 
             "Saliva", "Blood", "Semen")
names(typeName) = typeLabel

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/postProbCorrectTypeQQ.pdf",
    height = 5, width = 8)
par(mfrow = c(2, 3), mar = c(5, 4, 2, 2) + 0.2, las = 1)
for(type in typeLabel){
  plot(loocvBayesTypePostDistrList[[type]][,type],
       type.post.cut.list[[type]][loocvCutUniquePatternIndexList[[type]], type], 
       xlab = "Full Bayes", ylab = "Cut Model", 
       xlim = c(0, 1), ylim = c(0, 1), pch = 4)
  abline(0, 1, col = "red")
  text(typeName[type], x = 0.2, y = 0.9)
}
dev.off()

data2019Bin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single_2019_binary.csv",
                          header = T, as.is = T)
loocvCutPostDistr<-rbind(type.post.cut.list[["cvf"]][loocvCutUniquePatternIndexList[["cvf"]], ],
  type.post.cut.list[["mtb"]][loocvCutUniquePatternIndexList[["mtb"]], ],
  type.post.cut.list[["slv"]][loocvCutUniquePatternIndexList[["slv"]], ],
  type.post.cut.list[["bld"]][loocvCutUniquePatternIndexList[["bld"]], ],
  type.post.cut.list[["smn"]][loocvCutUniquePatternIndexList[["smn"]], ])
colnames(loocvCutPostDistr) = paste(typeLabel, "PostProb", sep = "")

loocvCutCalibr.df = data.frame(sampleID = c(data2019Bin.df$Sample[data2019Bin.df$Type=="Vaginal Secretion"],
                                              data2019Bin.df$Sample[data2019Bin.df$Type=="Menstrual Blood"],
                                              data2019Bin.df$Sample[data2019Bin.df$Type=="Saliva"],
                                              data2019Bin.df$Sample[data2019Bin.df$Type=="Blood"],
                                              data2019Bin.df$Sample[data2019Bin.df$Type=="Semen"]),
                                trueType = rep(typeLabel, 
                                               c(nrow(type.post.cut.list[["cvf"]][loocvCutUniquePatternIndexList[["cvf"]], ]),
                                                 nrow(type.post.cut.list[["mtb"]][loocvCutUniquePatternIndexList[["mtb"]], ]),
                                                 nrow(type.post.cut.list[["slv"]][loocvCutUniquePatternIndexList[["slv"]], ]),
                                                 nrow(type.post.cut.list[["bld"]][loocvCutUniquePatternIndexList[["bld"]], ]),
                                                 nrow(type.post.cut.list[["smn"]][loocvCutUniquePatternIndexList[["smn"]], ]))),
                               loocvCutPostDistr)

write.csv(loocvCutCalibr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/loocvCutCalibr.csv",
          quote = F, row.names = F)