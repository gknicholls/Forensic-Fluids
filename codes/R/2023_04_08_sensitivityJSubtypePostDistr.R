rowJ1ColJ1.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_c1e-10_all.log",
                           header = T, as.is = T, sep = "\t")
rowJ1ColJ1.df = rowJ1ColJ1.df[-c(1:ceiling(nrow(rowJ1ColJ1.df)/10)),]

# J_r = 1 & J_ c = M_g
rowJ1ColJMax.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ1ColJMax.df = rowJ1ColJMax.df[-c(1:ceiling(nrow(rowJ1ColJMax.df)/10)),]

# J_r = 5 & J_ c = M_g
rowJ5ColJMax.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ5ColJMax.df = rowJ5ColJMax.df[-c(1:ceiling(nrow(rowJ5ColJMax.df)/10)),]
dim(rowJ5ColJMax.df )

# J_r = 10 & J_ c = M_g
rowJ10ColJMax.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J10_all.log",
                              header = T, as.is = T, sep = "\t")
rowJ10ColJMax.df = rowJ10ColJMax.df[-c(1:ceiling(nrow(rowJ10ColJMax.df)/10)),]
dim(rowJ10ColJMax.df)

# J_r = 15 & J_ c = M_g
rowJ15ColJMax.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J15_all.log",
                              header = T, as.is = T, sep = "\t")
rowJ15ColJMax.df = rowJ15ColJMax.df[-c(1:ceiling(nrow(rowJ15ColJMax.df)/10)),]
dim(rowJ15ColJMax.df)

# Cut: J_r = 5 & J_ c = M_g
rowJ5ColJMaxCut.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_cut_side_all.log",
                                header = T, as.is = T, sep = "\t")
rowJ5ColJMaxCut.df = rowJ5ColJMaxCut.df [-c(1:ceiling(nrow(rowJ5ColJMaxCut.df)/10)),]
dim(rowJ5ColJMaxCut.df)

# Cut: J_r = 10 & J_ c = M_g
rowJ10ColJMaxCut.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_cut_side_J10_all.log",
                                 header = T, as.is = T, sep = "\t")
rowJ10ColJMaxCut.df = rowJ10ColJMaxCut.df[-c(1:ceiling(nrow(rowJ10ColJMaxCut.df)/10)),]
dim(rowJ10ColJMaxCut.df)

# Cut: J_r = 15 & J_ c = M_g
rowJ15ColJMaxCut.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_cut_side_J15_all.log",
                                 header = T, as.is = T, sep = "\t")
rowJ15ColJMaxCut.df = rowJ15ColJMaxCut.df[-c(1:ceiling(nrow(rowJ15ColJMaxCut.df)/10)),]
dim(rowJ15ColJMaxCut.df)

testBayesJoint.df$typeList[1001]

getSubtypeCounts = function(typeList = NULL){
  setList = strsplit(typeList, split = " ")
  setCountList  = lapply(setList , function(z){
    unlist(lapply(strsplit(z, split = "],[", fixed = T), length))
  })
  setCountMat = do.call(rbind, setCountList)
  colnames(setCountMat) = c("CVF", "MTB", "SLV", "BLD", "SMN")
  return(setCountMat)
}
getCountDistr = function(tabList, vecLength){
  countDistrList = lapply(tabList, function(countTab, vecLength){
    setCountDistrVec = rep(0, vecLength)
    setCountDistrVec[as.numeric(names(countTab))] = as.numeric(countTab)/sum(countTab)
    return(setCountDistrVec)
  }, vecLength = vecLength)
  return(do.call(rbind, countDistrList))
}
# 
# rowJ1ColJ1SetCountMat = getSubtypeCounts(rowJ1ColJ1.df$typeList)
# rowJ1ColJ1SetCountTabList = apply(rowJ1ColJ1SetCountMat, 2, table)
# rowJ1ColJ1SetCountDistr = getCountDistr(rowJ1ColJ1SetCountTabList, 5)
# barplot(rowJ1ColJ1SetCountDistr[,-1], beside = T)
# 
# 
# rowJ1ColJMaxSetCountMat = getSubtypeCounts(rowJ1ColJMax.df$typeList)
# rowJ1ColJMaxSetCountTabList = apply(rowJ1ColJMaxSetCountMat, 2, table)
# rowJ1ColJMaxSetCountDistr = getCountDistr(rowJ1ColJMaxSetCountTabList, 5)
# barplot(rowJ1ColJMaxSetCountDistr[,-1], beside = T)

par(mfrow = c(3,2))


rowJ5ColJMaxSetCountMat = getSubtypeCounts(rowJ5ColJMax.df$typeList)
rowJ5ColJMaxSetCountTabList = apply(rowJ5ColJMaxSetCountMat, 2, table)
rowJ5ColJMaxSetCountDistr = getCountDistr(rowJ5ColJMaxSetCountTabList, 5)
colnames(rowJ5ColJMaxSetCountDistr ) = c(1:ncol(rowJ5ColJMaxSetCountDistr ))
barplot(rowJ5ColJMaxSetCountDistr[,-1], beside = T)

rowJ5ColJMaxCutSetCountMat = getSubtypeCounts(rowJ5ColJMaxCut.df$typeList)
rowJ5ColJMaxCutSetCountTabList = apply(rowJ5ColJMaxCutSetCountMat, 2, table)
rowJ5ColJMaxCutSetCountDistr = getCountDistr(rowJ5ColJMaxCutSetCountTabList, 5)
colnames(rowJ5ColJMaxCutSetCountDistr ) = c(1:ncol(rowJ5ColJMaxCutSetCountDistr ))
barplot(rowJ5ColJMaxCutSetCountDistr[,-1], beside = T)


rowJ10ColJMaxSetCountMat = getSubtypeCounts(rowJ10ColJMax.df$typeList)
rowJ10ColJMaxSetCountTabList = apply(rowJ10ColJMaxSetCountMat, 2, table)
rowJ10ColJMaxSetCountDistr = getCountDistr(rowJ10ColJMaxSetCountTabList, 10)
colnames(rowJ10ColJMaxSetCountDistr) = c(1:ncol(rowJ10ColJMaxSetCountDistr))
barplot(rowJ10ColJMaxSetCountDistr[,-c(1,9,10)], beside = T)


rowJ10ColJMaxCutSetCountMat = getSubtypeCounts(rowJ10ColJMaxCut.df$typeList)
rowJ10ColJMaxCutSetCountTabList = apply(rowJ10ColJMaxCutSetCountMat, 2, table)
rowJ10ColJMaxCutSetCountDistr = getCountDistr(rowJ10ColJMaxCutSetCountTabList, 10)
colnames(rowJ10ColJMaxCutSetCountDistr) = c(1:ncol(rowJ10ColJMaxCutSetCountDistr))
barplot(rowJ10ColJMaxCutSetCountDistr[,2:8], beside = T)

rowJ15ColJMaxSetCountMat = getSubtypeCounts(rowJ15ColJMax.df$typeList)
rowJ15ColJMaxSetCountTabList = apply(rowJ15ColJMaxSetCountMat, 2, table)
rowJ15ColJMaxSetCountDistr = getCountDistr(rowJ15ColJMaxSetCountTabList, 15)
colnames(rowJ15ColJMaxSetCountDistr) = c(1:ncol(rowJ15ColJMaxSetCountDistr))
barplot(rowJ15ColJMaxSetCountDistr[,colSums(rowJ15ColJMaxSetCountDistr)>0], beside = T)

rowJ15ColJMaxCutSetCountMat = getSubtypeCounts(rowJ15ColJMaxCut.df$typeList)
rowJ15ColJMaxCutSetCountTabList = apply(rowJ15ColJMaxCutSetCountMat, 2, table)
rowJ15ColJMaxCutSetCountDistr = getCountDistr(rowJ15ColJMaxCutSetCountTabList, 15)
colnames(rowJ15ColJMaxCutSetCountDistr) = c(1:ncol(rowJ15ColJMaxCutSetCountDistr))
barplot(rowJ15ColJMaxCutSetCountDistr[,colSums(rowJ15ColJMaxCutSetCountDistr)>0], beside = T)

pdf(file = "/Users/jessiewu/Documents/research/bfc/paper/plot/sensitivityJSubtypeCounts.pdf",
    height = 6, width = 5)
par(mfrow = c(3,2), mar = c(4, 5, 2.25, 2), las = 1)
barplot(rowJ5ColJMaxSetCountDistr[,-1], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Bayes:"~italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(a)", adj = -0.45, line = 0.6, cex = 0.7)
barplot(rowJ5ColJMaxCutSetCountDistr[,-1], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Cut:"~italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(b)", adj = -0.45, line = 0.6, cex = 0.7)
legend("topright", rownames(rowJ5ColJMaxSetCountDistr), pch = 15, bty = "n", col = gray(1:5/5), cex = 1)
barplot(rowJ10ColJMaxSetCountDistr[,2:8], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Bayes:"~italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(c)", adj = -0.45, line = 0.6, cex = 0.7)
barplot(rowJ10ColJMaxCutSetCountDistr[,2:8], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Cut:"~italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(d)", adj = -0.45, line = 0.6, cex = 0.7)
barplot(rowJ15ColJMaxSetCountDistr[,colSums(rowJ15ColJMaxSetCountDistr)>0], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Bayes:"~italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(e)", adj = -0.45, line = 0.6, cex = 0.7)
barplot(rowJ15ColJMaxCutSetCountDistr[,colSums(rowJ15ColJMaxCutSetCountDistr)>0], beside = T, ylim = c(0, 0.8),
        xlab = c(expression("Cut:"~italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])),
        ylab = "Posterior probability")
mtext("(f)", adj = -0.45, line = 0.6, cex = 0.7)
dev.off()


log.df = read.table(file = "/Users/jessiewu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_cut_2022_09_22_J10_main.log",
           header = T, as.is = T, sep ="\t")