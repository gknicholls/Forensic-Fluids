cvf.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_cvf.csv", header = T, as.is = T)
sample(1:59, 30)
cvfPtTrainIndex <- c(32, 22, 59, 19, 35, 23, 2, 3, 11, 56, 
                     43, 13, 57, 58, 25, 36, 37, 12, 34, 48, 
                     54, 14, 28, 24, 9, 51, 50, 30, 26, 42)
cvfPtTestIndex <- setdiff(c(1:nrow(cvf.df)), cvfPtTrainIndex)
cvfPtTrain.df <- cvf.df[cvfPtTrainIndex,]
cvfPtTest.df <- cvf.df[cvfPtTestIndex,]

mtb.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_mtb.csv", header = T, as.is = T)
sample(1:nrow(mtb.df ), 16)
mtbPtTrainIndex <- c(7, 12, 6, 30, 16, 10, 28, 20, 1, 19, 23, 31, 22, 25, 17, 27)
mtbPtTestIndex <- setdiff(c(1:nrow(mtb.df)), mtbPtTrainIndex)
mtbPtTrain.df <- mtb.df[mtbPtTrainIndex,]
mtbPtTest.df <- mtb.df[mtbPtTestIndex,]



slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_slv.csv", header = T, as.is = T)
sample(1:nrow(slv.df), 40)
slvPtTrainIndex <- c(34, 77, 2, 78, 69, 72, 1, 17, 49, 22, 61, 
                     12, 55, 47, 79, 48, 75, 51, 13, 70, 67, 
                     57, 38, 21, 53, 28, 80, 4, 26, 35, 43, 
                     29, 27, 68, 52, 15, 18, 19, 44, 33)
slvPtTestIndex <- setdiff(c(1:nrow(slv.df)), slvPtTrainIndex)
slvPtTrain.df <- slv.df[slvPtTrainIndex,]
slvPtTest.df <- slv.df[slvPtTestIndex,]


bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_bld.csv", header = T, as.is = T)
sample(1:nrow(bld.df), 33)
bldPtTrainIndex <- c(18, 52, 38, 3, 7, 22, 54, 5, 50, 44, 11, 
                     55, 20, 23, 42, 62, 8, 27, 31, 56, 35, 10, 
                     32, 24, 19, 16, 60, 64, 1, 4, 2, 59, 37)
bldPtTestIndex <- setdiff(c(1:nrow(bld.df)), bldPtTrainIndex)
bldPtTrain.df <- bld.df[bldPtTrainIndex,]
bldPtTest.df <- bld.df[bldPtTestIndex,]


smn.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_smn.csv", header = T, as.is = T)
sample(1:nrow(smn.df), 43)
smnPtTrainIndex <- c(79, 41, 70, 66, 40, 85, 65, 56, 64, 33, 8, 
                     24, 54, 21, 1, 42, 81, 9, 78, 38, 47, 5, 22, 
                     17, 13, 23, 46, 80, 55, 49, 35, 50, 62, 83, 
                     19, 7, 84, 60, 28, 69, 73, 43, 25)
smnPtTestIndex <- setdiff(c(1:nrow(smn.df)), smnPtTrainIndex)
smnPtTrain.df <- smn.df[smnPtTrainIndex,]
smnPtTest.df <- smn.df[smnPtTestIndex,]

write.csv(cvfPtTrain.df, 
         file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_train_cvf.csv", 
         row.names = F, quote = F)
write.csv(cvfPtTest.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_test_cvf.csv", 
          row.names = F, quote = F)


write.csv(mtbPtTrain.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_train_mtb.csv", 
          row.names = F, quote = F)
write.csv(mtbPtTest.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_test_mtb.csv", 
          row.names = F, quote = F)

write.csv(slvPtTrain.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_train_slv.csv", 
          row.names = F, quote = F)
write.csv(slvPtTest.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_test_slv.csv", 
          row.names = F, quote = F)


write.csv(bldPtTrain.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_train_bld.csv", 
          row.names = F, quote = F)
write.csv(bldPtTest.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_test_bld.csv", 
          row.names = F, quote = F)

write.csv(smnPtTrain.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_train_smn.csv", 
          row.names = F, quote = F)
write.csv(smnPtTest.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/singleBin_pt_test_smn.csv", 
          row.names = F, quote = F)


unknownPt50.df <- rbind(cvfPtTest.df, mtbPtTest.df, slvPtTest.df, bldPtTest.df, smnPtTest.df)
write.csv(unknownPt50.df, 
          file = "/Users/chwu/Documents/research/bfc/data/phaseTrans/unknownPt50.csv", 
          row.names = F, quote = F)