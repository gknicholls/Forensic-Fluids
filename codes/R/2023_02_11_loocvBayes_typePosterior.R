getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
         function(type, post.type){
           length(which(post.type == type))
         }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}


calcTypeDistrFromLog<-function(typeFolderPath = NULL, logFileName = NULL){
  currLogFilePath = paste(typeFolderPath, logFileName, sep="")
  log.df = read.table(file = currLogFilePath, header = T, as.is = T, sep = "\t")
  log.df = log.df[-c(1:round(nrow(log.df)/10)),]
  return(getTypeDistr(log.df$unknownType.0))
}

calcShannonEntropy <- function(probs = NULL){
  nonZeroIndex <- which(probs != 0)
  shEnt <- -sum(probs[nonZeroIndex]*log(probs[nonZeroIndex]))
  return(shEnt)
}

cvfFileNames <-list.files(path="/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/")
cvfLogFileNames<-cvfFileNames[grep(cvfFileNames, pattern = ".log")]
cvfLogFileNames<-cvfLogFileNames[-grep(cvfLogFileNames, pattern = ".ops")]
cvfFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/"
cvfBayesLOOCV.typePostDistr<-t(sapply(cvfLogFileNames, calcTypeDistrFromLog, typeFolderPath = cvfFolderPath))
cvfBayesLOOCV.typePosProbShEnt<- apply(cvfBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(cvfBayesLOOCV.typePostDistr[order(cvfBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)


mtbFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/"
mtbFileNames <-list.files(path = mtbFolderPath)
mtbLogFileNames<-mtbFileNames[grep(mtbFileNames, pattern = ".log")]
mtbLogFileNames<-mtbLogFileNames[-grep(mtbLogFileNames, pattern = ".ops")]
mtbBayesLOOCV.typePostDistr<-t(sapply(mtbLogFileNames, calcTypeDistrFromLog, typeFolderPath = mtbFolderPath))
mtbBayesLOOCV.typePostDistr[order(mtbBayesLOOCV.typePostDistr[,2]),]
mtbBayesLOOCV.typePosProbShEnt<- apply(mtbBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(mtbBayesLOOCV.typePostDistr[order(mtbBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)


slvFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/slv/"
slvFileNames <-list.files(path = slvFolderPath)
slvLogFileNames<-slvFileNames[grep(slvFileNames, pattern = ".log")]
slvLogFileNames<-slvLogFileNames[-grep(slvLogFileNames, pattern = ".ops")]
slvBayesLOOCV.typePostDistr<-t(sapply(slvLogFileNames, calcTypeDistrFromLog, typeFolderPath = slvFolderPath))
slvBayesLOOCV.typePosProbShEnt<- apply(slvBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(slvBayesLOOCV.typePostDistr[order(slvBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)


bldFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/bld/"
bldFileNames <-list.files(path = bldFolderPath)
bldLogFileNames<-bldFileNames[grep(bldFileNames, pattern = ".log")]
bldLogFileNames<-bldLogFileNames[-grep(bldLogFileNames, pattern = ".ops")]
bldBayesLOOCV.typePostDistr<-t(sapply(bldLogFileNames, calcTypeDistrFromLog, typeFolderPath = bldFolderPath))
bldBayesLOOCV.typePosProbShEnt<- apply(bldBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(bldBayesLOOCV.typePostDistr[order(bldBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)


smnFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/smn/"
smnFileNames <-list.files(path = smnFolderPath)
smnLogFileNames<-smnFileNames[grep(smnFileNames, pattern = ".log")]
smnLogFileNames<-smnLogFileNames[-grep(smnLogFileNames, pattern = ".ops")]
smnBayesLOOCV.typePostDistr<-t(sapply(smnLogFileNames, calcTypeDistrFromLog, typeFolderPath = smnFolderPath))
smnBayesLOOCV.typePosProbShEnt<- apply(smnBayesLOOCV.typePostDistr, 1, calcShannonEntropy)
round(smnBayesLOOCV.typePostDistr[order(smnBayesLOOCV.typePosProbShEnt, decreasing = T),], 3)
