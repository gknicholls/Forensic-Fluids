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




