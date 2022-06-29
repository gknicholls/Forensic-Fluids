

test.7obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/testBFC_7obsv_prior.log",
                                   header = T, as.is = T, sep="\t")
test.7obs.mcmc.log.df = test.7obs.mcmc.log.df[-1,]
nrow(test.7obs.mcmc.log.df )
ESS(test.7obs.mcmc.log.df$Posterior)

test.7obs.post.mcmc =  table(test.7obs.mcmc.log.df$Partition)/sum(table(test.7obs.mcmc.log.df$Partition))


test.7obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp.txt",
                              what=numeric(), sep="\n"))
test.7obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                            what=character(), sep="\n")
test.7obs.partitions = gsub(test.7obs.partitions, pattern = " ", replace = "")


test.7obs.prior.expt = exp(test.7obs.logPrior)/sum(exp(test.7obs.logPrior))



names(test.7obs.prior.expt) = test.7obs.partitions
sort(test.7obs.prior.expt, decreasing = T)[1:40]

presentPartIndex = match(names(test.7obs.post.mcmc), names(test.7obs.prior.expt))


test.7obs.1sd = sqrt(test.7obs.prior.expt[presentPartIndex]*(1 - test.7obs.prior.expt[presentPartIndex])/ESS(test.7obs.mcmc.log.df$Posterior))
pdf(file = "/Users/chwu/Documents/research/bfc/plots/mdpPrior7Obs.pdf", height = 5, width = 7)
par(mar = c(5,5,4,2) + 0.2)
plot(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red", ylim = c(0, 0.0035),
     xlab = "Expected prior probabilities", ylab = "", main = "7 observations, ESS = 100471.4\n MCMC Steps = 1000000")
mtext(text = "MCMC estimated probabilities", side = 2, line = 4)
axis(side = 2, at = c(1:6)*0.0005, las = 1)
abline(0, 1)
for(i in 1:length(test.7obs.prior.expt)){
  lines(x = rep(test.7obs.prior.expt[presentPartIndex][i], 2), 
        test.7obs.prior.expt[presentPartIndex][i] + c(1,-1)*test.7obs.1sd[i], lwd = 2, lend = 2)
}
#points(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red")
dev.off()

plot(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc)
abline(0, 1)


plot(log(test.5obs.post.expt[presentPartIndex]), log(test.5obs.post.mcmc))
abline(0, 1)




test.10obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/testBFC_10obsv_prior.log",
                                   header = T, as.is = T, sep="\t")
test.10obs.mcmc.log.df = test.10obs.mcmc.log.df[-1,]
nrow(test.10obs.mcmc.log.df )
ESS(test.10obs.mcmc.log.df$Posterior)

test.10obs.post.mcmc =  table(test.10obs.mcmc.log.df$Partition)/sum(table(test.10obs.mcmc.log.df$Partition))

test.10obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.10obs.mdp.txt",
                              what=numeric(), sep="\n"))
test.10obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt",
                            what=character(), sep="\n")
test.10obs.partitions = gsub(test.10obs.partitions, pattern = " ", replace = "")
test.10obs.prior.expt = exp(test.10obs.logPrior)/sum(exp(test.10obs.logPrior))


names(test.10obs.prior.expt) = test.10obs.partitions
sort(test.10obs.prior.expt, decreasing = T)[1:40]

presentPartIndex = match(names(test.10obs.post.mcmc), names(test.10obs.prior.expt))

test.10obs.prior.expt.unique = unique(test.10obs.prior.expt)
test.10obs.1sd = sqrt(test.10obs.prior.expt.unique*(1 -test.10obs.prior.expt.unique)/ESS(test.10obs.mcmc.log.df$Posterior))


pdf(file = "/Users/chwu/Documents/research/bfc/plots/mdpPrior10Obs.pdf", height = 5, width = 7)
par(mar = c(5,5,4,2) + 0.2)
plot(test.10obs.prior.expt[presentPartIndex], 
     test.10obs.post.mcmc, type ="n", 
     ylim = c(0, 0.00014),
     xlab = "Expected prior probabilities", ylab = "", 
     main = "7 observations, ESS = 100471.4\n MCMC Steps = 1000000")
mtext(text = "MCMC estimated probabilities", side = 2, line = 4)
axis(side = 2, at = c(1:6)*1e-5*2, las = 1)
abline(0, 1)
upr = test.10obs.prior.expt.unique + test.10obs.1sd
lwr = test.10obs.prior.expt.unique - test.10obs.1sd
lwr[lwr < 0] = 0
for(i in 1:length(test.10obs.prior.expt.unique)){
  
  lines(x = rep(test.10obs.prior.expt.unique[i], 2), 
       y = c(upr[i], lwr[i]), lwd = 7.5, lend = 2)
}
points(test.10obs.prior.expt[presentPartIndex], test.10obs.post.mcmc, pch ="-", col="red")
dev.off()