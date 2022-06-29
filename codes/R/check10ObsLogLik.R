setwd("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/")
library(salso)
source("forensicFunctions.R")
load(file = "output/allPartSets10.RData")
load("output/allParts5And7EltsMatsAndSets.rda")

singleTypeFilePath = "data/data.csv"
single.df = read.csv(singleTypeFilePath, header = TRUE) # whole single sample data

cvfMkrs = c("CYP", "HBD1", "Lcris", "Lgas", "MUC4")
mtbMkrs = c("Hs202072", "LEFTY2", "MMP10", "MMP11", "MMP7", "MSX1", "SFRP4")
slvMkrs = c("HTN3", "MUC7", "PRB4", "SMR3B", "STATH")
bldMkrs = c("ALAS2", "GlycoA", "HBB", "PF4", "SPTB")
smnMkrs = c("MSMB", "PRM1", "PRM2", "SEMG1", "TGM4")
allMkrs = c(cvfMkrs, mtbMkrs, slvMkrs, bldMkrs, smnMkrs)
mkrList = list("cvf" = cvfMkrs, 
               "mtb" = mtbMkrs, 
               "slv" = slvMkrs, 
               "bld" = bldMkrs, 
               "smn" = smnMkrs)



slv.df = single.df[single.df$Sample == 3, allMkrs] # saliva
set.seed(123)
slv.kmeans = kmeans(slv.df,centers = 3, nstart = 10)

set.seed(123)
s1 = sample(1:table(slv.kmeans$cluster)[1], 3)
s2 = sample(1:table(slv.kmeans$cluster)[2], 2)
s3 = sample(1:table(slv.kmeans$cluster)[3], 5)

slv.10obs.df = rbind(slv.df[slv.kmeans$cluster==1,][s1,],
                     slv.df[slv.kmeans$cluster==2,][s2,],
                     slv.df[slv.kmeans$cluster==3,][s3,])

ex.obs10.log.type.lik = c()
for(partIndex in 1:length(allPartSets10List)){
  ex.subtype.log.lik.expt = c()
  
  for(setIndex in 1:length(allPartSets10List[[partIndex]])){
    obsPartIndexes = allPartSets10List[[partIndex]][[setIndex]]
    ex.subtype.log.lik.expt[setIndex] = 
      calcLogSubTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList,
                        eltsAllPartSetPriorList = mkr27EltsAllPartSetPriorList,
                        sample = slvEx10obs.df[obsPartIndexes,],
                        mkrList = mkrList,
                        alphaC = c(0.5, 1.0, 1.5, 2.0, 2.5),
                        betaC = c(2.25, 1.75, 1.25, 0.75, 0.25))
  }
  ex.obs10.log.type.lik[partIndex] = sum(ex.subtype.log.lik.expt)
  if(partIndex%%1000 == 0){
    print(partIndex);
  }
}

slvSubtypeList = list(c(1:16), 17:32, 33:48, 49:64, 65:81)
mkr27EltsAllPartSetList = list(elts5AllPartSet, elts7AllPartSet, elts5AllPartSet, elts5AllPartSet, elts5AllPartSet)
elts5AllPartSetMDPPrior = unlist(lapply(mkr27EltsAllPartSetList[[1]], calcMDPColPrior, alpha = 1, setCountMax = 5))
elts7AllPartSetMDPPrior = unlist(lapply(mkr27EltsAllPartSetList[[2]], calcMDPColPrior, alpha = 1, setCountMax = 7))
mkr27EltsAllPartSetPriorList = list(elts5AllPartSetMDPPrior,
                                    elts7AllPartSetMDPPrior,
                                    elts5AllPartSetMDPPrior,
                                    elts5AllPartSetMDPPrior,
                                    elts5AllPartSetMDPPrior)
set.seed(333)
ex.10obs.log.lik = c()
for(partIndex in 1:length(allPartSets10List)){
  
  
  setIndexes = sample(1:10, length(allPartSets10List[[partIndex]]))
  obsPartSets = list()
  for(index in 1:length(setIndexes)){
    obsPartSets[[setIndexes[index]]] = allPartSets10List[[partIndex]][[index]]
  }
  
  ex.10obs.log.lik[partIndex] = calcLogTypeLik(eltsAllPartSetList = mkr27EltsAllPartSetList, 
                                               eltsAllPartSetPriorList = mkr27EltsAllPartSetPriorList, 
                                               sample = slv.10obs.df, 
                                               subtypeList = obsPartSets, 
                                               mkrList = mkrList, 
                                               alphaC = rep(1, 5), 
                                               betaC = rep(1, 5))
  if(partIndex %%1000 ==0){
    message(partIndex)
  }
}

enumerate.partitions(10)

elts10AllPartSetMDPPrior = unlist(lapply(allPartSets10List, 
                                         calcMDPColPrior, 
                                         alpha = 1, 
                                         setCountMax = 10))

save(ex.10obs.log.lik,
     file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/ex.10obs.log.lik.RData")
write.csv(slv.10obs.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.10obs.dat.csv",
          row.names = F, quote = F)

enumerate.partitions(5)

ex.10obs.mdp = 
  scan(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.10obs.mdp.txt",
       what = double(), sep = "\n")