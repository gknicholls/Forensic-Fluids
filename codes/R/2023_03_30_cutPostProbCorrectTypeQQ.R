getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}
typeLabel = c("cvf", "mtb", "slv", "bld", "smn")
bayesFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/test/bayes/"
bayesFolderFiles<-dir(bayesFolderPath)
bayesFolderFiles <- bayesFolderFiles[grep(bayesFolderFiles, pattern = ".log")]
bayesFolderFiles <- bayesFolderFiles[-grep(bayesFolderFiles, pattern = ".ops")]
bayesFolderFiles <-paste(bayesFolderPath, bayesFolderFiles, sep="")
  
cutFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/test/cut/"
cutFolderFiles<-dir(cutFolderPath)
cutFolderFiles <- cutFolderFiles[grep(cutFolderFiles, pattern = ".log")]
cutFolderFiles <- cutFolderFiles[grep(cutFolderFiles, pattern = "_side_")]
cutFolderFiles <-paste(cutFolderPath, cutFolderFiles, sep="")
  

test.type.post.bayes <- matrix(nrow = length(bayesFolderFiles), ncol = 5)
test.type.post.cut <- matrix(nrow = length(cutFolderFiles), ncol = 5)
for(sampleIndex in 1:length(bayesFolderFiles)){
  bayes.df <- read.table(file = bayesFolderFiles[sampleIndex], header = T, as.is = T, sep = "\t")
  bayes.df <- bayes.df[-c(1:ceiling(nrow(bayes.df)/10)),]
  cut.df <- read.table(file = cutFolderFiles[sampleIndex], header = T, as.is = T, sep = "\t")
  cut.df <- cut.df[-c(1:ceiling(nrow(bayes.df)/10)),]
  
  test.type.post.bayes[sampleIndex, ] <- getTypeDistr(bayes.df$unknownType.0)
  test.type.post.cut[sampleIndex, ] <- getTypeDistr(cut.df$unknownType.0)
}
  
rownames(test.type.post.bayes) = gsub(bayesFolderFiles, pattern = bayesFolderPath, replace = "")
colnames(test.type.post.bayes) = typeLabel
test.type.post.bayes.indexOrder = gsub(rownames(test.type.post.bayes), 
                                       pattern = "testSamplesBin_2022_09_22_bayes_", replace="")
test.type.post.bayes.indexOrder = gsub(test.type.post.bayes.indexOrder, 
                                       pattern = ".log", replace="")
test.type.post.bayes = test.type.post.bayes[order(as.numeric(test.type.post.bayes.indexOrder)),]

rownames(test.type.post.cut) = gsub(cutFolderFiles, pattern = cutFolderPath, replace = "")
colnames(test.type.post.cut) = typeLabel
test.type.post.cut.indexOrder = gsub(rownames(test.type.post.cut), 
                                       pattern = "testSamplesBin_2022_09_22_cut_side_", replace="")
test.type.post.cut.indexOrder = gsub(test.type.post.cut.indexOrder, 
                                       pattern = ".log", replace="")
test.type.post.cut = test.type.post.cut[order(as.numeric(test.type.post.cut.indexOrder)),]  

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/cutPostProbCorrectTypeQQ.pdf",
    width = 7.5, height = 3.5)

dev.off()

exptdType = c(1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 3, 
              5, 1, 1, 5, 5, 4, 1, 1, 1, 5, 4, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 1, 1)


testJointBayes.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log", 
                               header = T, as.is = T, sep = "\t")
testJointBayes.df = testJointBayes.df[-c(1:ceiling(nrow(testJointBayes.df)/10)),]

testJointCut.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/test_cut_side_all/testSamplesBin_2022_09_22_cut_side_all.log", 
                               header = T, as.is = T, sep = "\t")
testJointCut.df = testJointCut.df[-c(1:ceiling(nrow(testJointCut.df)/10)),]

testJointBayesTypePostDistr = 
  t(apply(testJointBayes.df[,grep(names(testJointBayes.df), 
                              pattern = "unknownType.", fixed = T)], 2, getTypeDistr))

testJointCutTypePostDistr = 
  t(apply(testJointCut.df[,grep(names(testJointCut.df), 
                                  pattern = "unknownType.", fixed = T)], 2, getTypeDistr))


pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/cutPostProbCorrectTypeQQ.pdf",
   width = 7.5, height = )
par(mfrow = c(2, 2), mar = c(4, 4, 1.5, 1) + 0.2, las = 1)

plot(test.type.post.bayes[cbind(1:46,exptdType)], test.type.post.cut[cbind(1:46,exptdType)],
     col =  c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42")[exptdType], pch = 4, lwd = 1.25,
     xlab = "Full Bayes", ylab = "Cut Model")
abline(a = 0, b = 1, col ="#00000077", lwd = 2)
mtext("(a)", adj=-0.25, line=0.5)
legend("topleft", 
       legend = c("Cervical fluid", "Menstrual blood", "Saliva", "Blood", "Semen"), pch = 4, bty = "n",
       col = c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"))
plot(test.type.post.bayes[cbind(1:46,exptdType)], test.type.post.cut[cbind(1:46,exptdType)],
     col =  c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42")[exptdType],
     xlim = c(0.8, 1), ylim = c(0.8, 1), pch = 4, lwd = 1.25,
     xlab = "Full Bayes", ylab = "Cut Model")
abline(a = 0, b = 1, col ="#00000077", lwd = 2)
mtext("(b)", adj=-0.25, line=0.5)
plot(testJointBayesTypePostDistr[cbind(1:46,exptdType)], 
     testJointCutTypePostDistr[cbind(1:46,exptdType)],
     col =  c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42")[exptdType], pch = 4, lwd = 1.25,
     xlab = "Full Bayes", ylab = "Cut Model")
abline(a = 0, b = 1, col ="#00000077", lwd = 2)
mtext("(c)", adj=-0.25, line=0.5)
legend("topleft", 
       legend = c("Cervical fluid", "Menstrual blood", "Saliva", "Blood", "Semen"), pch = 4, bty = "n",
       col = c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"))

plot(testJointBayesTypePostDistr[cbind(1:46,exptdType)], 
     testJointCutTypePostDistr[cbind(1:46,exptdType)],
     col =  c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42")[exptdType], 
     xlim = c(0.77, 1), ylim = c(0.77, 1),pch = 4, lwd = 1.25,
     xlab = "Full Bayes", ylab = "Cut Model")
abline(a = 0, b = 1, col ="#00000077", lwd = 2)
mtext("(d)", adj=-0.25, line=0.5)
dev.off()
