singleTestThreshold.df = read.csv(file = '/Users/chwu/Documents/research/bfc/data/test/2022_09_29/single source samples_29Sept22_threshold.csv',
                        header = T, as.is = T)
singleTest.df = read.csv(file = '/Users/chwu/Documents/research/bfc/data/test/2022_09_29/single source samples_29Sept22.csv',
                            header = T, as.is = T)

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
for(markerIndex in 1:length(allMkrs)){
  currMarkerThreshold <-singleTestThreshold.df$threshold[singleTestThreshold.df$marker == allMkrs[markerIndex]]
  belowThreshold <- singleTest.df[singleBinTest.df[, allMkrs[markerIndex]] < currMarkerThreshold, allMkrs[markerIndex]]
  if(length(belowThreshold[belowThreshold > 0]) > 0){
    message(paste(c(allMkrs[markerIndex], currMarkerThreshold, belowThreshold[belowThreshold > 0]), collapse=" "))
  }
  
}



singleBinTest.mat <- matrix(1, nrow = nrow(singleTest.df), ncol = length(allMkrs))
colnames(singleBinTest.mat) <- allMkrs
for(mkr in allMkrs){
  currMarkerThreshold <- singleTestThreshold.df$threshold[singleTestThreshold.df$marker==mkr]
  singleBinTest.mat[singleTest.df[,mkr] < currMarkerThreshold, mkr] <- 0
}  
image(t(singleBinTest.mat))

write.csv(singleBinTest.mat,
          file = "/Users/chwu/Documents/research/bfc/data/test/2022_09_29/testSamplesBin_2022_09_22.csv",
          row.names = F, quote = F)

for(rowIndex in 1:nrow(singleBinTest.mat)){
  write.csv(t(singleBinTest.mat[rowIndex,]),
            file = paste("/Users/chwu/Documents/research/bfc/data/test/2022_09_29/testSamplesBin_2022_09_22_unknown_", rowIndex, ".csv", sep = ""),
            row.names = F, quote = F)
}
