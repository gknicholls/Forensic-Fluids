getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}
rowJ1ColJ1.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_c1e-10_all.log",
                           header = T, as.is = T, sep = "\t")
rowJ1ColJ1.df = rowJ1ColJ1.df[-c(1:ceiling(nrow(rowJ1ColJ1.df)/10)),]
rowJ1ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_all.log",
                           header = T, as.is = T, sep = "\t")
rowJ1ColJMax.df = rowJ1ColJMax.df[-c(1:ceiling(nrow(rowJ1ColJMax.df)/10)),]
rowJ5ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ5ColJMax.df = rowJ5ColJMax.df[-c(1:ceiling(nrow(rowJ5ColJMax.df)/10)),]
rowJ10ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J10_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ10ColJMax.df = rowJ10ColJMax.df[-c(1:ceiling(nrow(rowJ10ColJMax.df)/10)),]
rowJ15ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J15_all.log",
                              header = T, as.is = T, sep = "\t")
rowJ15ColJMax.df = rowJ15ColJMax.df[-c(1:ceiling(nrow(rowJ15ColJMax.df)/10)),]

exptdType = c(1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 3, 
              5, 1, 1, 5, 5, 4, 1, 1, 1, 5, 4, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 1, 1)
typeLabel = c("CVF", "MTB", "SLV", "BLD", "SMN")

unknownTypeLabel = paste("unknownType", c(0:45), sep=".")
rowJ1ColJ1TestTypePostDistr = t(apply(rowJ1ColJ1.df[,unknownTypeLabel], 2, getTypeDistr))
rowJ1ColJMaxTestTypePostDistr = t(apply(rowJ1ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
rowJ5ColJMaxTestTypePostDistr = t(apply(rowJ5ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
rowJ10ColJMaxTestTypePostDistr = t(apply(rowJ10ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
rowJ15ColJMaxTestTypePostDistr = t(apply(rowJ15ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_03_27/sensitivityJ_type_post_distr.pdf",
    height = 15, width = 16)
par(mfrow = c(6, 8), mar = c(8, 4, 2, 1) + 0.2)
for(sampleIndex in 1:length(exptdType)){
  typePostPerSample = cbind(rowJ1ColJ1TestTypePostDistr[sampleIndex,],
                            rowJ1ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ5ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ10ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ15ColJMaxTestTypePostDistr[sampleIndex,])
  colnames(typePostPerSample) = c("rJ = 1, cJ = 1", 
                                  "rJ = 1, cJ = Max", "rJ = 5, cJ = Max", 
                                  "rJ = 10, cJ = Max", "rJ = 15, cJ = Max")
  barplot(typePostPerSample, 
          main = paste(sampleIndex, typeLabel[exptdType[sampleIndex]], sep = ": "), 
          las = 2,  border = NA,
          col = c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"))
  
}

legnd = rep(1,5)
names(legnd) = typeLabel
barplot(height = legnd, main = "Legend", las = 2, border = NA, yaxt = "n",
        col = c("#6D2727", "#EB4D28", "#EC972D", "#34B795", "#093E42"))

dev.off()


c(1,3,8, 9, 10, 17, 18, 20, 21, 23, 26, 27, 29, 31, 32, 34)

postOdds = matrix(nrow = length(exptdType), ncol = 5)
for(sampleIndex in 1:length(exptdType)){
  typePostPerSample = cbind(rowJ1ColJ1TestTypePostDistr[sampleIndex,],
                            rowJ1ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ5ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ10ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ15ColJMaxTestTypePostDistr[sampleIndex,])
  postOdds[sampleIndex,] = typePostPerSample[exptdType[sampleIndex],]/
    (1 - typePostPerSample[exptdType[sampleIndex],])
  
  
}

postOddsRange<-t(apply(postOdds, 1, range))

table(apply(log10(postOddsRange), 1, diff)>1 & postOddsRange[,1] < 100)
