cvf37.df <- read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/loocvBayes_cvf_train_37.csv",
                     header = T, as.is = T)
cvf37.newRowOrder <- c(32, 1, 26, 34, 19, 9, 23, 11, 28, 7, 16, 42, 2, 36, 58, 12, 54, 10, 30, 4, 29, 53, 25, 
                 50, 51, 44, 52, 31, 55, 6, 21, 20, 48, 47, 5, 15, 17, 49, 41, 13, 45, 8, 40, 39, 38, 57, 
                 37, 3, 35, 14, 56, 24, 18, 46, 27, 43, 33, 22)
image(t(data.matrix(cvf37.df[cvf37.newRowOrder,])))

write.csv(cvf37.df[cvf37.newRowOrder[1:12],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/cvf37Class1.csv")
write.csv(cvf37.df[cvf37.newRowOrder[13:24],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/cvf37Class2.csv")
write.csv(cvf37.df[cvf37.newRowOrder[35:36],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/cvf37Class3.csv")
write.csv(cvf37.df[cvf37.newRowOrder[37:47],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/cvf37Class4.csv")
write.csv(cvf37.df[cvf37.newRowOrder[48:58],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/cvf37Class5.csv")


J = 5
alpha = 0.3125
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 12) - lgamma(alpha + 12))

J = 5
alpha = 0.324
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 11) - lgamma(alpha + 11))


mtb15.df <- read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/loocvBayes_mtb_train_15.csv",
                     header = T, as.is = T)
# sample(1:nrow(mtb15.df ))
mtb15.newRowOrder <- c(21, 20, 8, 3, 26, 22, 17, 19, 5, 27, 30, 1, 29, 15, 2, 
                 28, 23, 10, 7, 24, 16, 6, 9, 14, 4, 25, 18, 13, 11, 12)
image(t(data.matrix(mtb15.df[mtb15.newRowOrder,])))

write.csv(mtb15.df[mtb15.newRowOrder[1:6],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/mtb15Class1.csv")
write.csv(mtb15.df[mtb15.newRowOrder[7:12],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/mtb15Class2.csv")
write.csv(mtb15.df[mtb15.newRowOrder[13:18],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/mtb15Class3.csv")
write.csv(mtb15.df[mtb15.newRowOrder[19:24],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/mtb15Class4.csv")
write.csv(mtb15.df[mtb15.newRowOrder[25:30],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/mtb15Class5.csv")


J = 5
alpha = 0.439
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 6) - lgamma(alpha + 6))


slv2.df <- read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/loocvBayes_slv_train_2.csv",
                     header = T, as.is = T)
# sample(1:nrow(slv2.df))
slv2.newRowOrder <- c(64, 34, 67, 20, 28, 62, 11, 36, 75, 45, 38, 33, 44, 25, 41, 7, 54, 63, 78, 48, 58, 32, 
                   37, 77, 16, 29, 8, 42, 53, 10, 73, 61, 59, 46, 9, 66, 17, 43, 31, 2, 71, 19, 14, 55, 60, 
                   22, 27, 26, 76, 5, 51, 35, 79, 23, 12, 13, 6, 68, 52, 49, 74, 15, 21, 56, 72, 1, 4, 57, 
                   39, 50, 69, 65, 18, 24, 3, 40, 47, 70, 30)
image(t(data.matrix(slv2.df[slv2.newRowOrder,])))

write.csv(slv2.df[slv2.newRowOrder[1:16],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/slv2Class1.csv")
write.csv(slv2.df[slv2.newRowOrder[17:32],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/slv2Class2.csv")
write.csv(slv2.df[slv2.newRowOrder[33:48],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/slv2Class3.csv")
write.csv(slv2.df[slv2.newRowOrder[49:64],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/slv2Class4.csv")
write.csv(slv2.df[slv2.newRowOrder[65:79],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/slv2Class5.csv")


J = 5
alpha = 0.28
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 16) - lgamma(alpha + 16))
alpha = 0.287
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 15) - lgamma(alpha + 15))

smn8.df <- read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/loocvBayes_smn_train_8.csv",
                    header = T, as.is = T)
# sample(1:nrow(smn8.df))
smn8.newRowOrder <- c(85, 37, 69, 53, 23, 45, 50, 81, 54, 18, 71, 59, 13, 52, 42, 2, 79, 22, 30, 3, 31, 24, 
                 20, 6, 76, 11, 73, 83, 33, 57, 70, 35, 14, 47, 55, 68, 49, 84, 36, 67, 1, 29, 7, 10, 17, 
                 28, 34, 80, 62, 58, 41, 46, 39, 48, 77, 65, 75, 40, 82, 51, 21, 56, 38, 32, 61, 9, 4, 63,
                 78, 5, 8, 74, 15, 16, 25, 26, 60, 43, 27, 64, 44, 66, 19, 72, 12)
image(t(data.matrix(smn8.df[smn8.newRowOrder,])))
write.csv(smn8.df[smn8.newRowOrder[1:17],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/smn8Class1.csv")
write.csv(smn8.df[smn8.newRowOrder[18:34],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/smn8Class2.csv")
write.csv(smn8.df[smn8.newRowOrder[34:51],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/smn8Class3.csv")
write.csv(smn8.df[smn8.newRowOrder[52:68],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/smn8Class4.csv")
write.csv(smn8.df[smn8.newRowOrder[69:85],], row.names = F, quote = F,
          file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_16/smn8Class5.csv")



J = 5
alpha = 0.275
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 17) - lgamma(alpha + 17))

loocvCut_main_cvfOnly_37.df <-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_15/loocvCut_main_bldOnly_10.log", header = T, as.is = T, sep="\t")
unname(sort(table(loocvCut_main_bldOnly_10.df$typeList), decreasing = T)[1:50]/nrow(loocvCut_main_bldOnly_10.df))
names(sort(table(loocvCut_main_bldOnly_10.df$typeList), decreasing = T))[1]



J = 5
alpha = 0.3
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 13) - lgamma(alpha + 13))

J = 5
alpha = 0.31
exp(lgamma(alpha) - lgamma(alpha/J) + lfactorial(J) - lgamma(J) + lgamma(alpha/J + 12) - lgamma(alpha + 12))

loocvBayes_bldOnly_10.df<-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_15/loocvBayes_bldOnly_10.log",
                                     header = T, as.is = T, sep = "\t")
loocvCut_bldOnly_10.df<-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_15/loocvCut_side_bldOnly_10_10000.log",
                                   header = T, as.is = T, sep = "\t")

loocvBayes_bldOnly_10.logPost<-names(table(loocvBayes_bldOnly_10.df$log.posterior))
table(loocvBayes_bldOnly_10.df$log.posterior)
table(loocvCut_bldOnly_10.df$log.posterior)[loocvBayes_bldOnly_10.logPost]
loocv_bldOnly_10_10000.logPost<-matrix(0,nrow= 2, ncol = length(unique(loocvBayes_bldOnly_10.df$log.posterior)))
colnames(loocv_bldOnly_10_10000.logPost)<-sort(names(table(loocvBayes_bldOnly_10.df$log.posterior)))

loocv_bldOnly_10_10000.logPost[1,names(table(loocvBayes_bldOnly_10.df$log.posterior))]<-
  table(loocvBayes_bldOnly_10.df$log.posterior)
loocv_bldOnly_10_10000.logPost[2,names(table(loocvCut_bldOnly_10.df$log.posterior))]<-
  table(loocvCut_bldOnly_10.df$log.posterior)
loocv_bldOnly_10_10000.logPost<-loocv_bldOnly_10_10000.logPost/nrow(loocvBayes_bldOnly_10.df)


loocvBayes_bldOnly_10.type<-names(table(loocvBayes_bldOnly_10.df$unknownType.0))
loocv_bldOnly_10_10000.type<-matrix(0,nrow= 2, ncol = length(unique(loocvBayes_bldOnly_10.df$unknownType.0)))
colnames(loocv_bldOnly_10_10000.type)<-sort(names(table(loocvBayes_bldOnly_10.df$unknownType.0)))

loocv_bldOnly_10_10000.type[1,names(table(loocvBayes_bldOnly_10.df$unknownType.0))]<-
  table(loocvBayes_bldOnly_10.df$unknownType.0)
loocv_bldOnly_10_10000.type[2,names(table(loocvCut_bldOnly_10.df$unknownType.0))]<-
  table(loocvCut_bldOnly_10.df$unknownType.0)
loocv_bldOnly_10_10000.type<-loocv_bldOnly_10_10000.type/nrow(loocvBayes_bldOnly_10.df)


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_02_15/compareMHvsGibbs.pdf",
    width = 10, height = 5)
par(mfrow = c(1,2), mar = c(5, 4, 1, 1) + 0.2)
barplot(loocv_bldOnly_10_10000.logPost, beside=T, xaxt="n",
        xlab = "Log(posterior) values", ylab = "Posterior frequencies")
legend("topright", c("M-H", "Gibbs"), col=c("lightgrey", "#36454F"), pch = 15)
axis(1, labels = round(as.numeric(colnames(loocv_bldOnly_10_10000.logPost)), 1), at = c(1:13)*3-1, las = 2)
barplot(loocv_bldOnly_10_10000.type, beside=T, xaxt="n",
        xlab = "Blood class", ylab = "Posterior frequencies")
axis(1, labels = c(1:5), at = c(1:5)*3 - 1)
dev.off()


loocvBayes_bldOnly_10_v2.df<-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_15/loocvBayes_bldOnly_10_v2.log",
                                        header = T, as.is = T, sep = "\t")
loocvCut_bldOnly_10_v2.df<-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_15/loocvCut_side_bldOnly_10_v2_10000.log",
                                      header = T, as.is = T, sep = "\t")

loocvCut_bldOnly_10_v2.logPost.uVal<-
  unique(c(names(table(loocvBayes_bldOnly_10_v2.df$log.posterior)),
           names(table(loocvCut_bldOnly_10_v2.df$log.posterior))))

loocvBayes_bldOnly_10_v2.logPost<-names(table(loocvBayes_bldOnly_10_v2.df$log.posterior))
table(loocvBayes_bldOnly_10_v2.df$log.posterior)
table(loocvCut_bldOnly_10_v2.df$log.posterior)[loocvBayes_bldOnly_10_v2.logPost]
loocv_bldOnly_10_v2_10000.logPost<-matrix(0,nrow= 2, ncol = length(loocvCut_bldOnly_10_v2.logPost.uVal))
colnames(loocv_bldOnly_10_v2_10000.logPost)<-sort(loocvCut_bldOnly_10_v2.logPost.uVal)

loocv_bldOnly_10_v2_10000.logPost[1,names(table(loocvBayes_bldOnly_10_v2.df$log.posterior))]<-
  table(loocvBayes_bldOnly_10_v2.df$log.posterior)
loocv_bldOnly_10_v2_10000.logPost[2,names(table(loocvCut_bldOnly_10_v2.df$log.posterior))]<-
  table(loocvCut_bldOnly_10_v2.df$log.posterior)
loocv_bldOnly_10_v2_10000.logPost<-loocv_bldOnly_10_v2_10000.logPost/nrow(loocvBayes_bldOnly_10_v2.df)


loocvBayes_bldOnly_10_v2.type<-names(table(loocvBayes_bldOnly_10_v2.df$unknownType.0))
loocv_bldOnly_10_10000_v2.type<-matrix(0,nrow= 2, ncol = length(unique(loocvBayes_bldOnly_10_v2.df$unknownType.0)))
colnames(loocv_bldOnly_10_10000_v2.type)<-sort(names(table(loocvBayes_bldOnly_10_v2.df$unknownType.0)))

loocv_bldOnly_10_10000_v2.type[1,names(table(loocvBayes_bldOnly_10_v2.df$unknownType.0))]<-
  table(loocvBayes_bldOnly_10_v2.df$unknownType.0)
loocv_bldOnly_10_10000_v2.type[2,names(table(loocvCut_bldOnly_10_v2.df$unknownType.0))]<-
  table(loocvCut_bldOnly_10_v2.df$unknownType.0)
loocv_bldOnly_10_10000_v2.type<-loocv_bldOnly_10_10000_v2.type/nrow(loocvBayes_bldOnly_10_v2.df)


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_02_15/compareMHvsGibbsNonUniformTypePrior.pdf",
    width = 10, height = 5)
par(mfrow = c(1,2), mar = c(5, 4, 1, 1) + 0.2)
barplot(loocv_bldOnly_10_v2_10000.logPost, beside=T, xaxt="n",
        xlab = "Log(posterior) values", ylab = "Posterior frequencies")
legend("topright", c("M-H", "Gibbs"), col=c("lightgrey", "#36454F"), pch = 15)
axis(1, at = c(1:13)*3-1, las = 2,
     labels = round(as.numeric(colnames(loocv_bldOnly_10_v2_10000.logPost)), 1))
barplot(loocv_bldOnly_10_10000_v2.type, beside=T, xaxt="n",
        xlab = "Blood class", ylab = "Posterior frequencies")
axis(1, labels = c(1:5), at = c(1:5)*3 - 1)
dev.off()