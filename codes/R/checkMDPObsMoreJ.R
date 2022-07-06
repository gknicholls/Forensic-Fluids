library(LaplacesDemon)
for(i in 2:6){
  test.7obs.J2.mcmc.log.df = read.table(file = paste("/Users/chwu/Documents/research/bfc/output/testBFC_7obsv_prior_obsMoreJ", i,".log", sep=""),
                                        header = T, as.is = T, sep="\t")
  nrow(test.7obs.J2.mcmc.log.df)
  ess = ESS(test.7obs.J2.mcmc.log.df$Posterior)
  
  test.7obs.J2.post.mcmc =  table(test.7obs.J2.mcmc.log.df$Partition)/sum(table(test.7obs.J2.mcmc.log.df$Partition))
  
  
  test.7obs.J2.prior.expt = scan(file = paste("/Users/chwu/Documents/research/bfc/output/ex.10obs.mdp_obsMoreJ",i,".txt",  sep=""),
                                 what = numeric(), sep="\n")
  test.7obs.J2.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                                 what=character(), sep="\n")
  test.7obs.partitions = gsub(test.7obs.partitions, pattern = " ", replace = "")
  names(test.7obs.J2.prior.expt) = test.7obs.partitions
  
  test.7obs.J2.index = match(names( test.7obs.J2.post.mcmc), names(test.7obs.J2.prior.expt))
  
  
  test.7obs.J2.1sd = sqrt(test.7obs.J2.prior.expt[test.7obs.J2.index]*
                            (1 - test.7obs.J2.prior.expt[test.7obs.J2.index])/ESS(test.7obs.J2.mcmc.log.df$Posterior))
  pdf(file = paste("/Users/chwu/Documents/research/bfc/plots/mdpPrior7ObsJ", i,".pdf", sep=""), height = 5, width = 7)
  par(mar = c(5,5,4,2) + 0.2)
  plot(test.7obs.J2.prior.expt[test.7obs.J2.index], 
       test.7obs.J2.post.mcmc, 
       pch ="--", col="red", ylim = range(as.numeric(test.7obs.J2.post.mcmc)),
       xlab = "Expected prior probabilities", ylab = "", 
       main = paste("7 observations, J = ", i ,"\nESS = ", round(ess),", MCMC Steps = 1000000", sep=""))
  mtext(text = "MCMC estimated probabilities", side = 2, line = 2)
  #axis(side = 2, at = c(3:7)*0.005, las = 1)
  abline(0, 1)
  for(i in 1:length(test.7obs.prior.expt)){
    lines(x = rep(test.7obs.J2.prior.expt[test.7obs.J2.index][i], 2), 
          test.7obs.J2.prior.expt[test.7obs.J2.index][i] + c(1,-1)*test.7obs.J2.1sd[i], 
          lwd = 2, lend = 2)
  }
  #points(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red")
  dev.off()
  
}


for(i in 1:7){
  test.7obs.Jx.mcmc.log.df = read.table(file = paste("/Users/chwu/Documents/research/bfc/output/ex.7obs_J", i,"_v2.log", sep=""),
                                        header = T, as.is = T, sep="\t")
  nrow(test.7obs.Jx.mcmc.log.df)
  ess = ESS(test.7obs.Jx.mcmc.log.df$Posterior)
  
  test.7obs.Jx.post.mcmc =  table(test.7obs.Jx.mcmc.log.df$Partition)/sum(table(test.7obs.Jx.mcmc.log.df$Partition))
  
  
  test.7obs.Jx.prior.expt = scan(file = paste("/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp_obsMoreJ",i,".txt",  sep=""),
                                 what = numeric(), sep="\n")
  test.7obs.Jx.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                                 what=character(), sep="\n")
  test.7obs.partitions = gsub(test.7obs.Jx.partitions, pattern = " ", replace = "")
  names(test.7obs.Jx.prior.expt) = test.7obs.partitions
  
  test.7obs.Jx.index = match(names( test.7obs.Jx.post.mcmc), names(test.7obs.Jx.prior.expt))
  
  
  test.7obs.Jx.1sd = sqrt(test.7obs.Jx.prior.expt[test.7obs.Jx.index]*
                            (1 - test.7obs.Jx.prior.expt[test.7obs.Jx.index])/ESS(test.7obs.Jx.mcmc.log.df$Posterior))
  pdf(file = paste("/Users/chwu/Documents/research/bfc/plots/mdpPrior7ObsJ", i,"_v2.pdf", sep=""), height = 5, width = 7)
  par(mar = c(5,5,4,2) + 0.2)
  plot(test.7obs.Jx.prior.expt[test.7obs.Jx.index], 
       test.7obs.Jx.post.mcmc, 
       pch ="--", col="red", ylim = range(as.numeric(test.7obs.Jx.post.mcmc)),
       xlab = "Expected prior probabilities", ylab = "", 
       main = paste("7 observations, J = ", i ,"\nESS = ", round(ess),", MCMC Steps = 1000000", sep=""))
  mtext(text = "MCMC estimated probabilities", side = 2, line = 2)
  #axis(side = 2, at = c(3:7)*0.005, las = 1)
  abline(0, 1)
  for(i in 1:length(test.7obs.Jx.prior.expt)){
    lines(x = rep(test.7obs.Jx.prior.expt[test.7obs.Jx.index][i], 2), 
          test.7obs.Jx.prior.expt[test.7obs.Jx.index][i] + c(1,-1)*test.7obs.Jx.1sd[i], 
          lwd = 2, lend = 2)
  }
  #points(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red")
  dev.off()
  
}


test.multiObs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/ex.multiTypeObs.log",
                                     header = T, as.is = T, sep="\t")
nrow(test.multiObs.mcmc.log.df )
test.multiObs.mcmc.ess = ESS(test.multiObs.mcmc.log.df $Posterior)

multObsPartMat = do.call(rbind, unname(sapply(test.multiObs.mcmc.log.df$Partition, strsplit, split=" ")))
test.multiObs.part.post1 =  table(multObsPartMat[,1])/sum(table(multObsPartMat[,1]))
test.multiObs.part.post2 =  table(multObsPartMat[,2])/sum(table(multObsPartMat[,2]))
test.multiObs.part.post3 =  table(multObsPartMat[,3])/sum(table(multObsPartMat[,3]))




test.multiObs.prior.expt1 = scan(file = paste("/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp_obsMoreJ5.txt",  sep=""),
                               what = numeric(), sep="\n")
test.multiObs.prior.expt2 = scan(file = paste("/Users/chwu/Documents/research/bfc/output/ex.5obs.mdp.txt",  sep=""),
                                 what = numeric(), sep="\n")
test.multiObs.prior.expt3 = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.10obs.mdp_obsMoreJ5.txt",
                               what=numeric(), sep="\n")

test.multiObs.partitions1 = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                                 what=character(), sep="\n")
test.multiObs.partitions2 = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt",
                                 what=character(), sep="\n")
test.multiObs.partitions3 = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt",
                                 what=character(), sep="\n")

test.multiObs.partitions1 = gsub(test.multiObs.partitions1, pattern = " ", replace = "")
test.multiObs.partitions2 = gsub(test.multiObs.partitions2, pattern = " ", replace = "")
test.multiObs.partitions3 = gsub(test.multiObs.partitions3, pattern = " ", replace = "")

names(test.multiObs.prior.expt1) = test.multiObs.partitions1
names(test.multiObs.prior.expt2) = test.multiObs.partitions2
names(test.multiObs.prior.expt3) = test.multiObs.partitions3

test.multiObs.index1 = match(names(test.multiObs.part.post1), names(test.multiObs.prior.expt1))
test.multiObs.index2 = match(names(test.multiObs.part.post2), names(test.multiObs.prior.expt2))
test.multiObs.index3 = match(names(test.multiObs.part.post3), names(test.multiObs.prior.expt3))


test.multiObs.1sd1 = sqrt(test.multiObs.prior.expt1[test.multiObs.index1]*
                          (1 - test.multiObs.prior.expt1[test.multiObs.index1])/test.multiObs.mcmc.ess)




test.multiObs.1sd2 = sqrt(test.multiObs.prior.expt2[test.multiObs.index2]*
                            (1 - test.multiObs.prior.expt2[test.multiObs.index2])/test.multiObs.mcmc.ess)

test.multiObs.prior.expt3u = unique(test.multiObs.prior.expt3)
test.multiObs.1sd3 = sqrt(test.multiObs.prior.expt3u *
                            (1 - test.multiObs.prior.expt3u )/test.multiObs.mcmc.ess)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/mdpPriorMultiObs.pdf", height = 12, width = 4.5)
par(mar = c(5,5,4,2) + 0.2, mfrow = c(3,1))
plot(test.multiObs.prior.expt1[test.multiObs.index1], 
     test.multiObs.part.post1, 
     pch ="--", col="red", ylim = range(as.numeric(test.multiObs.part.post1)),
     xlab = "Expected prior probabilities", ylab = "", 
     main = paste("7 observations, J = 5","\nESS = ", round(test.multiObs.mcmc.ess),", MCMC Steps = 10^6", sep=""))
mtext(text = "MCMC estimated probabilities", side = 2, line = 2)
#axis(side = 2, at = c(3:7)*0.005, las = 1)
abline(0, 1)
for(i in 1:length(test.multiObs.prior.expt1)){
  lines(x = rep(test.multiObs.prior.expt1[test.multiObs.index1][i], 2), 
        test.multiObs.prior.expt1[test.multiObs.index1][i] + c(1,-1)*test.multiObs.1sd1[i], 
        lwd = 2, lend = 2)
}

plot(test.multiObs.prior.expt2[test.multiObs.index2], 
     test.multiObs.part.post2, 
     pch ="---", col="red", ylim = range(as.numeric(test.multiObs.part.post2)),
     xlab = "Expected prior probabilities", ylab = "", 
     main = paste("5 observations, J = 5","\nESS = ", round(test.multiObs.mcmc.ess),", MCMC Steps = 10^6", sep=""))
mtext(text = "MCMC estimated probabilities", side = 2, line = 2)
#axis(side = 2, at = c(3:7)*0.005, las = 1)
abline(0, 1)
for(i in 1:length(test.multiObs.prior.expt2)){
  lines(x = rep(test.multiObs.prior.expt2[test.multiObs.index2][i], 2), 
        test.multiObs.prior.expt2[test.multiObs.index2][i] + c(1,-1)*test.multiObs.1sd2[i], 
        lwd = 2, lend = 2)
}

plot(test.multiObs.prior.expt3[test.multiObs.index3], 
     test.multiObs.part.post3, 
     pch ="---", col="red", ylim = range(as.numeric(test.multiObs.part.post3)),
     xlab = "Expected prior probabilities", ylab = "", 
     main = paste("10 observations, J = 5","\nESS = ", round(test.multiObs.mcmc.ess),"MCMC Steps = 10^6", sep=""))
mtext(text = "MCMC estimated probabilities", side = 2, line = 2)
#axis(side = 2, at = c(3:7)*0.005, las = 1)
abline(0, 1)

for(i in 1:length(test.multiObs.prior.expt3u)){
  xpos = test.multiObs.prior.expt3u[i] + c(1,-1)*test.multiObs.1sd3[i]
  xpos[xpos<0] = 0
  lines(x = rep(test.multiObs.prior.expt3u[i], 2), 
        xpos, lwd = 2, lend = 2)
}
#points(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red")
dev.off()


