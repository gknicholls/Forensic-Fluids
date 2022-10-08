missing_alph1.df.list = list()
prefix = "/Users/chwu/Documents/research/bfc/output/2022_09_02/ex.missing_J5_slv5_bld50_2022_09_02_probs_"
alph1.post.type.probs = matrix(nr = 9, nc = 2)
for(i in 1:9){
  missing_alph1.df.list[[i]] = read.table(file = paste(prefix, i/10, "_", 1 - i/10, ".log", sep=""),
             header = T, as.is =T, sep = "\t")
  alph1.post.type.probs[i,] = 
    table(missing_alph1.df.list[[i]]$unknownType.0)/nrow(missing_alph1.df.list[[i]])
}

plot(alph1.post.type.probs[,1], c(1:9)/10)
abline(0, 1, col = "red")
missing_alph1.ESS = unlist(lapply(missing_alph1.df.list, 
       function(z){
         ESS(z$unknownType.0)
         }))
plot(missing_alph1.ESS)


missing_alph0.1.df.list = list()
prefix = "/Users/chwu/Documents/research/bfc/output/2022_09_02/ex.missing_alph0.1_J5_slv5_bld50_2022_09_02_probs_"
alph0.1.post.type.probs = matrix(nr = 9, nc = 2)
for(i in 1:9){
  missing_alph0.1.df.list[[i]] = read.table(file = paste(prefix, i/10, "_", 1 - i/10, ".log", sep=""),
                                          header = T, as.is =T, sep = "\t")
  alph0.1.post.type.probs[i,] = 
    table(missing_alph0.1.df.list[[i]]$unknownType.0)/nrow(missing_alph0.1.df.list[[i]])
}
ESS(missing_alph0.1.df.list[[i]]$unknownType.0)

missing_alph0.1.ESS = unlist(lapply(missing_alph0.1.df.list, 
                                  function(z){
                                    ESS(z$unknownType.0)
                                  }))
plot(missing_alph0.1.ESS)


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_02/ex.missing_J5_slv5_bld50_2022_09_02.pdf",
    height = 4.5, width = 9)
par(mfrow = c(1, 2), mar = c(5, 4, 1, 1) + 0.2)
plot(x = c(0,1), y = c(0,1), 
     type="l", col = "#093E42", lwd=2, lend=2, las = 1,
     xlab = "Prior", ylab = "Posterior")
points(x = c(1:9)/10, y = alph0.1.post.type.probs[,1], pch = 3, lwd=1.75, lend=2, col="#EB4D28")
points(x = c(1:9)/10, y = alph1.post.type.probs[,1], pch = 4, lwd=1.75, lend=2, col="#382D58")
legend("topleft", 
       c(expression(alpha[r]~"= 0.1"), expression(alpha[r]~"= 1")),
       col = c("#EB4D28", "#382D58"), pch = c(3,4))


plot(x = c(0,1), y = c(0,0), 
     ylim = c(-0.015, 0.015), type="l", 
     col = "#093E42", lwd=2, lend=2, las = 1,
     xlab = "Prior", ylab = "Posterior - prior")
points(x = c(1:9)/10, y = alph0.1.post.type.probs[,1] - c(1:9)/10, pch = 3, lwd=1.75, lend=2, col="#EB4D28")
points(x = c(1:9)/10, y = alph1.post.type.probs[,1] - c(1:9)/10, pch = 4, lwd=1.75, lend=2, col="#382D58")
legend("topright", 
       c(expression(alpha[r]~"= 0.1"), expression(alpha[r]~"= 1")),
       col = c("#EB4D28", "#382D58"), pch = c(3,4))
dev.off()

log1.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/ex.missing_alph0.1_J5_slv5_bld50_2022_09_02_probs_0.9_0.1_v2.log",
                   header = T, as.is =T, sep = "\t")

log2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/ex.missing_alph0.1_J5_slv5_bld50_2022_09_02_probs_0.9_0.1.log",
                     header = T, as.is =T, sep = "\t")

all(log1.df$log.posterior == log2.df$log.posterior)

log3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/all0s_J5_slv5_bld50_2022_09_02_probs_0.5_0.5.log",
                     header = T, as.is =T, sep = "\t")

print(table(log3.df$unknownType.0)/sum(table(log3.df$unknownType.0)), digits = 12)
hist(log3.df$log.posterior[log3.df$unknownType.0 == 0])
hist(log3.df$log.posterior[log3.df$unknownType.0 == 1])


summary(log3.df$multiTypeMDP[log3.df$unknownType.0 == 0])
summary(log3.df$multiTypeMDP[log3.df$unknownType.0 == 1])

summary(log3.df$log.posterior[log3.df$unknownType.0 == 0])
summary(log3.df$log.posterior[log3.df$unknownType.0 == 1])
length(grep(log3.df$typeList, pattern = "[55]", fixed = T))

log4.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/all0s_J15_slv5_bld50_2022_09_02_probs_0.5_0.5.log",
                     header = T, as.is =T, sep = "\t")
length(grep(log4.df$typeList, pattern = "[55]", fixed = T))
print(table(log4.df$unknownType.0)/sum(table(log4.df$unknownType.0)), digits = 12)



log5.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/all1s_J5_slv5_bld50_2022_09_02_probs_0.5_0.5.log",
                     header = T, as.is =T, sep = "\t")
length(grep(log5.df$typeList, pattern = "[55]", fixed = T))
table(log5.df$unknownType.0)/sum(table(log5.df$unknownType.0))

log6.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_02/all1s_J15_slv5_bld50_2022_09_02_probs_0.5_0.5.log",
                     header = T, as.is =T, sep = "\t")

table(log6.df$unknownType.0)/sum(table(log6.df$unknownType.0))
length(grep(log5.df$typeList, pattern = "[55]", fixed = T))

log7.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_typical_unknown_2022_09_03.log",
                     header = T, as.is =T, sep = "\t")
log7.df = log7.df[-c(1:18000),]
nrow(log7.df)
plot(log7.df$log.posterior,type="l")
table(log7.df$unknownType.0)/length(log7.df$unknownType.0)
ESS(log7.df$log.posterior)
ESS(log7.df$unknownType.0)
length(grep(log7.df$typeList, pattern = "[146]", fixed = T))/nrow(log7.df)
length(grep(log7.df$typeList[log7.df$unknownType.0 == 0], pattern = "[146]", fixed = T))/
  length(log7.df$typeList[log7.df$unknownType.0 == 0])
length(grep(log7.df$typeList[log7.df$unknownType.0 == 1], pattern = "[146]", fixed = T))/
  length(log7.df$typeList[log7.df$unknownType.0 == 1])

log8.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v1_unknown_2022_09_03.log",
                     header = T, as.is =T, sep = "\t")
plot(log8.df$log.posterior[-c(1:2500)],type="l")
ESS(log8.df$log.posterior[-c(1:2500)])
ESS(log8.df$unknownType.0[-c(1:2500)])
table(log8.df$unknownType.0[-c(1:2500)])/length(log8.df$unknownType.0[-c(1:2500)])
nrow(log8.df)
length(grep(log8.df$typeList, pattern = "[146]", fixed = T))/nrow(log8.df)
length(grep(log8.df$typeList[log8.df$unknownType.0 == 0], pattern = "[146]", fixed = T))/
  length(log8.df$typeList[log8.df$unknownType.0 == 0])
length(grep(log8.df$typeList[log8.df$unknownType.0 == 1], pattern = "[146]", fixed = T))/
  length(log8.df$typeList[log8.df$unknownType.0 == 1])



log9.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v2_unknown_2022_09_03.log",
                     header = T, as.is =T, sep = "\t")
plot(log9.df$log.posterior,type="l")
plot(log9.df$log.posterior[-c(1:1000)],type="l")
ESS(log9.df$log.posterior[-c(1:1000)])
ESS(log9.df$unknownType.0[-c(1:1000)])
table(log9.df$unknownType.0[-c(1:1000)])/length(log9.df$unknownType.0[-c(1:1000)])
length(grep(log9.df$typeList, pattern = "[146]", fixed = T))/nrow(log9.df)
length(grep(log9.df$typeList, pattern = ",146", fixed = T))

length(grep(log9.df$typeList[log9.df$unknownType.0 == 0], pattern = "[146]", fixed = T))/
  length(log9.df$typeList[log9.df$unknownType.0 == 0])
length(grep(log9.df$typeList[log9.df$unknownType.0 == 1], pattern = "[146]", fixed = T))/
  length(log9.df$typeList[log9.df$unknownType.0 == 1])




log10.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_equal.log",
                     header = T, as.is =T, sep = "\t")
nrow(log10.df)
plot(log10.df$log.posterior,type="l")
plot(log10.df$log.posterior[-c(1:1600)],type="l")
ESS(log10.df$log.posterior[-c(1:1600)])
ESS(log10.df$unknownType.0[-c(1:1600)])

ESS(as.numeric(abs(diff(log10.df$unknownType.0))>0))

ESS(cumsum(as.numeric(abs(diff(log10.df$unknownType.0[-c(1:1600)]))>0))%%2)

table(log10.df$unknownType.0[-c(1:1600)])/length(log10.df$unknownType.0[-c(1:1600)])-0.2

table(log10.df$unknownType.0)/length(log10.df$unknownType.0)
length(grep(log10.df$typeList, pattern = "[336]", fixed = T))/nrow(log10.df)
length(grep(log10.df$typeList, pattern = ",146", fixed = T))

length(grep(log9.df$typeList[log.df$unknownType.0 == 0], pattern = "[146]", fixed = T))/
  length(log9.df$typeList[log9.df$unknownType.0 == 0])
length(grep(log9.df$typeList[log9.df$unknownType.0 == 1], pattern = "[146]", fixed = T))/
  length(log9.df$typeList[log9.df$unknownType.0 == 1])


log11.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_asc.log",
                      header = T, as.is =T, sep = "\t")
plot(log11.df$log.posterior,type="l")
plot(log11.df$log.posterior[-c(1:400)],type="l")
ESS(log11.df$log.posterior[-c(1:400)])
table(log11.df$unknownType.0[-c(1:400)])/length(log11.df$unknownType.0[-c(1:400)])-1:5/15
ESS(cumsum(as.numeric(abs(diff(log11.df$unknownType.0[-c(1:400)]))>0))%%2)

log12.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_dsc.log",
                      header = T, as.is =T, sep = "\t")
plot(log12.df$log.posterior,type="l")
plot(log12.df$log.posterior[-c(1:500)],type="l")
ESS(log12.df$log.posterior[-c(1:500)])
table(log12.df$unknownType.0[-c(1:500)])/length(log12.df$unknownType.0[-c(1:500)])-5:1/15
ESS(cumsum(as.numeric(abs(diff(log12.df$unknownType.0[-c(1:500)]))>0))%%2)


log13.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_rdm1.log",
                      header = T, as.is =T, sep = "\t")
plot(log13.df$log.posterior,type="l")
plot(log13.df$log.posterior[-c(1:500)],type="l")
ESS(log13.df$log.posterior[-c(1:500)])
table(log13.df$unknownType.0[-c(1:500)])/length(log13.df$unknownType.0[-c(1:500)])-
  c(0.01061091,0.34657402,0.28125766,0.20655313,0.15500428)
ESS(cumsum(as.numeric(abs(diff(log13.df$unknownType.0[-c(1:500)]))>0))%%2)

log14.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_rdm2.log",
                      header = T, as.is =T, sep = "\t")
nrow(log14.df )
plot(log14.df$log.posterior,type="l")
plot(log14.df$log.posterior[-c(1:300)],type="l")
ESS(log14.df$log.posterior[-c(1:300)])
table(log14.df$unknownType.0[-c(1:300)])/length(log14.df$unknownType.0[-c(1:300)])-
  c(0.254,0.297,0.311,0.024,0.114)
ESS(cumsum(as.numeric(abs(diff(log14.df$unknownType.0[-c(1:500)]))>0))%%2)


log15.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_typical_unknown_5type_2022_09_09.log",
                      header = T, as.is =T, sep = "\t")
nrow(log15.df )
plot(log15.df$log.posterior,type="l")
plot(log15.df$log.posterior[-c(1:200)],type="l")

log15.df = log15.df[-c(1:200),]
ESS(log15.df$log.posterior)
table(log15.df$unknownType.0)/length(log15.df$unknownType.0)
ESS(cumsum(as.numeric(abs(diff(log15.df$unknownType.0[-c(1:200)]))>0))%%2)

plot(as.numeric(log15.df$unknownType.0==0), type="l")
ESS(as.numeric(log15.df$unknownType.0==0))
plot(as.numeric(log15.df$unknownType.0==1), type="l")
ESS(as.numeric(log15.df$unknownType.0==1))
plot(as.numeric(log15.df$unknownType.0==2), type="l")
ESS(as.numeric(log15.df$unknownType.0==2))
plot(as.numeric(log15.df$unknownType.0==3), type="l")
ESS(as.numeric(log15.df$unknownType.0==3))
plot(as.numeric(log15.df$unknownType.0==4), type="l")
ESS(as.numeric(log15.df$unknownType.0==4))

ESS(as.numeric(abs(diff(log15.df$unknownType.0))>0))
plot(as.numeric(abs(diff(log15.df$unknownType.0))>0), type="l")

length(grep(log15.df$typeList, pattern = "[336]", fixed = T))/nrow(log15.df)

sapply(c(0:4), function(z){
  length(grep(log15.df$typeList[log15.df$unknownType.0 == z], pattern = "[336]", fixed = T))/
    length(log15.df$typeList[log15.df$unknownType.0 == z])
})


log15v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_typical_unknown_5type_2022_09_10.log",
                      header = T, as.is =T, sep = "\t")
nrow(log15v2.df )
plot(log15v2.df$log.posterior,type="l")
plot(log15v2.df$log.posterior[-c(1:150)],type="l", col = "#FF000055")

plot(log15.df$log.posterior,type="l", las = 1,
     ylim = c(-1900,-1780), col = "#FF000088",
     xlab = "MCMC step", ylab = "log(Posterior)",
     main = "Synthetic profile like\ntypical training saliva")
lines(x=1:length(log15v2.df$log.posterior), 
      log15v2.df$log.posterior, col = "#0000FF88")

ESS(c(log15v2.df$log.posterior[-c(1:150)], log15.df$log.posterior[-c(1:200)]))


log15v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_typical_unknown_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(log15v2.df), 
       function(z){
         all(log15v2.df[,z]==log15v3.df[,z])
       }
)




log16.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_atypical_v1_unknown_5type_2022_09_09.log",
                      header = T, as.is =T, sep = "\t")
nrow(log16.df )
plot(log16.df$log.posterior,type="l")
plot(log16.df$log.posterior[-c(1:300)],type="l")
log16.df = log16.df[-c(1:300),]
ESS(log16.df$log.posterior)
table(log16.df$unknownType.0)/length(log16.df$unknownType.0)
table(log16.df$unknownType.0)

length(grep(log16.df$typeList, pattern = "[336]", fixed = T))/nrow(log16.df)
sapply(c(0:4), function(z){
  length(grep(log16.df$typeList[log16.df$unknownType.0 == z], pattern = "[336]", fixed = T))/
    length(log16.df$typeList[log16.df$unknownType.0 == z])
})


log16v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_atypical_v1_unknown_5type_2022_09_10.log",
                      header = T, as.is =T, sep = "\t")
nrow(log16v2.df )
plot(log16.df$log.posterior, type="l", ylim = c(-1900,-1800))
lines(x = 1:length(log16v2.df$log.posterior), log16v2.df$log.posterior, col="red")


plot(log16v2.df$log.posterior[-c(1:700)],type="l")
ESS(log16v2.df$log.posterior[-c(1:700)])
table(log16.df$unknownType.0[-c(1:300)])/length(log16.df$unknownType.0[-c(1:300)])
table(log16.df$unknownType.0)



log16v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_atypical_v1_unknown_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(log16v2.df), 
       function(z){
         all(log16v2.df[,z]==log16v3.df[,z])
       }
)



log17.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_atypical_v2_unknown_5type_2022_09_09.log",
                      header = T, as.is =T, sep = "\t")
nrow(log17.df )
plot(log17.df$log.posterior,type="l")
plot(log17.df$log.posterior[-c(1:400)],type="l")
log17.df = log17.df[-c(1:400),]
ESS(log17.df$log.posterior)
table(log17.df$unknownType.0)/length(log17.df$unknownType.0)


length(grep(log17.df$typeList, pattern = "[336]", fixed = T))/nrow(log17.df)

sapply(c(0:4), function(z){
  length(grep(log17.df$typeList[log17.df$unknownType.0 == z], pattern = "[336]", fixed = T))/
    length(log17.df$typeList[log17.df$unknownType.0 == z])
})

log17v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_atypical_v2_unknown_5type_2022_09_10.log",
                        header = T, as.is =T, sep = "\t")
nrow(log17v2.df )
plot(log17v2.df$log.posterior, type="l")
plot(log17.df$log.posterior, type="l", ylim = c(-1900,-1800))
lines(x = 1:length(log17v2.df$log.posterior), log17v2.df$log.posterior, col="red")
ESS(c(log17.df$log.posterior[-c(1:4000)],
      log17v2.df$log.posterior[-c(1:200)]))




log17v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_atypical_v2_unknown_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(log17v2.df), 
       function(z){
         all(log17v2.df[,z]==log17v3.df[,z])
       }
)



log18.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/all0s_5type_2022_09_09.log",
                      header = T, as.is =T, sep = "\t")
nrow(log18.df )
plot(log18.df$log.posterior,type="l")
plot(log18.df$log.posterior[-c(1:250)],type="l")

log18.df = log18.df[-c(1:250),]
ESS(log18.df$log.posterior)
ESS(log18.df$unknownType.0[-c(1:250)])
table(log18.df$unknownType.0)/length(log18.df$unknownType.0)

length(grep(log18.df$typeList, pattern = "[336]", fixed = T))/nrow(log18.df)
sapply(c(0:4), function(z){
  length(grep(log18.df$typeList[log18.df$unknownType.0 == z], pattern = "[336]", fixed = T))/
    length(log18.df$typeList[log18.df$unknownType.0 == z])
})

ESS(as.numeric(log18.df$unknownType.0==0))
ESS(as.numeric(log18.df$unknownType.0==1))
ESS(as.numeric(log18.df$unknownType.0==2))
ESS(as.numeric(log18.df$unknownType.0==3))
ESS(as.numeric(log18.df$unknownType.0==4))


log18v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all0s_5type_2022_09_10.log",
                      header = T, as.is =T, sep = "\t")
nrow(log18v2.df )
plot(log18v2.df$log.posterior, type="l")
plot(log18.df$log.posterior, type="l", ylim = c(-1900,-1785))
lines(x = 1:length(log18v2.df$log.posterior), log18v2.df$log.posterior, col="red")
ESS(log18v2.df$log.posterior[-c(1:200)])
ESS(c(log18.df$log.posterior[-c(1:200)],
      log18v2.df$log.posterior[-c(1:200)]))

log18v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/all0s_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(log18v2.df), 
       function(z){
         all(log18v2.df[,z]==log18v3.df[,z])
         }
       )


log19.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/all1s_5type_2022_09_09.log",
                      header = T, as.is =T, sep = "\t")
nrow(log19.df )
plot(log19.df$log.posterior,type="l")
plot(log17.df$log.posterior[-c(1:400)],type="l")
log19.df = log19.df[-c(1:400),]

ESS(log19.df$log.posterior)
ESS(log19.df$unknownType.0)
table(log19.df$unknownType.0)/length(log19.df$unknownType.0)

length(grep(log19.df$typeList, pattern = "[336]", fixed = T))/nrow(log19.df)
sapply(c(0:4), function(z){
  length(grep(log19.df$typeList[log19.df$unknownType.0 == z], pattern = "[336]", fixed = T))/
    length(log19.df$typeList[log19.df$unknownType.0 == z])
})



log19v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all1s_5type_2022_09_10.log",
                        header = T, as.is =T, sep = "\t")
nrow(log19v2.df )
plot(log19v2.df$log.posterior, type="l")
plot(log19.df$log.posterior, type="l", ylim = c(-1900,-1785))
lines(x = 1:length(log19v2.df$log.posterior), log19v2.df$log.posterior, col="red")
plot(log19v2.df$log.posterior[10*c(1:1000)][-c(1:20)], type="l")
ESS(log19v2.df$log.posterior[10*c(1:1000)][-c(1:20)])
ESS(log19v2.df$log.posterior[-c(1:200)])
ESS(c(log19.df$log.posterior[-c(1:400)],
      log19v2.df$log.posterior[-c(1:200)]))


log19v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/all1s_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(log19v2.df), 
       function(z){
         all(log19v2.df[,z]==log19v3.df[,z])
       }
)



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_10/checkConvergence_2022_09_10.pdf",
    height = 9, width = 7)
par(mfrow = c(3,2), mar = c(4,4,4,2)+0.2)

plot(log15.df$log.posterior,type="l", las = 1,
     ylim = c(-1900,-1780), col = "#FF000088",
     xlab = "MCMC step", ylab = "log(Posterior)",
     main = "Synthetic profile like\ntypical training saliva")
lines(x=1:length(log15v2.df$log.posterior), 
      log15v2.df$log.posterior, col = "#0000FF88")

plot(log16.df$log.posterior, type="l", las = 1,
     ylim = c(-1900,-1800), col = "#FF000088",
     xlab = "MCMC step", ylab = "log(Posterior)",
     main = "Synthetic profile unlike\ntypical training saliva (v1)")
lines(x = 1:length(log16v2.df$log.posterior), 
      log16v2.df$log.posterior, col="#0000FF88")

plot(log17.df$log.posterior, type="l", las = 1,
     ylim = c(-1900,-1800), col = "#FF000088",
     xlab = "MCMC step", ylab = "log(Posterior)",
     main = "Synthetic profile unlike\ntypical training saliva (v2)")
lines(x = 1:length(log17v2.df$log.posterior), 
      log17v2.df$log.posterior, col="#0000FF88")
dev.off()
