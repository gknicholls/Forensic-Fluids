test.sample.prior.parts.param20220714.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_sample_prior_parts_param_2022_07_14.log",
           header = T, as.is = T, sep = "\t")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_14/test_sample_prior_parts_param_2022_07_14.pdf",
    width = 6.5, height = 9)
par(mfrow = c(3,2))
set.seed(123)
expt0 = rgamma(nrow(test.sample.prior.parts.param20220714.df), shape = 0.5, rate = 1)
hist(test.sample.prior.parts.param20220714.df$parameter1.0,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter index = 0, Gamma(0.5, 1)", xlab= "Values")
hist(expt0, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)

plot(sort(expt0), sort(test.sample.prior.parts.param20220714.df$parameter1.0), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 0,\nGamma(0.5, 1)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)

set.seed(123)
expt1 = rgamma(nrow(test.sample.prior.parts.param20220714.df), shape = 1, rate = 1/1.5)
hist(test.sample.prior.parts.param20220714.df$parameter1.1,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter Index = 1, Gamma(1, 1.5)", xlab= "Values")
hist(expt1, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)

plot(sort(expt1), sort(test.sample.prior.parts.param20220714.df$parameter1.1), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 1,\nGamma(1, 1.5)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)

set.seed(123)
expt2 = rgamma(nrow(test.sample.prior.parts.param20220714.df), shape = 2, rate = 1/1.25)
hist(test.sample.prior.parts.param20220714.df$parameter1.2,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter Index = 2, Gamma(2, 1.25)", xlab= "Values")
hist(expt2, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)


plot(sort(expt2), sort(test.sample.prior.parts.param20220714.df$parameter1.2), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 2,\nGamma(2, 1.25)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)
dev.off()







test.7obs.post.mcmc =  table(test.sample.prior.parts.param20220714.df$typeList)/
  sum(table(test.sample.prior.parts.param20220714.df$typeList))


test.7obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp.txt",
                              what=numeric(), sep="\n"))
test.7obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                            what=character(), sep="\n")
test.7obs.partitions = gsub(test.7obs.partitions, pattern = " ", replace = "")


test.7obs.prior.expt = exp(test.7obs.logPrior)/sum(exp(test.7obs.logPrior))



names(test.7obs.prior.expt) = test.7obs.partitions
sort(test.7obs.prior.expt, decreasing = T)[1:40]

presentPartIndex = match(names(test.7obs.post.mcmc), names(test.7obs.prior.expt))


trace = apply(matrix(names(test.7obs.prior.expt[presentPartIndex])), 1,
       function(z){
         as.numeric(test.sample.prior.parts.param20220714.df$typeList == z)
         })
trace = do.call(cbind, trace)

ess = apply(trace, 2, ESS)

test.7obs.1sd = sqrt(test.7obs.prior.expt[presentPartIndex]*
                       (1 - test.7obs.prior.expt[presentPartIndex])/ess)
pdf(file = "/Users/chwu/Documents/research/bfc/plots/mdpPrior7Obs.pdf", height = 5, width = 7)
par(mar = c(5,5,4,2) + 0.2)
plot(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red", ylim = c(0, 0.0035),
     xlab = "Expected prior probabilities", ylab = "", main = "7 observations, ESS = 100471.4\n MCMC Steps = 1000000")
mtext(text = "MCMC estimated probabilities", side = 2, line = 4)
axis(side = 2, at = c(1:6)*0.0005, las = 1)
abline(0, 1)
for(i in 1:length(test.7obs.prior.expt)){
  lines(x = rep(test.7obs.prior.expt[presentPartIndex][i], 2), 
        test.7obs.prior.expt[presentPartIndex][i] + c(2,-2)*test.7obs.1sd[i], lwd = 2, lend = 2)
}
#points(test.7obs.prior.expt[presentPartIndex], test.7obs.post.mcmc, pch ="-", col="red")
dev.off()
