test.3obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/testBFC_3obsv.log",
                         header = T, as.is = T, sep="\t")
plot(test.3obs.mcmc.log.df$Posterior, type="l")
table(test.3obs.mcmc.log.df$Partition)/sum(table(test.3obs.mcmc.log.df$Partition))

test.3obs.logLik = c(-40.39084678772092,-42.70034144618965,-45.12926653869357, 
                     -41.608309682312935,-45.04019146032734)
test.3obs.logPrior = log(c(0.14381914381914523, 0.22126022126022263, 0.22126022126022263,
                       0.22126022126022263, 0.1924001924001935))
test.3obs.logPost = test.3obs.logLik + test.3obs.logPrior
test.3obs.post = exp(test.3obs.logPost)/sum(exp(test.3obs.logPost))
test.3obs.post

test.4obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output_testBFC_4obsv_v1.log",
                                   header = T, as.is = T, sep="\t")
dim(test.4obs.mcmc.log.df )
plot(test.4obs.mcmc.log.df$Posterior, type="l")
test.4obs.post.mcmc =  table(test.4obs.mcmc.log.df$Partition)/
  sum(table(test.4obs.mcmc.log.df$Partition))
length(test.4obs.post.mcmc)
test.4obs.post.mcmc

test.4obs.logLik = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.obs4.log.type.lik.txt",
                        what=numeric(), sep="\n")
test.4obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.4obs.mdp.txt",
                          what=numeric(), sep="\n"))
test.4obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets4.txt",
                            what=character(), sep="\n")
test.4obs.partitions = gsub(test.4obs.partitions, pattern = " ", replace = "")

test.4obs.logPost.expt = test.4obs.logLik + test.4obs.logPrior
test.4obs.post.expt = exp(test.4obs.logPost.expt )/sum(exp(test.4obs.logPost.expt))

names(test.4obs.post.expt) = test.4obs.partitions

sort(test.4obs.post.mcmc, decreasing = T)
sort(test.4obs.post.expt, decreasing = T)


presentPartIndex = match(names(test.4obs.post.mcmc), names(test.4obs.post.expt))
test.4obs.post.expt[presentPartIndex]
test.4obs.post.mcmc

as.numeric(test.4obs.post.expt[presentPartIndex] - test.4obs.post.mcmc)/(test.4obs.post.expt[presentPartIndex])



plot(test.4obs.post.expt[presentPartIndex], test.4obs.post.mcmc)
abline(0, 1)
plot(log(test.4obs.post.expt[presentPartIndex]), log(test.4obs.post.mcmc))
abline(0, 1)


test.4obs.sample.expt = sample(test.4obs.partitions, 
                               prob = test.4obs.post.expt, 
                               size = nrow(test.4obs.mcmc.log.df), replace = T)
test.4obs.sample.expt.prob = table(test.4obs.sample.expt)/sum(table(test.4obs.sample.expt))

presentPartIndex2 = match(names(test.4obs.sample.expt.prob ), names(test.4obs.post.mcmc))

plot(as.numeric(log(test.4obs.sample.expt.prob)), 
     log(as.numeric(test.4obs.post.mcmc[presentPartIndex2])))
abline(0, 1)



test.5obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/testBFC_5obsv_v1.log",
                                   header = T, as.is = T, sep="\t")
nrow(test.5obs.mcmc.log.df )
test.5obs.post.mcmc =  table(test.5obs.mcmc.log.df$Partition)/sum(table(test.5obs.mcmc.log.df$Partition))
sort(test.5obs.post.mcmc )
plot(test.5obs.mcmc.log.df$Posterior, type="l")

length(test.5obs.post.mcmc)

ESS(test.5obs.mcmc.log.df$Posterior)


test.5obs.logLik = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.obs5.log.type.lik.txt",
                        what=numeric(), sep="\n")
test.5obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.5obs.mdp.txt",
                          what=numeric(), sep="\n"))
test.5obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt",
                          what=character(), sep="\n")
test.5obs.partitions = gsub(test.5obs.partitions, pattern = " ", replace = "")

test.5obs.logPost.expt = test.5obs.logLik + test.5obs.logPrior
test.5obs.post.expt = exp(test.5obs.logPost)/sum(exp(test.5obs.logPost))



names(test.5obs.post.expt) = test.5obs.partitions
sort(test.5obs.post.expt)

presentPartIndex = match(names(test.5obs.post.mcmc), names(test.5obs.post.expt))
test.5obs.post.expt[presentPartIndex]
test.5obs.post.mcmc

sort(test.5obs.post.expt, decreasing = T)[1:20]
sort(test.5obs.post.mcmc, decreasing = T)[1:20]



plot(test.5obs.post.expt[presentPartIndex], test.5obs.post.mcmc)
abline(0, 1)
plot(log(test.5obs.post.expt[presentPartIndex]), log(test.5obs.post.mcmc))
abline(0, 1)


test.5obs.sample.expt = sample(test.5obs.partitions, prob = test.5obs.post.expt, 
                               size = round(ESS(test.5obs.mcmc.log.df$Posterior)), replace = T)
test.5obs.sample.expt.prob = table(test.5obs.sample.expt)/sum(table(test.5obs.sample.expt))

presentPartIndex2 = match(names(test.5obs.sample.expt.prob ), names(test.5obs.post.mcmc))
plot(as.numeric(log(test.5obs.sample.expt.prob)), log(as.numeric(test.5obs.post.mcmc[presentPartIndex2])))
abline(0, 1)



test.10obs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/testBFC_10obsv_v4.log",
                                   header = T, as.is = T, sep="\t")
ESS(test.10obs.mcmc.log.df$Posterior)
nrow(test.10obs.mcmc.log.df )

test.10obs.post.mcmc =  table(test.10obs.mcmc.log.df$Partition)/
  sum(table(test.10obs.mcmc.log.df$Partition))
sort(test.10obs.post.mcmc, decreasing = T)[1:10]

plot(test.10obs.mcmc.log.df$Posterior, type="l")
length(test.10obs.post.mcmc)

test.10obs.logLik = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.obs10v2.log.type.lik.v2.txt",
                        what=numeric(), sep="\n")
test.10obs.logPrior = log(scan(file = "/Users/chwu/Documents/research/bfc/output/ex.10obs.mdp.txt",
                              what=numeric(), sep="\n"))
test.10obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt",
                            what=character(), sep="\n")
test.10obs.partitions = gsub(test.10obs.partitions, pattern = " ", replace = "")
test.10obs.logPost.expt = test.10obs.logLik + test.10obs.logPrior
test.10obs.post.expt = exp(test.10obs.logPost.expt)/sum(exp(test.10obs.logPost.expt))
names(test.10obs.post.expt) = test.10obs.partitions
names(test.10obs.logLik ) = test.10obs.partitions

test.10obs.post.expt["[[0,3,4,5],[1,2,6,7,8,9]]"]

test.10obs.sample.expt = sample(test.10obs.partitions, prob = test.10obs.post.expt, 
                               size = round(ESS(test.10obs.mcmc.log.df$Posterior)), replace = T)
test.10obs.sample.expt.prob = table(test.10obs.sample.expt)/sum(table(test.10obs.sample.expt))


presentPartIndex2 = match(names(test.10obs.sample.expt.prob ), 
                          names(test.10obs.post.mcmc))

plot(as.numeric((test.10obs.sample.expt.prob)), 
     (as.numeric(test.10obs.post.mcmc[presentPartIndex2])),
     xlab = "log(direct-sample posterior)",
     ylab = "log(MCMC posterior)")
abline(0, 1)
plot(as.numeric(log(test.10obs.sample.expt.prob)), 
     log(as.numeric(test.10obs.post.mcmc[presentPartIndex2])),
     xlab = "log(direct-sample posterior)",
     ylab = "log(MCMC posterior)")
abline(0, 1)


plot(as.numeric(log(test.10obs.sample.expt.prob)), 
     log(as.numeric(test.10obs.post.mcmc[presentPartIndex2])),
     xlab = "log(direct-sample posterior)",
     ylab = "log(MCMC posterior)")
abline(0, 1)

sort(test.10obs.post.mcmc, decreasing = T)[1:10]
test.10obs.post.mcmc["[[0,1,2,3,4,5],[6,7,8,9]]"]
plot(x = log(as.numeric(test.10obs.post.expt[match(names(test.10obs.post.mcmc), names(test.10obs.post.expt))])),
     y = log(as.numeric(test.10obs.post.mcmc)))
abline(0, 1)

sort(test.10obs.post.expt, decreasing = T)[1:10]
test.10obs.post.expt["[[0,1,2,3,4,5,8],[6,7,9]]"]
test.10obs.post.expt["[[0,1,2,3,4,5,9],[6,7,8]]"]
