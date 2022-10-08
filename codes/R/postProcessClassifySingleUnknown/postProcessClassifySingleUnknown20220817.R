ex.missing_prior_2022_08_17.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_2022_08_17.log",
         header = T, as.is =T, sep = "\t")
partitions = sapply(ex.missing_prior_2022_08_17.df$typeList, strsplit, split=" ")
partitions = do.call(rbind, partitions)
rownames(partitions) = NULL
inType1 = grep(partitions[,1], pattern = "8")
inType2 = grep(partitions[,2], pattern = "8")
ex.missing_prior_2022_08_17.df$log.posterior[1:10]
ex.missing_prior_2022_08_17.df$multiTypeMDP[1:10]

15*52
5*203
length(unique(ex.missing_prior_2022_08_17.df$typeList[inType1]))
length(unique(ex.missing_prior_2022_08_17.df$typeList[inType2]))


ex.missing_prior_alp2_2022_08_17.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_alpha2_2022_08_17.log",
             header = T, as.is =T, sep = "\t")
partitions.alp2 = sapply(ex.missing_prior_alp2_2022_08_17.df$typeList, strsplit, split=" ")
partitions.alp2 = do.call(rbind, partitions.alp2)
rownames(partitions.alp2) = NULL
inType1.alp2 = grep(partitions.alp2[,1], pattern = "8")
inType2.alp2 = grep(partitions.alp2[,2], pattern = "8")
length(inType1.alp2)/nrow(ex.missing_prior_alp2_2022_08_17.df)
length(inType2.alp2)/nrow(ex.missing_prior_alp2_2022_08_17.df)

ex.missing_prior_2022_08_17.df$log.posterior[1:10]
ex.missing_prior_2022_08_17.df$multiTypeMDP[1:10]


length(unique(ex.missing_prior_2022_08_17.df$typeList[inType1]))
length(unique(ex.missing_prior_2022_08_17.df$typeList[inType2]))


library(LaplacesDemon)
ex.missing_v2_2022_08_17.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_v2_2022_08_18.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_v2_2022_08_17.df)

ex.missing_v2_2022_08_17.partitions = sapply(ex.missing_v2_2022_08_17.df$typeList, strsplit, split=" ")
ex.missing_v2_2022_08_17.partitions = do.call(rbind, ex.missing_v2_2022_08_17.partitions)            
rownames(ex.missing_v2_2022_08_17.partitions) = NULL
ex.missing_v2_2022_08_17inType1 = grep(ex.missing_v2_2022_08_17.partitions[,1], pattern = "146")
ex.missing_v2_2022_08_17inType2 = grep(ex.missing_v2_2022_08_17.partitions[,2], pattern = "146")
length(ex.missing_v2_2022_08_17inType1)/nrow(ex.missing_v2_2022_08_17.df)
length(ex.missing_v2_2022_08_17inType2)/nrow(ex.missing_v2_2022_08_17.df)

ex.missing_v2_2022_08_17.class = rep(0, nrow(ex.missing_v2_2022_08_17.df))
ex.missing_v2_2022_08_17.class[ex.missing_v2_2022_08_17inType2] = 1
ex.missing_v2_2022_08_17.ess = ESS(ex.missing_v2_2022_08_17.class)
ex.missing_v2_2022_08_17.ess

ex.missing_v2_2022_08_17inType1.prob = length(ex.missing_v2_2022_08_17inType1)/nrow(ex.missing_v2_2022_08_17.df)
ex.missing_v2_2022_08_17inType1.prob
ex.missing_v2_2022_08_17inType1.prob.se = 
  sqrt(ex.missing_v2_2022_08_17inType1.prob * (1 - ex.missing_v2_2022_08_17inType1.prob )/ 
       ex.missing_v2_2022_08_17.ess)
ex.missing_v2_2022_08_17inType1.prob + c(-1,1)*1.96*ex.missing_v2_2022_08_17inType1.prob.se
ex.missing_v2_2022_08_17inType1.prob + c(-1,1)*2*ex.missing_v2_2022_08_17inType1.prob.se
