ex.missing_prior_alp2_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_alpha2_2022_08_18_v2.log",
             header = T, as.is =T, sep = "\t")
partitions.alp2 = sapply(ex.missing_prior_alp2_2022_08_18.df$typeList, strsplit, split=" ")
partitions.alp2 = do.call(rbind, partitions.alp2)
rownames(partitions.alp2) = NULL
inType1.alp2 = grep(partitions.alp2[,1], pattern = "55")
inType2.alp2 = grep(partitions.alp2[,2], pattern = "55")
length(inType1.alp2)/nrow(ex.missing_prior_alp2_2022_08_18.df)
length(inType2.alp2)/nrow(ex.missing_prior_alp2_2022_08_18.df)

ex.missing_prior_2022_08_17.df$log.posterior[1:10]
ex.missing_prior_2022_08_17.df$multiTypeMDP[1:10]




ex.missing_J5_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_v3_seed123_v2.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J5_2022_08_18.df)
ex.missing_J5_2022_08_18.partitions = 
  sapply(ex.missing_J5_2022_08_18.df$typeList, strsplit, split=" ")
ex.missing_J5_2022_08_18.partitions = 
  do.call(rbind, ex.missing_J5_2022_08_18.partitions)
rownames(ex.missing_J5_2022_08_18.partitions) = NULL

ex.missing_J5_2022_08_18.partitions.inType1 = 
  grep(ex.missing_J5_2022_08_18.partitions[,1], pattern = "146")
ex.missing_J5_2022_08_18.partitions.inType2 = 
  grep(ex.missing_J5_2022_08_18.partitions[,2], pattern = "146")
length(ex.missing_J5_2022_08_18.partitions.inType1)/
  nrow(ex.missing_J5_2022_08_18.df)
length(ex.missing_J5_2022_08_18.partitions.inType2)/
  nrow(ex.missing_J5_2022_08_18.df)

ex.missing_J5_2022_08_18.class = 
  as.numeric(unname(sapply(ex.missing_J5_2022_08_18.partitions[,1], function(z){length(grep(z, pattern = "146")) > 0})))
ESS(ex.missing_J5_2022_08_18.class)

ex.missing_J2_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv50_bld5_seed123.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_18.df)
ex.missing_J2_2022_08_18.partitions = 
  sapply(ex.missing_J2_2022_08_18.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_18.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_18.partitions)
rownames(ex.missing_J2_2022_08_18.partitions) = NULL

ex.missing_J2_2022_08_18.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_18.partitions[,1], pattern = "55")
ex.missing_J2_2022_08_18.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_18.partitions[,2], pattern = "55")
length(ex.missing_J2_2022_08_18.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_18.df)
length(ex.missing_J2_2022_08_18.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_18.df)



ex.missing_J2_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv5_bld50_seed123.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_18.df)
ex.missing_J2_2022_08_18.partitions = 
  sapply(ex.missing_J2_2022_08_18.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_18.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_18.partitions)
rownames(ex.missing_J2_2022_08_18.partitions) = NULL

ex.missing_J2_2022_08_18.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_18.partitions[,1], pattern = "55")
ex.missing_J2_2022_08_18.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_18.partitions[,2], pattern = "55")
length(ex.missing_J2_2022_08_18.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_18.df)
length(ex.missing_J2_2022_08_18.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_18.df)



ex.missing_J2_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv2_bld20_seed123.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_18.df)
ex.missing_J2_2022_08_18.partitions = 
  sapply(ex.missing_J2_2022_08_18.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_18.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_18.partitions)
rownames(ex.missing_J2_2022_08_18.partitions) = NULL

ex.missing_J2_2022_08_18.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_18.partitions[,1], pattern = "22")
ex.missing_J2_2022_08_18.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_18.partitions[,2], pattern = "22")
length(ex.missing_J2_2022_08_18.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_18.df)
length(ex.missing_J2_2022_08_18.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_18.df)



ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_19_J2_slv2_bld20_seed123.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
ex.missing_J2_2022_08_19.partitions = 
  sapply(ex.missing_J2_2022_08_19.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_19.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_19.partitions)
rownames(ex.missing_J2_2022_08_19.partitions) = NULL

ex.missing_J2_2022_08_19.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_19.partitions[,1], pattern = "22")
ex.missing_J2_2022_08_19.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_19.partitions[,2], pattern = "22")
length(ex.missing_J2_2022_08_19.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_19.df)
length(ex.missing_J2_2022_08_19.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_19.df)

String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv2_bld20_seed123.log";

ex.missing_J5_2022_08_18.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_J5_2022_08_18.log",
             header = T, as.is =T, sep = "\t")
ex.missing_J5_2022_08_18.partitions = 
  sapply(ex.missing_J5_2022_08_18.df$typeList, strsplit, split=" ")
ex.missing_J5_2022_08_18.partitions = 
  do.call(rbind, ex.missing_J5_2022_08_18.partitions)
rownames(ex.missing_J5_2022_08_18.partitions) = NULL

ex.missing_J5_2022_08_18.partitions.inType1 = 
  grep(ex.missing_J5_2022_08_18.partitions[,1], pattern = "86")
ex.missing_J5_2022_08_18.partitions.inType2 = 
  grep(ex.missing_J5_2022_08_18.partitions[,2], pattern = "86")
length(ex.missing_J5_2022_08_18.partitions.inType1)/
  nrow(ex.missing_J5_2022_08_18.df)
length(ex.missing_J5_2022_08_18.partitions.inType2)/
  nrow(ex.missing_J5_2022_08_18.df)
