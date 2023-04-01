
drawPostModeTable = function(postModeMat  = NULL){
  
  par(mar = c(0, 0, 0, 0)+0.5)
  plot(1,1, xlim = c(0, 6), ylim = c(0, 6.5),
       xaxt = "n", yaxt = "n", axes=F, type = "n")
  for(i in 0:6){
    if(i == 0 | i==6){
      lines(x = c(i, i), y = c(0,6.5))
    }else if(i == 1){
      lines(x = c(i-0.025, i - 0.025), y = c(0,6.5))
      lines(x = c(i+0.025, i + 0.025), y = c(0,6.5))
    }else{
      lines(x = c(i, i), y = c(0, 6))
    }
    
  }
  for(i in 0:5){
    lines(x = c(0, 6), y = c(i, i))
  }
  
  lines(x = c(0, 6), y = c(6.5, 6.5))
  lines(x = c(1+0.025, 6), y = c(6, 6))
  typeLabel = c("Cervical\nfluid", "Menstrual\nblood", "Saliva", "Blood", "Semen")
  
  text(x = 0.5, y = 5.75, label = "True\nType", cex = 0.9, font=2)
  text(x = 3.5, y = 6.25, label = "Posterior mode", cex = 0.9, font=2)
  for(typeIndex in 1:length(typeLabel)){
    text(x = 0.5, y = 5.5 - typeIndex, label = typeLabel[typeIndex], cex = 0.8, font=2)
    text(x = typeIndex + 0.5, y = 5.5, label = typeLabel[typeIndex], cex = 0.8, font=2)
  }
  
  for(i in 1:nrow(postModeMat)){
    for(j in 1:ncol(postModeMat)){
      text(x = j + 0.5, y = 5 - i + 0.5, label = postModeMat[i, j])
    }
    
  }
}

getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}


calcTypeDistrFromLog<-function(typeFolderPath = NULL, logFileName = NULL, burnin = 0.1){
  currLogFilePath = paste(typeFolderPath, logFileName, sep="")
  log.df = read.table(file = currLogFilePath, header = T, as.is = T, sep = "\t")
  log.df = log.df[-c(1:ceiling(nrow(log.df)*burnin)),]
  return(getTypeDistr(log.df$unknownType.0))
}

calcShannonEntropy <- function(probs = NULL){
  nonZeroIndex <- which(probs != 0)
  shEnt <- -sum(probs[nonZeroIndex]*log(probs[nonZeroIndex]))
  return(shEnt)
}

cvf.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_cvf.csv", header = T, as.is = T)
cvfFileNames <-list.files(path="/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/")
cvfLogFileNames<-cvfFileNames[grep(cvfFileNames, pattern = ".log")]
cvfLogFileNames<-cvfLogFileNames[-grep(cvfLogFileNames, pattern = ".ops")]
cvfFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/"
cvfBayesLOOCV.typePostDistr<-t(sapply(cvfLogFileNames, calcTypeDistrFromLog, typeFolderPath = cvfFolderPath))
cvfBayesLOOCV.typePosProbShEnt<- apply(cvfBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(cvfBayesLOOCV.typePostDistr[order(cvfBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)

cvfUniquePattern<-apply(cvf.df, 1, paste, collapse="")
cvfUniquePatternIndex <- gsub(rownames(cvfBayesLOOCV.typePostDistr), pattern = "loocvTrain_cvf_", replace = "")
cvfUniquePatternIndex <- as.numeric(gsub(cvfUniquePatternIndex, pattern = ".log", replace = ""))
cvfBayesLOOCV.typePostDistr.sample<-cvfBayesLOOCV.typePostDistr[match(cvfUniquePattern, cvfUniquePattern[cvfUniquePatternIndex]),]
table(apply(cvfBayesLOOCV.typePostDistr.sample, 1, which.max))
# 1  2 
# 50  9

cvfBayesLOOCV.typePostOdds <- cvfBayesLOOCV.typePostDistr.sample[,1]/(1-cvfBayesLOOCV.typePostDistr.sample[,1])
table(cut(cvfBayesLOOCV.typePostOdds, c(0.01, 0.1, 1, 10, 100, 1000, 10000)))
table(cut(cvfBayesLOOCV.typePostOdds, c(0.01, 0.1, 1, 10, 100, 1000, 10000)))/nrow(cvfBayesLOOCV.typePostDistr.sample)

sort(cvfBayesLOOCV.typePostDistr.sample[,1]/(1-cvfBayesLOOCV.typePostDistr.sample[,1]))
hist(cvfBayesLOOCV.typePostDistr.sample[,1]/(1-cvfBayesLOOCV.typePostDistr.sample[,1]))

mtb.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_mtb.csv", header = T, as.is = T)
mtbFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/"
mtbFileNames <-list.files(path = mtbFolderPath)
mtbLogFileNames<-mtbFileNames[grep(mtbFileNames, pattern = ".log")]
mtbLogFileNames<-mtbLogFileNames[-grep(mtbLogFileNames, pattern = ".ops")]
mtbBayesLOOCV.typePostDistr<-t(sapply(mtbLogFileNames, calcTypeDistrFromLog, typeFolderPath = mtbFolderPath))
mtbBayesLOOCV.typePostDistr[order(mtbBayesLOOCV.typePostDistr[,2]),]
mtbBayesLOOCV.typePosProbShEnt<- apply(mtbBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(mtbBayesLOOCV.typePostDistr[order(mtbBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)
table(apply(mtbBayesLOOCV.typePostDistr, 1, which.max))

mtbUniquePattern<-apply(mtb.df, 1, paste, collapse="")
mtbUniquePatternIndex <- gsub(rownames(mtbBayesLOOCV.typePostDistr), pattern = "loocvTrain_mtb_", replace = "")
mtbUniquePatternIndex <- as.numeric(gsub(mtbUniquePatternIndex, pattern = ".log", replace = ""))
mtbBayesLOOCV.typePostDistr.sample<-mtbBayesLOOCV.typePostDistr[match(mtbUniquePattern, mtbUniquePattern[mtbUniquePatternIndex]),]
table(apply(mtbBayesLOOCV.typePostDistr.sample, 1, which.max))
# 1  2 
# 8 23 
summary(mtbBayesLOOCV.typePostDistr.sample[,2]/(1-mtbBayesLOOCV.typePostDistr.sample[,2]))

mtbBayesLOOCV.typePostOdds <- mtbBayesLOOCV.typePostDistr.sample[,2]/(1-mtbBayesLOOCV.typePostDistr.sample[,2])
table(cut(mtbBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))
signif(table(cut(mtbBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))/nrow(mtbBayesLOOCV.typePostDistr.sample),3)

slv.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_slv.csv", header = T, as.is = T)
slvFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/slv/"
slvFileNames <-list.files(path = slvFolderPath)
slvLogFileNames<-slvFileNames[grep(slvFileNames, pattern = ".log")]
slvLogFileNames<-slvLogFileNames[-grep(slvLogFileNames, pattern = ".ops")]
slvBayesLOOCV.typePostDistr<-t(sapply(slvLogFileNames, calcTypeDistrFromLog, typeFolderPath = slvFolderPath))
slvBayesLOOCV.typePosProbShEnt<- apply(slvBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(slvBayesLOOCV.typePostDistr[order(slvBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)
table(apply(slvBayesLOOCV.typePostDistr, 1, which.max))
# 3 
# 30 

slvUniquePattern<-apply(slv.df, 1, paste, collapse="")
slvUniquePatternIndex <- gsub(rownames(slvBayesLOOCV.typePostDistr), pattern = "loocvTrain_slv_", replace = "")
slvUniquePatternIndex <- as.numeric(gsub(slvUniquePatternIndex, pattern = ".log", replace = ""))
slvBayesLOOCV.typePostDistr.sample<-slvBayesLOOCV.typePostDistr[match(slvUniquePattern, slvUniquePattern[slvUniquePatternIndex]),]
table(apply(slvBayesLOOCV.typePostDistr.sample, 1, which.max))

summary(slvBayesLOOCV.typePostDistr.sample[,3]/(1-slvBayesLOOCV.typePostDistr.sample[,3]))

slvBayesLOOCV.typePostOdds <- slvBayesLOOCV.typePostDistr.sample[,3]/(1-slvBayesLOOCV.typePostDistr.sample[,3])
table(cut(slvBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))
signif(table(cut(slvBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))/nrow(slvBayesLOOCV.typePostDistr.sample),3)

bld.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_bld.csv", header = T, as.is = T)
bldFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/bld/"
bldFileNames <-list.files(path = bldFolderPath)
bldLogFileNames<-bldFileNames[grep(bldFileNames, pattern = ".log")]
bldLogFileNames<-bldLogFileNames[-grep(bldLogFileNames, pattern = ".ops")]
bldBayesLOOCV.typePostDistr<-t(sapply(bldLogFileNames, calcTypeDistrFromLog, typeFolderPath = bldFolderPath))
bldBayesLOOCV.typePosProbShEnt<- apply(bldBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(bldBayesLOOCV.typePostDistr[order(bldBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)
table(apply(bldBayesLOOCV.typePostDistr, 1, which.max))
# 4 
# 9 


bldUniquePattern<-apply(bld.df, 1, paste, collapse="")
bldUniquePatternIndex <- gsub(rownames(bldBayesLOOCV.typePostDistr), pattern = "loocvTrain_bld_", replace = "")
bldUniquePatternIndex <- as.numeric(gsub(bldUniquePatternIndex, pattern = ".log", replace = ""))
bldBayesLOOCV.typePostDistr.sample<-bldBayesLOOCV.typePostDistr[match(bldUniquePattern, bldUniquePattern[bldUniquePatternIndex]),]
table(apply(bldBayesLOOCV.typePostDistr.sample, 1, which.max))

summary(bldBayesLOOCV.typePostDistr.sample[,4]/(1-bldBayesLOOCV.typePostDistr.sample[,4]))


bldBayesLOOCV.typePostOdds <- bldBayesLOOCV.typePostDistr.sample[,4]/(1-bldBayesLOOCV.typePostDistr.sample[,4])
table(cut(bldBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))
signif(table(cut(bldBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))/nrow(bldBayesLOOCV.typePostDistr.sample),3)

smnFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/smn/"
smn.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_smn.csv", header = T, as.is = T)
smnFileNames <-list.files(path = smnFolderPath)
smnLogFileNames<-smnFileNames[grep(smnFileNames, pattern = ".log")]
smnLogFileNames<-smnLogFileNames[-grep(smnLogFileNames, pattern = ".ops")]
smnBayesLOOCV.typePostDistr<-t(sapply(smnLogFileNames, calcTypeDistrFromLog, typeFolderPath = smnFolderPath))
smnBayesLOOCV.typePosProbShEnt<- apply(smnBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(smnBayesLOOCV.typePostDistr[order(smnBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)
table(apply(smnBayesLOOCV.typePostDistr, 1, which.max))


smnUniquePattern<-apply(smn.df, 1, paste, collapse="")
smnUniquePatternIndex <- gsub(rownames(smnBayesLOOCV.typePostDistr), pattern = "loocvTrain_smn_", replace = "")
smnUniquePatternIndex <- as.numeric(gsub(smnUniquePatternIndex, pattern = ".log", replace = ""))
smnBayesLOOCV.typePostDistr.sample<-smnBayesLOOCV.typePostDistr[match(smnUniquePattern, smnUniquePattern[smnUniquePatternIndex]),]
table(apply(smnBayesLOOCV.typePostDistr.sample, 1, which.max))

summary(smnBayesLOOCV.typePostDistr.sample[,5]/(1-smnBayesLOOCV.typePostDistr.sample[,5]))


smnBayesLOOCV.typePostOdds <- smnBayesLOOCV.typePostDistr.sample[,5]/(1-smnBayesLOOCV.typePostDistr.sample[,5])
table(cut(smnBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))
signif(table(cut(smnBayesLOOCV.typePostOdds, c(0, 0.01, 0.1, 1, 10, 100, 1000, 10000, Inf)))/nrow(smnBayesLOOCV.typePostDistr.sample),3)

boldText = function(text){substitute(paste(bold(text))) }

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/postDistrCorrectTypeLOOCVBayes_v3.pdf",
    height = 6.5, width = 6)
par(mfrow = c(3, 2), mar = c(4.5, 4, 1.5, 2) + 0.2)
hist(cvfBayesLOOCV.typePostDistr.sample[,1],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from cervical fluid",
     ylab = "Number of profiles")
hist(mtbBayesLOOCV.typePostDistr.sample[,2],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from menstrual blood ",
     ylab = "Number of profiles")
hist(slvBayesLOOCV.typePostDistr.sample[,3],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from saliva",
     ylab = "Number of profiles")
hist(bldBayesLOOCV.typePostDistr.sample[,4],
     main = "", nclass = 20, las = 1,
     xlab = "Posterior probability of the correct type\nfor profiles from blood",
     ylab = "Number of profiles")
hist(smnBayesLOOCV.typePostDistr.sample[,5],
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


