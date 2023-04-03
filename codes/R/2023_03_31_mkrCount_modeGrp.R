dat2019.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single source samples_2019.csv",
         header = T, as.is = T)
data2019Bin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single_2019_binary.csv",
                          header = T, as.is = T)
cvfMkrs = c("CYP", "HBD1", "Lcris", "Lgas", "MUC4")
mtbMkrs = c("Hs202072", "LEFTY2", "MMP10", "MMP11", "MMP7", "MSX1", "SFRP4")
slvMkrs = c("HTN3", "MUC7", "PRB4", "SMR3B", "STATH")
bldMkrs = c("ALAS2", "GlycoA", "HBB", "PF4", "SPTB")
smnMkrs = c("MSMB", "PRM1", "PRM2", "SEMG1", "TGM4")
allMkrs = c(cvfMkrs, mtbMkrs, slvMkrs, bldMkrs, smnMkrs)

setdiff(dat2019.df$Sample, data2019Bin.df$Sample)
setdiff(data2019Bin.df$Sample, dat2019.df$Sample) 

sum(abs(data2019Bin.df[data2019Bin.df$Type=="Vaginal Secretion",allMkrs] - cvf.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Menstrual Blood",allMkrs] - mtb.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Saliva",allMkrs] - slv.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Blood",allMkrs] - bld.df))
sum(abs(data2019Bin.df[data2019Bin.df$Type=="Semen",allMkrs] - smn.df))

cvf.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_cvf.csv", header = T, as.is = T)
mtb.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_mtb.csv", header = T, as.is = T)
slv.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_slv.csv", header = T, as.is = T)
bld.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_bld.csv", header = T, as.is = T)
smn.df = read.csv(file="/Users/chwu/Documents/research/bfc/paper/analysis/singleBin_smn.csv", header = T, as.is = T)



dat2019TypeLabel = c("Vaginal Secretion", "Menstrual Blood", "Saliva", "Blood", "Semen")

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
colnames(mkrCount) = dat2019TypeLabel
mkrCountMode = apply(mkrCount, 1, which.max)

mkrCountModeList = list()
for(profileIndex in 1:length(mkrCountMode)){
  modeCount = mkrCount[profileIndex,  mkrCountMode[profileIndex]]
  mkrCountModeList[[profileIndex]] = which(mkrCount[profileIndex, ] == modeCount)
}

mkrCountModeCounts = unlist(lapply(mkrCountModeList,length))
table(data2019Bin.df$Type, mkrCountModeCounts)
mkrCountModeAmb = mkrCountMode 
mkrCountModeAmb[mkrCountModeCounts > 1] = NA

countConf <- table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrCount, 1, which.max)])
countConfAmb <- table(data2019Bin.df$Type, dat2019TypeLabel[mkrCountModeAmb], useNA = "always")
countConfAmb[c(5,2,3,1,4,6),c(5,2,3,1,4,6)]

countConf2<-countConf[c("cvf", "mtb", "slv", "bld", "smn"), c("cvf", "mtb", "slv", "bld", "smn")]
countConf <- table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrCount, 1, which.max)])
table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrProp, 1, which.max)])

mkrProp  = cbind(rowSums(data2019Bin.df[,cvfMkrs])/length(cvfMkrs),
                  rowSums(data2019Bin.df[,mtbMkrs])/length(mtbMkrs),
                  rowSums(data2019Bin.df[,slvMkrs])/length(slvMkrs),
                  rowSums(data2019Bin.df[,bldMkrs])/length(bldMkrs),
                  rowSums(data2019Bin.df[,smnMkrs])/length(smnMkrs))
apply(mkrProp, 1, which.max)
table(data2019Bin.df$Type, dat2019TypeLabel[apply(mkrProp, 1, which.max)])

test2022.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/test/2022_09_22/testSamplesBin_2022_09_22.csv",
                       header = T, as.is = T)


exptdType = c(1, 1, 1, 1, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 1, 1, 1, 1, 3, 
              5, 1, 1, 5, 5, 4, 1, 1, 1, 5, 4, 3, 3, 3, 3, 3, 3, 5, 3, 3, 3, 1, 1)
testMkrProp  = cbind(rowSums(test2022.df[,cvfMkrs])/length(cvfMkrs),
                 rowSums(test2022.df[,mtbMkrs])/length(mtbMkrs),
                 rowSums(test2022.df[,slvMkrs])/length(slvMkrs),
                 rowSums(test2022.df[,bldMkrs])/length(bldMkrs),
                 rowSums(test2022.df[,smnMkrs])/length(smnMkrs))

table(exptdType, dat2019TypeLabel[apply(testMkrProp, 1, which.max)])




testMkrCount  = cbind(rowSums(test2022.df[,cvfMkrs]),
                     rowSums(test2022.df[,mtbMkrs]),
                     rowSums(test2022.df[,slvMkrs]),
                     rowSums(test2022.df[,bldMkrs]),
                     rowSums(test2022.df[,smnMkrs]))


testMkrCountTab<-table(exptdType, dat2019TypeLabel[apply(testMkrCount, 1, which.max)])
testMkrCountTab[, dat2019TypeLabel]

colnames(testMkrProp) = dat2019TypeLabel
testMkrCountMode = apply(testMkrCount, 1, which.max)

testMkrCountModeList = list()
for(profileIndex in 1:length(testMkrCountMode)){
  testModeCount = testMkrCount[profileIndex,  testMkrCountMode[profileIndex]]
  testMkrCountModeList[[profileIndex]] = which(testMkrCount[profileIndex, ] == testModeCount)
}

testMkrCountModeCounts = unlist(lapply(testMkrCountModeList,length))
table(exptdType, testMkrCountModeCounts)

table(exptdType, dat2019TypeLabel[apply(testMkrCiount, 1, which.max)])
