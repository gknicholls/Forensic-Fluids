getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}

# J_r = 1 & J_ c = 1
rowJ1ColJ1.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_c1e-10_all.log",
                           header = T, as.is = T, sep = "\t")
rowJ1ColJ1.df = rowJ1ColJ1.df[-c(1:ceiling(nrow(rowJ1ColJ1.df)/10)),]

# J_r = 1 & J_ c = M_g
rowJ1ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J1_all.log",
                           header = T, as.is = T, sep = "\t")
rowJ1ColJMax.df = rowJ1ColJMax.df[-c(1:ceiling(nrow(rowJ1ColJMax.df)/10)),]

# J_r = 5 & J_ c = M_g
rowJ5ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ5ColJMax.df = rowJ5ColJMax.df[-c(1:ceiling(nrow(rowJ5ColJMax.df)/10)),]
dim(rowJ5ColJMax.df )

# J_r = 10 & J_ c = M_g
rowJ10ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J10_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ10ColJMax.df = rowJ10ColJMax.df[-c(1:ceiling(nrow(rowJ10ColJMax.df)/10)),]
dim(rowJ10ColJMax.df)

# J_r = 15 & J_ c = M_g
rowJ15ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/paper/analysis/test/sensitivityJ/testSamplesBin_2022_09_22_bayes_J15_all.log",
                              header = T, as.is = T, sep = "\t")
rowJ15ColJMax.df = rowJ15ColJMax.df[-c(1:ceiling(nrow(rowJ15ColJMax.df)/10)),]
dim(rowJ15ColJMax.df)

# Cut: J_r = 5 & J_ c = M_g
rowJ5ColJMaxCut.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/test_cut_side_all/testSamplesBin_2022_09_22_cut_side_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ5ColJMaxCut.df = rowJ5ColJMaxCut.df [-c(1:ceiling(nrow(rowJ5ColJMaxCut.df)/10)),]
dim(rowJ5ColJMaxCut.df)

# Cut: J_r = 10 & J_ c = M_g
rowJ10ColJMaxCut.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_03_29/testSamplesBin_2022_09_22_cut_side_J10_all.log",
                              header = T, as.is = T, sep = "\t")
rowJ10ColJMaxCut.df = rowJ10ColJMaxCut.df[-c(1:ceiling(nrow(rowJ10ColJMaxCut.df)/10)),]
dim(rowJ10ColJMaxCut.df)

# Cut: J_r = 15 & J_ c = M_g
rowJ15ColJMaxCut.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_03_29/testSamplesBin_2022_09_22_cut_side_J15_all.log",
                                 header = T, as.is = T, sep = "\t")
rowJ15ColJMaxCut.df = rowJ15ColJMaxCut.df[-c(1:ceiling(nrow(rowJ15ColJMaxCut.df)/10)),]
dim(rowJ15ColJMaxCut.df)

exptdType = c(1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 3, 
              5, 1, 1, 5, 5, 4, 1, 1, 1, 5, 4, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 1, 1)
typeLabel = c("cvf", "mtb", "slv", "bld", "smn")

unknownTypeLabel = paste("unknownType", c(0:45), sep=".")
rowJ1ColJ1TestTypePostDistr = t(apply(rowJ1ColJ1.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ1ColJ1TestTypePostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ1ColJMaxTestTypePostDistr = t(apply(rowJ1ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ1ColJMaxTestTypePostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ5ColJMaxTestTypePostDistr = t(apply(rowJ5ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ5ColJMaxTestTypePostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ10ColJMaxTestTypePostDistr = t(apply(rowJ10ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ10ColJMaxTestTypePostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ15ColJMaxTestTypePostDistr = t(apply(rowJ15ColJMax.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ15ColJMaxTestTypePostDistr) = paste(typeLabel, "PostProb", sep="")

rowJ5ColJMaxTestTypeCutPostDistr = t(apply(rowJ5ColJMaxCut.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ5ColJMaxTestTypeCutPostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ10ColJMaxTestTypeCutPostDistr = t(apply(rowJ10ColJMaxCut.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ10ColJMaxTestTypeCutPostDistr) = paste(typeLabel, "PostProb", sep="")
rowJ15ColJMaxTestTypeCutPostDistr = t(apply(rowJ15ColJMaxCut.df[,unknownTypeLabel], 2, getTypeDistr))
colnames(rowJ15ColJMaxTestTypeCutPostDistr) = paste(typeLabel, "PostProb", sep="")

test2022Bin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/test/2022_09_22/single source samples_29Sept22.csv",
                          header = T, as.is = T)

rowJ1ColJ1TestTypePostDistr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                     trueType = typeLabel[exptdType],
                                     rowJ1ColJ1TestTypePostDistr)
write.csv(rowJ1ColJ1TestTypePostDistr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesJr1Jc1PostDistr.csv",
          quote = F, row.names = F)

rowJ1ColJMaxTestTypePostDistr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                            trueType = typeLabel[exptdType],
                                            rowJ1ColJMaxTestTypePostDistr)
write.csv(rowJ1ColJMaxTestTypePostDistr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesJr1JcMaxPostDistr.csv",
          quote = F, row.names = F)


rowJ10ColJMaxTestTypePostDistr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                              trueType = typeLabel[exptdType],
                                              rowJ10ColJMaxTestTypePostDistr)
write.csv(rowJ10ColJMaxTestTypePostDistr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesJr10JcMaxPostDistr.csv",
          quote = F, row.names = F)


rowJ15ColJMaxTestTypePostDistr.df = data.frame(sampleID = test2022Bin.df$Sample,
                                               trueType = typeLabel[exptdType],
                                               rowJ15ColJMaxTestTypePostDistr)
write.csv(rowJ15ColJMaxTestTypePostDistr.df,
          file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesJr15JcMaxPostDistr.csv",
          quote = F, row.names = F)



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


# c(1,3,8, 9, 10, 17, 18, 20, 21, 23, 26, 27, 29, 31, 32, 34)

postProbs = matrix(nrow = length(exptdType), ncol = 8)
for(sampleIndex in 1:length(exptdType)){
  typePostPerSample = cbind(rowJ1ColJ1TestTypePostDistr[sampleIndex,],
                            rowJ1ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ5ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ10ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ15ColJMaxTestTypePostDistr[sampleIndex,],
                            rowJ5ColJMaxTestTypeCutPostDistr[sampleIndex,],
                            rowJ10ColJMaxTestTypeCutPostDistr[sampleIndex,],
                            rowJ15ColJMaxTestTypeCutPostDistr[sampleIndex,])
  postProbs[sampleIndex,] = typePostPerSample[exptdType[sampleIndex],]
  
  
}

par(mfrow = c(2, 2), mar = c(5, 4, 2, 2) + 0.2, las = 1)
plot(x = postProbs[,3], y = postProbs[,1], pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5 &"~J[c]~"="~M[g]), 
     ylab = expression(J[r]~"= 1 &"~J[c]~"= 1"), 
     xlim = c(0, 1), ylim = c(0,1))
plot(x = postProbs[,3], y = postProbs[,2], pch = 4,
     xlab = expression(J[r]~"= 5 &"~J[c]~"="~M[g]), 
     ylab = expression(J[r]~"= 1 &"~J[c]~"="~M[g]))
plot(x = postProbs[,3], y = postProbs[,4], pch = 4,
     xlab = expression(J[r]~"= 5 &"~J[c]~"="~M[g]), 
     ylab = expression(J[r]~"= 10 &"~J[c]~"="~M[g]))
plot(x = postProbs[,3], y = postProbs[,5], pch = 4,
     xlab = expression(J[r]~"= 5 &"~J[c]~"="~M[g]), 
     ylab = expression(J[r]~"= 15 &"~J[c]~"="~M[g]))


pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/sensitivityJCorrectTypePostDistrMain.pdf",
    width = 10, height = 4)
par(mfrow = c(1, 2), mar = c(4, 4.5, 2, 2) + 0.2, las = 1)
plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,1]/(1 - postProbs[,1])), pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"= 1"))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(a)", adj=-0.2, line= 0.6)

plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,4]/(1 - postProbs[,4])),pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
abline(h = 0, col = "#00000077", lty = "dashed")
abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(b)", adj=-0.25, line= 0.6)

dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/sensitivityJCorrectTypePostDistrAll.pdf",
    width = 8.5, height = 12.75)

axisProbs  = c(0.01, 0.1, 0.5, 0.9, 0.99, 0.999, 0.9999)
axisProbPos  = c(log(axisProbs/(1 - axisProbs)), 11.5)
axisProbLabel  = c(axisProbs , 1.0)

par(mfrow = c(4,2), mar = c(4, 5, 1.5, 1) + 0.2, las = 1)

xIndex = rep(c(3, 6), 4)
yIndex = c(1, 1, 2, 2, 4, 7, 5, 8)
panelLabels = c("(a)", "(b)", "(c)", "(d)", "(e)", "(f)", "(g)", "(h)")
xLabVec = rep(c(expression("Bayes:"~italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Cut:"~italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)])), 4)
yLabVec = c(expression("Bayes:"~italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"= 1"),
            expression("Cut:"~italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"= 1"),
            expression("Bayes:"~italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Cut:"~italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Bayes:"~italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Cut:"~italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Bayes:"~italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]),
            expression("Cut:"~italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))

for(aIndex in 1:length(xDataIndex)){
  xLogit = log(postProbs[,xIndex[aIndex]]/(1 - postProbs[,xIndex[aIndex]]))
  xLogit[xLogit == Inf] = 11.5
  yLogit = log(postProbs[,yIndex[aIndex]]/(1 - postProbs[,yIndex[aIndex]]))
  yLogit[yLogit == Inf] = 11.5
  
  
  plot(x = xLogit, y = yLogit, pch = 4,
       xlab = xLabVec[aIndex], ylab = "",
       xaxt = "n", yaxt = "n", 
       xlim = c(-4.5, 12), ylim = c(-3.5, 12))
  mtext(yLabVec[aIndex], side = 2, line = 3.5, las = 3, cex = 0.65)
  axis(side = 1, label = axisProbLabel, at = axisProbPos)
  axis(side = 2, label = axisProbLabel, at = axisProbPos)
  abline(0, 1, col = "#00000077")
  # abline(h = 0, col = "#00000077", lty = "dashed")
  # abline(v = 0, col = "#00000077", lty = "dashed")
  abline(v = log(1/10), col ="#000000CC", lty = "dotted")
  abline(h = log(1/10), col ="#000000CC", lty = "dotted")
  axis.break(axis = 1, breakpos=10.5)
  axis.break(axis = 2, breakpos=10.5)
  mtext(panelLabels[aIndex], adj=-0.21, line= 0.6, cex = 0.8)
  
  
}

dev.off()



pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/sensitivityJCorrectTypePostDistrMain.pdf",
    width = 12, height = 4.7)


par(mfrow = c(1,2), mar = c(4, 5, 1.5, 1) + 0.2, las = 1)

panelLabels2 = c("(a)", "(b)", "(c)", "(d)", "(e)", "(f)", "(b)", "(h)")


for(aIndex in c(1, 7)){
  xLogit = log(postProbs[,xIndex[aIndex]]/(1 - postProbs[,xIndex[aIndex]]))
  xLogit[xLogit == Inf] = 11.5
  yLogit = log(postProbs[,yIndex[aIndex]]/(1 - postProbs[,yIndex[aIndex]]))
  yLogit[yLogit == Inf] = 11.5
  
  
  plot(x = xLogit, y = yLogit, pch = 4,
       xlab = xLabVec[aIndex], ylab = "",
       xaxt = "n", yaxt = "n", 
       xlim = c(-4.5, 12), ylim = c(-3.5, 12))
  mtext(yLabVec[aIndex], side = 2, line = 3.5, las = 3)
  axis(side = 1, label = axisProbLabel, at = axisProbPos)
  axis(side = 2, label = axisProbLabel, at = axisProbPos)
  abline(0, 1, col = "#00000077")
  # abline(h = 0, col = "#00000077", lty = "dashed")
  # abline(v = 0, col = "#00000077", lty = "dashed")
  abline(v = log(1/10), col ="#000000CC", lty = "dotted")
  abline(h = log(1/10), col ="#000000CC", lty = "dotted")
  axis.break(axis = 1, breakpos=10.5)
  axis.break(axis = 2, breakpos=10.5)
  mtext(panelLabels2[aIndex], adj=-0.21, line= 0.6)
  
  
}

dev.off()




pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/sensitivityJCorrectTypePostDistrAll.pdf",
    width = 8, height = 12.5)
axisProbs = c(0.1, 0.5, 0.9, 0.99, 0.999, 0.9999)
par(mfrow = c(4,2), mar = c(4, 5, 2, 2) + 0.2, las = 1)
plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,1]/(1 - postProbs[,1])), pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = "",
     xaxt = "n", yaxt = "n", xlim = c(-3.5, 9), ylim = c(-3.5, 9))
axis(side = 1, label = axisProbs, at = log(axisProbs/(1 - axisProbs)))
axis(side = 2, label = axisProbs, at = log(axisProbs/(1 - axisProbs)))
mtext(expression(italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"= 1"), side = 2, line = 3.5, las = 3, cex = 0.65)
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(a)", adj=-0.225, line= 0.6, cex = 0.8)

plot(x = log(postProbs[,6]/(1 - postProbs[,6])), 
     y = log(postProbs[,1]/(1 - postProbs[,1])), pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"= 1"))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(b)", adj=-0.2, line= 0.6)



plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,2]/(1 - postProbs[,2])), pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(c)", adj=-0.2, line= 0.6)



plot(x = log(postProbs[,6]/(1 - postProbs[,6])), 
     y = log(postProbs[,2]/(1 - postProbs[,2])), pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 1  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(d)", adj=-0.2, line= 0.6)


plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,4]/(1 - postProbs[,4])),pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(e)", adj=-0.2, line= 0.6)


plot(x = log(postProbs[,6]/(1 - postProbs[,6])), 
     y = log(postProbs[,7]/(1 - postProbs[,7])),pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 10  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(f)", adj=-0.2, line= 0.6)

plot(x = log(postProbs[,3]/(1 - postProbs[,3])), 
     y = log(postProbs[,5]/(1 - postProbs[,5])),, pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(g)", adj=-0.2, line= 0.6)


plot(x = log(postProbs[,6]/(1 - postProbs[,6])), 
     y = log(postProbs[,8]/(1 - postProbs[,8])),, pch = 4,
     xlab = expression(italic(J)[italic(f)]~"= 5  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]), 
     ylab = expression(italic(J)[italic(f)]~"= 15  & "~italic(L)[italic(g)]~"="~italic(M)[italic(g)]))
abline(0, 1, col = "#00000077")
# abline(h = 0, col = "#00000077", lty = "dashed")
# abline(v = 0, col = "#00000077", lty = "dashed")
abline(v = log(1/10), col ="#000000CC", lty = "dotted")
abline(h = log(1/10), col ="#000000CC", lty = "dotted")
mtext("(h)", adj=-0.2, line= 0.6)

dev.off()

postOddsRange<-t(apply(postOdds, 1, range))

table(apply(log10(postOddsRange), 1, diff)>1 & postOddsRange[,1] < 100)
rowJ1ColJ1TestTypeBayesPostMode

rowJ1ColJ1TestTypeBayesPostMode = table(typeLabel[exptdType], 
      typeLabel[apply(rowJ1ColJ1TestTypePostDistr, 1, which.max)])
rowJ1ColJ1TestTypeBayesPostMode
# cvf mtb slv smn
# bld   2   0   0   0
# cvf  22   2   0   0
# slv   0   0  10   0
# smn   0   0   0  10
rowJ1ColJ1TestTypeBayesPostMode[typeLabel[-2], typeLabel[-4]]
# cvf mtb slv smn
# cvf  22   2   0   0
# slv   0   0  10   0
# bld   2   0   0   0
# smn   0   0   0  10

rowJ1ColJMaxTestTypeBayesPostMode = table(typeLabel[exptdType], 
      typeLabel[apply(rowJ1ColJMaxTestTypePostDistr, 1, which.max)])
rowJ1ColJMaxTestTypeBayesPostMode 
# bld cvf slv smn
# bld   2   0   0   0
# cvf   0  24   0   0
# slv   0   1   9   0
# smn   0   0   0  10
rowJ1ColJMaxTestTypeBayesPostMode[typeLabel[-2], typeLabel[-2]]
# cvf slv bld smn
# cvf  24   0   0   0
# slv   1   9   0   0
# bld   0   0   2   0
# smn   0   0   0  10

rowJ10ColJMaxTestTypeBayesPostMode = table(typeLabel[exptdType], 
      typeLabel[apply(rowJ10ColJMaxTestTypePostDistr, 1, which.max)])
rowJ10ColJMaxTestTypeBayesPostMode
# bld cvf mtb slv smn
# bld   2   0   0   0   0
# cvf   0  23   1   0   0
# slv   0   0   0  10   0
# smn   0   0   0   0  10
rowJ10ColJMaxTestTypeBayesPostMode[typeLabel[-2], typeLabel]
# cvf mtb slv bld smn
# cvf  23   1   0   0   0
# slv   0   0  10   0   0
# bld   0   0   0   2   0
# smn   0   0   0   0  10

rowJ15ColJMaxTestTypeBayesPostMode = table(typeLabel[exptdType], 
      typeLabel[apply(rowJ15ColJMaxTestTypePostDistr, 1, which.max)])
rowJ15ColJMaxTestTypeBayesPostMode
# bld cvf mtb slv smn
# bld   2   0   0   0   0
# cvf   0  23   1   0   0
# slv   0   0   0  10   0
# smn   0   0   0   0  10
rowJ15ColJMaxTestTypeBayesPostMode[typeLabel[-2], typeLabel]
# cvf mtb slv bld smn
# cvf  23   1   0   0   0
# slv   0   0  10   0   0
# bld   0   0   0   2   0
# smn   0   0   0   0  10


rowJ10ColJMaxTestTypeCutPostMode = table(typeLabel[exptdType], 
                                           typeLabel[apply(rowJ10ColJMaxTestTypeCutPostDistr, 1, which.max)])
rowJ10ColJMaxTestTypeCutPostMode
# bld cvf mtb slv smn
# bld   2   0   0   0   0
# cvf   0  22   2   0   0
# slv   0   0   0  10   0
# smn   0   0   0   0  10
rowJ10ColJMaxTestTypeCutPostMode[typeLabel[-2], typeLabel]
# cvf mtb slv bld smn
# cvf  22   2   0   0   0
# slv   0   0  10   0   0
# bld   0   0   0   2   0
# smn   0   0   0   0  10

rowJ15ColJMaxTestTypeCutPostMode = table(typeLabel[exptdType], 
                                         typeLabel[apply(rowJ15ColJMaxTestTypeCutPostDistr, 1, which.max)])
rowJ15ColJMaxTestTypeCutPostMode
# bld cvf mtb slv smn
# bld   2   0   0   0   0
# cvf   0  23   1   0   0
# slv   0   0   0  10   0
# smn   0   0   0   0  10
rowJ15ColJMaxTestTypeCutPostMode[typeLabel[-2], typeLabel]
# cvf mtb slv bld smn
# cvf  23   1   0   0   0
# slv   0   0  10   0   0
# bld   0   0   0   2   0
# smn   0   0   0   0  10
