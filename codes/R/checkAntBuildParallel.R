log1.df = read.table(file="/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v1_unknown_2022_09_03.log",
                     as.is=T, header =T)
log1Copy.df = read.table(file="/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v1_unknown_2022_09_03_copy.log",
                     as.is=T, header =T)



log1Equal = vector(length = ncol(log1Copy.df))
for(colIndex in 1:ncol(log1Copy.df)){
  log1Equal[colIndex] = all(log1.df[1:nrow(log1Copy.df),colIndex] == log1Copy.df[,colIndex])
}
all(log1Equal)
# [1] TRUE

log2.df = read.table(file="/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v2_unknown_2022_09_03.log",
                     as.is=T, header =T)
log2Copy.df = read.table(file="/Users/chwu/Documents/research/bfc/output/2022_09_03/slv_atypical_v2_unknown_2022_09_03_copy.log",
                         as.is=T, header =T)


log2Equal = vector(length = ncol(log2Copy.df))
for(colIndex in 1:ncol(log2Copy.df)){
  log2Equal[colIndex] = all(log2.df[1:nrow(log2Copy.df), colIndex] == log2Copy.df[,colIndex])
}
all(log2Equal)
# [1] TRUE
