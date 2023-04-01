loocvCut_side_smn_sub_8_4570000.df <-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_sub_8_4570000.log",
           header = T, as.is = T, sep = "\t")


loocvCut_side_smn_sub_8_4570000.df<-
  loocvCut_side_smn_sub_8_4570000.df[-c(1:round(nrow(loocvCut_side_smn_sub_8_4570000.df)/10)),]
unname(table(loocvCut_side_smn_sub_8_4570000.df$typeList)/nrow(loocvCut_side_smn_sub_8_4570000.df))
loocvCut_side_smn_sub_8_4570000.log.post<-unique(loocvCut_side_smn_sub_8_4570000.df$log.posterior) - max(loocvCut_side_smn_sub_8_4570000.df$log.posterior)

loocvCut_side_smn_sub_8_4570000.post <- exp(loocvCut_side_smn_sub_8_4570000.log.post)/sum(exp(loocvCut_side_smn_sub_8_4570000.log.post))
loocvCut_side_smn_sub_8_4570000.typePost <- as.numeric(unname(table(loocvCut_side_smn_sub_8_4570000.df$typeList)/nrow(loocvCut_side_smn_sub_8_4570000.df)))
plot(x = sort(loocvCut_side_smn_sub_8_4570000.post), 
     y = sort(loocvCut_side_smn_sub_8_4570000.typePost),
     xlab = "Expected posterior", ylab = "Gibbs posterior",
     main = "Semen sample #8\n(Main chain posterior sample #4570000)")
abline(0, 1, col="red")



loocvCut_side_smn_sub_8_22990000.df <-read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_sub_8_22990000.log",
                                                header = T, as.is = T, sep = "\t")

loocvCut_side_smn_sub_8_22990000.df<-
  loocvCut_side_smn_sub_8_22990000.df[-c(1:round(nrow(loocvCut_side_smn_sub_8_22990000.df)/10)),]
unname(table(loocvCut_side_smn_sub_8_22990000.df$typeList)/nrow(loocvCut_side_smn_sub_8_22990000.df))
loocvCut_side_smn_sub_8_22990000.log.post<-unique(loocvCut_side_smn_sub_8_22990000.df$log.posterior) - max(loocvCut_side_smn_sub_8_22990000.df$log.posterior)

loocvCut_side_smn_sub_8_22990000.post <- exp(loocvCut_side_smn_sub_8_22990000.log.post)/sum(exp(loocvCut_side_smn_sub_8_22990000.log.post))
plot(sort(loocvCut_side_smn_sub_8_22990000.post), xlab = "Expected posterior", ylab = "Gibbs posterior",
     main = "Semen sample #8\n(Main chain posterior sample #22990000)",
     as.numeric(sort(unname(table(loocvCut_side_smn_sub_8_22990000.df$typeList)/nrow(loocvCut_side_smn_sub_8_22990000.df)))))
abline(0, 1, col="red")


loocvCut_side_smn_sub_8_26460000.df <-
  read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_sub_8_26460000.log",
                                                 header = T, as.is = T, sep = "\t")
loocvCut_side_smn_sub_8_26460000.df<-
  loocvCut_side_smn_sub_8_26460000.df[-c(1:round(nrow(loocvCut_side_smn_sub_8_26460000.df)/10)),]
loocvCut_side_smn_sub_8_26460000.typeList<-unique(loocvCut_side_smn_sub_8_26460000.df$typeList) 

loocvCut_side_smn_sub_8_26460000.log.post<-unique(loocvCut_side_smn_sub_8_26460000.df$log.posterior) - max(loocvCut_side_smn_sub_8_26460000.df$log.posterior)
loocvCut_side_smn_sub_8_26460000.post <- exp(loocvCut_side_smn_sub_8_26460000.log.post)/sum(exp(loocvCut_side_smn_sub_8_26460000.log.post))
loocvCut_side_smn_sub_8_26460000.typePost <- as.numeric(unname(table(loocvCut_side_smn_sub_8_26460000.df$typeList)/
                                                                nrow(loocvCut_side_smn_sub_8_26460000.df)))

plot(x = sort(loocvCut_side_smn_sub_8_26460000.post), 
     y = sort(loocvCut_side_smn_sub_8_26460000.typePost),
     xlab = "Expected posterior", ylab = "Gibbs posterior",
     main = "Semen sample #8\n(Main chain posterior sample #26460000)")
abline(0, 1, col="red")

loocvCut_side_smn_sub_8_38350000.df <-
  read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_sub_8_38350000.log",
             header = T, as.is = T, sep = "\t")
loocvCut_side_smn_sub_8_38350000.df<-
  loocvCut_side_smn_sub_8_38350000.df[-c(1:round(nrow(loocvCut_side_smn_sub_8_38350000.df)/10)),]
loocvCut_side_smn_sub_8_38350000.typeList<-unique(loocvCut_side_smn_sub_8_38350000.df$typeList) 

loocvCut_side_smn_sub_8_38350000.log.post<-unique(loocvCut_side_smn_sub_8_38350000.df$log.posterior) - max(loocvCut_side_smn_sub_8_38350000.df$log.posterior)
loocvCut_side_smn_sub_8_38350000.post <- exp(loocvCut_side_smn_sub_8_38350000.log.post)/sum(exp(loocvCut_side_smn_sub_8_38350000.log.post))
loocvCut_side_smn_sub_8_38350000.typePost <- as.numeric(unname(table(loocvCut_side_smn_sub_8_38350000.df$typeList)/
                                                                 nrow(loocvCut_side_smn_sub_8_38350000.df)))

plot(x = sort(loocvCut_side_smn_sub_8_38350000.post), 
     y = sort(loocvCut_side_smn_sub_8_38350000.typePost),
     xlab = "Expected posterior", ylab = "Gibbs posterior",
     main = "Semen sample #8\n(Main chain posterior sample #38350000)")
abline(0, 1, col="red")



loocvCut_side_smn_sub_8_48790000.df <-
  read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_sub_8_48790000.log",
             header = T, as.is = T, sep = "\t")
loocvCut_side_smn_sub_8_48790000.df<-
  loocvCut_side_smn_sub_8_48790000.df[-c(1:round(nrow(loocvCut_side_smn_sub_8_48790000.df)/10)),]
loocvCut_side_smn_sub_8_48790000.typeList<-unique(loocvCut_side_smn_sub_8_48790000.df$typeList) 

loocvCut_side_smn_sub_8_48790000.log.post<-unique(loocvCut_side_smn_sub_8_48790000.df$log.posterior) - max(loocvCut_side_smn_sub_8_48790000.df$log.posterior)
loocvCut_side_smn_sub_8_48790000.post <- exp(loocvCut_side_smn_sub_8_48790000.log.post)/sum(exp(loocvCut_side_smn_sub_8_48790000.log.post))
plot(sort(loocvCut_side_smn_sub_8_48790000.post),
     as.numeric(sort(unname(table(loocvCut_side_smn_sub_8_48790000.df$typeList)/nrow(loocvCut_side_smn_sub_8_48790000.df)))))
abline(0, 1)


plot(sort(loocvCut_side_smn_sub_8_4570000.post),
     sort(loocvCut_side_smn_sub_8_4570000.typePost),
     main = "Main chain sample: 4570000",
     xlab = "Expected", ylab = "Estimated", pch = 4, col  = "red")
abline(0, 1)
