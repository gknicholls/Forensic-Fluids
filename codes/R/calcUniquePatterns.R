singleBin.df = read.csv(file = "/Users/chwu/Documents/research/bfc/data/forensic_data/mRNA_single_2019_binary.csv",
                        header = T)
allMkrs = names(singleBin.df)[-c(1, 2)]
allPattern = apply(singleBin.df[,allMkrs], 1, paste, collapse = "")

patternByTypeList = tapply(allPattern, singleBin.df$Type, c)
uniquePatternByTypeList = tapply(allPattern, singleBin.df$Type, unique)

lapply(patternByTypeList, length)
lapply(uniquePatternByTypeList, length)
sum(unlist(lapply(uniquePatternByTypeList, length)))


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


patternFreq = sort(table(unlist(uniquePatternByTypeList)), decreasing = T)


match(names(patternFreq[1:3]), uniquePatternByTypeList[[5]])



genLOOCVData = function(patternPos = NULL, data.df = NULL, dir, type, prefix = NULL){
  for(pos in patternPos){
    train.df = data.df[-pos,]
    test = data.df[pos,]
    names(test) = names(data.df)
    write.csv(train.df, 
              file = paste(dir, "/", prefix, "_", type, "_train_", pos, ".csv", sep = ""),
              quote = F, row.names = F)
    write.csv(test, 
              file = paste(dir, "/", prefix, "_", type, "_unknown_", pos, ".csv", sep = ""),
              quote = F, row.names = F)
  }
  
}

typeLabel = c("bld", "mtb", "slv", "smn", "cvf")
names(typeLabel) = names(uniquePatternByTypeList)
for(typeIndex in 1:length(uniquePatternByTypeList)){
  typeBin.df = singleBin.df[which(singleBin.df$Type ==
                                names(uniquePatternByTypeList)[[typeIndex]]), allMkrs]
  uniquePatternPos = match(uniquePatternByTypeList[[typeIndex]], 
                           patternByTypeList[[typeIndex]])
  outputDir = paste("/Users/chwu/Documents/research/bfc/data/loocvTrain/", typeLabel[typeIndex], "/", sep="")
  genLOOCVData(patternPos = uniquePatternPos, data.df = typeBin.df[,allMkrs], 
               dir = outputDir, type = typeLabel[typeIndex], prefix = "loocvTrain")
  for(typeIndex2 in  1:length(uniquePatternByTypeList)){
    write.csv(typeBin.df[,allMkrs], 
              file = paste(paste("/Users/chwu/Documents/research/bfc/data/loocvTrain/", typeLabel[typeIndex2], "/", sep=""), 
                           "/", "singleBin_", typeLabel[typeIndex], ".csv", sep = ""),
              quote = F, row.names = F)
  }
  
  
}


typeLabel = c("bld", "mtb", "slv", "smn", "cvf")
names(typeLabel) = names(uniquePatternByTypeList)
uniquePatternPosList = list()
for(typeIndex in 1:length(uniquePatternByTypeList)){
  typeBin.df = singleBin.df[which(singleBin.df$Type ==
                                    names(uniquePatternByTypeList)[[typeIndex]]), allMkrs]
  uniquePatternPosList[[typeLabel[typeIndex]]] = match(uniquePatternByTypeList[[typeIndex]], 
                           patternByTypeList[[typeIndex]])
  
  
  
}

save(uniquePatternPosList,
     file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/uniquePatternPosList.RData")


