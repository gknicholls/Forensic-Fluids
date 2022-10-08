
ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_19_J2_slv2_bld20_seed123_v2.log",
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



ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_19_J2_slv5_bld50_seed123_v2.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
ex.missing_J2_2022_08_19.partitions = 
  sapply(ex.missing_J2_2022_08_19.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_19.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_19.partitions)
rownames(ex.missing_J2_2022_08_19.partitions) = NULL

ex.missing_J2_2022_08_19.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_19.partitions[,1], pattern = "55")
ex.missing_J2_2022_08_19.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_19.partitions[,2], pattern = "55")
length(ex.missing_J2_2022_08_19.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_19.df)
length(ex.missing_J2_2022_08_19.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_19.df)





ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_08_31/ex.missing_slv5_bld50.log",
             header = T, as.is =T, sep = "\t")
ex.missing_J2_2022_08_19.df = ex.missing_J2_2022_08_19.df[c(1:10000)*10+1,]

nrow(ex.missing_J2_2022_08_19.df)
ex.missing_J2_2022_08_19.partitions = 
  sapply(ex.missing_J2_2022_08_19.df$typeList, strsplit, split=" ")
ex.missing_J2_2022_08_19.partitions = 
  do.call(rbind, ex.missing_J2_2022_08_19.partitions)
rownames(ex.missing_J2_2022_08_19.partitions) = NULL

ex.missing_J2_2022_08_19.partitions.inType1 = 
  grep(ex.missing_J2_2022_08_19.partitions[,1], pattern = "55")
ex.missing_J2_2022_08_19.partitions.inType2 = 
  grep(ex.missing_J2_2022_08_19.partitions[,2], pattern = "55")
length(ex.missing_J2_2022_08_19.partitions.inType1)/
  nrow(ex.missing_J2_2022_08_19.df)
length(ex.missing_J2_2022_08_19.partitions.inType2)/
  nrow(ex.missing_J2_2022_08_19.df)



ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_slv5_bld50_2022_09_01.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df)

post.probs = exp(ex.missing_J2_2022_08_19.df$log.posterior[match(unique(ex.missing_J2_2022_08_19.df$typeList), 
                                                ex.missing_J2_2022_08_19.df$typeList)])
post.probs = post.probs/sum(post.probs)
plot(sort(post.probs),
sort(as.numeric(table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df))))
abline(0, 1, col="red")


ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_slv5_bld50_2022_09_01_v2.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)


post.probs = exp(ex.missing_J2_2022_08_19.df$log.posterior[match(unique(ex.missing_J2_2022_08_19.df$typeList), 
                                                                 ex.missing_J2_2022_08_19.df$typeList)])
post.probs = post.probs/sum(post.probs)
sort(table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df))
sort(post.probs )
plot(sort(post.probs/sum(post.probs)),
     sort(as.numeric(table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df))))
abline(0, 1, col="red")



ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_J3_slv3_bld3_2022_09_01.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)


ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_J3_slv3_bld3_2022_09_01_v2.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)

post.probs = exp(ex.missing_J2_2022_08_19.df$log.posterior[match(unique(ex.missing_J2_2022_08_19.df$typeList), 
                                                                 ex.missing_J2_2022_08_19.df$typeList)])
post.probs = post.probs/sum(post.probs)
plot(log(sort(post.probs/sum(post.probs))),
     log(sort(as.numeric(table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df)))))
abline(0, 1, col="red")


ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_J4_slv4_bld4_2022_09_01_v1.log",
             header = T, as.is =T, sep = "\t")
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)

post.probs = exp(ex.missing_J2_2022_08_19.df$log.posterior[match(unique(ex.missing_J2_2022_08_19.df$typeList), 
                                                                 ex.missing_J2_2022_08_19.df$typeList)])
post.probs = post.probs/sum(post.probs)
plot(log(sort(post.probs/sum(post.probs))),
     log(sort(as.numeric(table(ex.missing_J2_2022_08_19.df$typeList)/nrow(ex.missing_J2_2022_08_19.df)))))
abline(0, 1, col="red")



ex.missing_J2_2022_08_19.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_01/ex.missing_J5_slv5_bld50_2022_09_01_v1.log",
             header = T, as.is =T, sep = "\t")
ex.missing_J2_2022_08_19.df = ex.missing_J2_2022_08_19.df[c(1:1000)*100+1,]
nrow(ex.missing_J2_2022_08_19.df)
table(ex.missing_J2_2022_08_19.df$unknownType.0)/nrow(ex.missing_J2_2022_08_19.df)







