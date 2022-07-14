orderSets = function(sets = NULL){
  tempStr = gsub(sets, pattern="[", replace = "", fixed = T)
  tempStr = gsub(tempStr, pattern="]", replace = "", fixed = T)
  setOrder = order(unlist(lapply(sapply(tempStr, strsplit, split =","), function(z){as.numeric(z[1]) })))
  return(sets[setOrder])
}


orderSetsInPartStr = function(partitions = NULL){
  
  partitions = gsub(partitions, pattern = "],[", replace = "] [", fixed = T)
  partitions = gsub(partitions, pattern = "[[", replace = "[", fixed = T)
  partitions = gsub(partitions, pattern = "]]", replace = "]", fixed = T)
  partitions.list = sapply(partitions, strsplit, split = " ")
  
  orderded.set.list = lapply(partitions.list, orderSets)
  
  partitions.ordered = unname(unlist(lapply(orderded.set.list, paste, collapse =",")))
  partitions.ordered.labels = sapply(partitions.ordered, function(z){
    paste("[", z, "]", sep = "")
  })
  
  return(partitions.ordered.labels)
  
}

library(LaplacesDemon)



#test.multiObs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/ex.multiTypeObsWithUnknown_1.01.log",
#                                       header = T, as.is = T, sep="\t")


test.multiObs.mcmc.log.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_14/ex.multiTypeObsWithUnknown_2022_07_14.log",
                                       header = T, as.is = T, sep="\t")


multObsPartMat = do.call(rbind, unname(sapply(test.multiObs.mcmc.log.df$Partition, strsplit, split=" ")))
index1 = grep(multObsPartMat[,1], pattern="10")
temp1 = table(multObsPartMat[index1,1])/sum(table(multObsPartMat[index1,1]))
test.multiObs.mcmc.parts = names(temp1)
test.multiObs.mcmc.parts.new = unname(orderSetsInPartStr(partitions = test.multiObs.mcmc.parts))
test.multiObs.mcmc.parts.new = gsub(test.multiObs.mcmc.parts.new, pattern = "10", replace = "4")
names(temp1) = test.multiObs.mcmc.parts.new


test.multiObs.mcmc.parts.new.all1 = unname(orderSetsInPartStr(partitions = multObsPartMat[index1,1]))
test.multiObs.mcmc.parts.new.all1 = gsub(test.multiObs.mcmc.parts.new.all1, pattern = "10", replace = "4")

test.multiObs.mcmc.parts.trace1 = sapply(test.multiObs.mcmc.parts.new, function(target, partitions){
  as.numeric(partitions == target)
}, partitions = test.multiObs.mcmc.parts.new.all1)

test.multiObs.mcmc.parts.ESS1 = apply(test.multiObs.mcmc.parts.trace1, 2, ESS)


test.5obs.J4.prior.expt = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.5obs.mdp_obsMoreJ4.txt",
                               what = numeric(), sep="\n")
test.5obs.J4.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt",
                               what=character(), sep="\n")
test.5obs.J4.partitions = gsub(test.5obs.J4.partitions, pattern = " ", replace = "")
names(test.5obs.J4.prior.expt) = gsub(test.5obs.J4.partitions, pattern = " ", replace = "")

test.multiObs.mcmc.index1 = match(names(temp1), names(test.5obs.J4.prior.expt))

p1 = test.5obs.J4.prior.expt[test.multiObs.mcmc.index1]
partsSd1 = sqrt(p1*(1 - p1)/median(test.multiObs.mcmc.parts.ESS1))
plot(x = as.numeric(sort(test.5obs.J4.prior.expt[test.multiObs.mcmc.index1])),
     y = as.numeric(sort(temp1)), pch="---", col="red")
abline(0, 1)
for(i in 1:length(p1)){
  lines(x=rep(p1[i],2), y = p1[i] + c(-2, 2)*partsSd1[i])
}

test.4obs.prior.expt = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.4obs.mdp.txt",
                            what = numeric(), sep="\n")
test.4obs.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets4.txt",
                               what=character(), sep="\n")
test.4obs.partitions = gsub(test.4obs.partitions, pattern = " ", replace = "")
names(test.4obs.prior.expt) = test.4obs.partitions








test.4obs.prior.mcmc = table(multObsPartMat[-index1,1])/sum(table(multObsPartMat[-index1,1]))
test.4obs.prior.index = match(names(test.4obs.prior.mcmc), names(test.4obs.prior.expt))


test.multiObs.mcmc.parts.trace2 = sapply(names(test.4obs.prior.mcmc), function(target, partitions){
  as.numeric(partitions == target)
}, partitions = multObsPartMat[-index1,1])

test.multiObs.mcmc.parts.ESS2 = apply(test.multiObs.mcmc.parts.trace2, 2, ESS)


p2 = as.numeric(test.4obs.prior.expt[test.4obs.prior.index])
partsSd2 = sqrt(p2*(1 - p2)/median(test.multiObs.mcmc.parts.ESS2))
plot(x = p2, as.numeric(test.4obs.prior.mcmc), col = "red", pch = "---")
abline(0,1)
for(i in 1:length(p2)){
  lines(x=rep(p2[i],2), y = p2[i] + c(-2, 2)*partsSd2[i])
}



index2 = grep(multObsPartMat[, 2], pattern="10")
temp2 = table(multObsPartMat[index2, 2])/sum(table(multObsPartMat[index2,2]))
names(temp2) = gsub(names(temp2), pattern = "10", replace ="6")
test.multiObs.mcmc.parts2 = names(temp2)
test.multiObs.mcmc.parts.new2 = unname(orderSetsInPartStr(partitions = test.multiObs.mcmc.parts2))
test.multiObs.mcmc.parts.new2 = gsub(test.multiObs.mcmc.parts.new2, pattern = "10", replace = "6")
names(temp2) = test.multiObs.mcmc.parts.new2


test.multiObs.mcmc.parts.new.all2 = unname(orderSetsInPartStr(partitions = multObsPartMat[index2,2]))
test.multiObs.mcmc.parts.new.all2 = gsub(test.multiObs.mcmc.parts.new.all2, pattern = "10", replace = "6")

test.multiObs.mcmc.parts.trace3 = sapply(test.multiObs.mcmc.parts.new2, function(target, partitions){
  as.numeric(partitions == target)
}, partitions = test.multiObs.mcmc.parts.new.all2)

test.multiObs.mcmc.parts.ESS3 = apply(test.multiObs.mcmc.parts.trace3, 2, ESS)



test.7obs.J4.prior.expt = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.7obs.mdp_obsMoreJ4.txt",
                               what = numeric(), sep="\n")
test.7obs.J4.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt",
                               what=character(), sep="\n")
test.7obs.partitions = gsub(test.7obs.J4.partitions, pattern = " ", replace = "")
names(test.7obs.J4.prior.expt) = test.7obs.partitions


test.multiObs.mcmc.index3 = match(names(temp2), names(test.7obs.J4.prior.expt) )

p3 = test.7obs.J4.prior.expt[test.multiObs.mcmc.index3]
partsSd3 = sqrt(p3*(1 - p3)/median(test.multiObs.mcmc.parts.ESS3))
plot(x = as.numeric(test.7obs.J4.prior.expt[test.multiObs.mcmc.index3]),
     y = as.numeric(temp2), pch = "---", col = "red")
abline(0,1)
for(i in 1:length(p3)){
  lines(x=rep(p3[i],2), y = p3[i] + c(-2, 2)*partsSd3[i])
}


test.6obs.J4.prior.expt = scan(file = "/Users/chwu/Documents/research/bfc/output/ex.6obs.mdp_obsMoreJ4.txt",
                            what = numeric(), sep="\n")
test.6obs.J4.partitions = scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets6.txt",
                            what=character(), sep="\n")
test.6obs.J4.partitions = gsub(test.6obs.J4.partitions, pattern = " ", replace = "")
names(test.6obs.J4.prior.expt) = gsub(test.6obs.J4.partitions, pattern = " ", replace = "")



test.multiObs.mcmc.parts.trace4 = sapply(names(test.6obs.J4.prior.mcmc), function(target, partitions){
  as.numeric(partitions == target)
}, partitions = multObsPartMat[-index2,2])

test.multiObs.mcmc.parts.ESS4 = apply(test.multiObs.mcmc.parts.trace4, 2, ESS)



test.6obs.J4.prior.mcmc = table(multObsPartMat[-index2,2])/sum(table(multObsPartMat[-index2,2]))
test.6obs.J4.prior.index = match(names(test.6obs.J4.prior.mcmc), names(test.6obs.J4.prior.expt))
p4 = as.numeric(test.6obs.J4.prior.expt[test.6obs.J4.prior.index])
partsSd4 = sqrt(p4*(1 - p4)/median(test.multiObs.mcmc.parts.ESS4))
plot(x = p4, 
     y= as.numeric(test.6obs.J4.prior.mcmc), pch = "--", col="red",
     las = 1, ylim = c(0.001, 0.011))
abline(0,1)
for(i in 1:length(p4)){
  lines(x=rep(p4[i],2), y = p4[i] + c(-2, 2)*partsSd4[i])
}


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_14/ex.multiTypeObsWithUnknown_2022_07_14.pdf",
    width = 8, height = 7.5)
par(mfrow = c(2,2), mar = c(5, 4, 2, 1) + 0.2)
plot(x = as.numeric(sort(test.5obs.J4.prior.expt[test.multiObs.mcmc.index1])),
     y = as.numeric(sort(temp1)), pch="---", col="red",
     xlab = "Expected", ylab = "MCMC", las = 1,
     main = "#Obs = 5; J = 4")
abline(0, 1)
for(i in 1:length(p1)){
  lines(x=rep(p1[i],2), y = p1[i] + c(-2, 2)*partsSd1[i])
}

plot(x = p2, as.numeric(test.4obs.prior.mcmc), 
     main = "#Obs = 4; J = 4",
     xlab = "Expected", ylab = "MCMC", las = 1,
     col = "red", pch = "---")
abline(0,1)
for(i in 1:length(p2)){
  lines(x=rep(p2[i],2), y = p2[i] + c(-2, 2)*partsSd2[i])
}

plot(x = as.numeric(test.7obs.J4.prior.expt[test.multiObs.mcmc.index3]),
     main = "#Obs = 7; J = 4",
     xlab = "Expected", ylab = "MCMC", las = 1,
     y = as.numeric(temp2), pch = "---", col = "red")
abline(0,1)
for(i in 1:length(p3)){
  lines(x=rep(p3[i],2), y = p3[i] + c(-2, 2)*partsSd3[i])
}


plot(x = p4, 
     y= as.numeric(test.6obs.J4.prior.mcmc), pch = "--", col="red",
     main = "#Obs = 6; J = 4",
     xlab = "Expected", ylab = "MCMC", las = 1,
     las = 1, ylim = c(0.001, 0.011))
abline(0,1)
for(i in 1:length(p4)){
  lines(x=rep(p4[i],2), y = p4[i] + c(-2, 2)*partsSd4[i])
}

dev.off()
