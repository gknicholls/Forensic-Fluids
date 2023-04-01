dat2019.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single source samples_2019.csv",
         header = T, as.is = T)
data2019Bin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single_2019_binary.csv",
                          header = T, as.is = T)

setdiff(dat2019.df$Sample, data2019Bin.df$Sample)
setdiff(data2019Bin.df$Sample, dat2019.df$Sample) 

sum(abs(data2019Bin.df[data2019Bin.df$Type=="Vaginal Secretion",allMkrs] - cvf.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Menstrual Blood",allMkrs] - mtb.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Saliva",allMkrs] - slv.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Blood",allMkrs] - bld.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Semen",allMkrs] - smn.df))

mkrProp  = cbind(rowSums(data2019Bin.df[,cvfMkrs])/length(cvfMkrs),
rowSums(data2019Bin.df[,mtbMkrs])/length(mtbMkrs),
rowSums(data2019Bin.df[,slvMkrs])/length(slvMkrs),
rowSums(data2019Bin.df[,bldMkrs])/length(bldMkrs),
rowSums(data2019Bin.df[,smnMkrs])/length(smnMkrs))


mkrCount  = cbind(rowSums(data2019Bin.df[,cvfMkrs]),
                 rowSums(data2019Bin.df[,mtbMkrs]),
                 rowSums(data2019Bin.df[,slvMkrs]),
                 rowSums(data2019Bin.df[,bldMkrs]),
                 rowSums(data2019Bin.df[,smnMkrs]))
apply(mkrProp, 1, which.max)

names(table(data2019Bin.df$Type))

dat2019TypeLabel = c("Vaginal Secretion", "Menstrual Blood", "Saliva", "Blood", "Semen")
table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrProp, 1, which.max)])
table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrCount, 1, which.max)])

test2022.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/test/2022_09_22/testSamplesBin_2022_09_22.csv",
                       header = T, as.is = T)
testMkrProp  = cbind(rowSums(test2022.df[,cvfMkrs])/length(cvfMkrs),
                 rowSums(test2022.df[,mtbMkrs])/length(mtbMkrs),
                 rowSums(test2022.df[,slvMkrs])/length(slvMkrs),
                 rowSums(test2022.df[,bldMkrs])/length(bldMkrs),
                 rowSums(test2022.df[,smnMkrs])/length(smnMkrs))

table(exptdType, dat2019TypeLabel[apply(testMkrProp, 1, which.max)])
