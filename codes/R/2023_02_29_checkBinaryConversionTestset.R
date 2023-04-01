folderDir = "/Users/chwu/Documents/research/bfc/analysis/2023_02_27/testRuns/"
cvf.df = read.csv(file = paste(folderDir, "singleBin_cvf.csv", sep = ""), header = T, as.is =T)
mtb.df = read.csv(file = paste(folderDir, "singleBin_mtb.csv", sep = ""), header = T, as.is =T)
slv.df = read.csv(file = paste(folderDir, "singleBin_slv.csv", sep = ""), header = T, as.is =T)
bld.df = read.csv(file = paste(folderDir, "singleBin_bld.csv", sep = ""), header = T, as.is =T)
smn.df = read.csv(file = paste(folderDir, "singleBin_smn.csv", sep = ""), header = T, as.is =T)
exptdAlphaRow = "0.6025,0.725,0.55,0.585,0.525"
exptdMaxRowClustCount = "5"
exptedTotalCount = paste(nrow(cvf.df), nrow(mtb.df), nrow(slv.df), nrow(bld.df), nrow(smn.df), sep=",")

for(sampleIndex in 1:46){
  input.df = read.table(file = paste(folderDir, "test_bayes_input_", sampleIndex, ".txt", sep = ""), header = F, as.is =T, sep = "\t")
  exptdUnknownSamplePath = paste("testSamplesBin_2022_09_22_unknown_", sampleIndex, ".csv", sep = "")
  
  
  input.df[input.df[,1]=='alphaRow', 2] == exptdAlphaRow
  input.df[input.df[,1]=='totalObsCounts', 2] == exptedTotalCount
  input.df[input.df[,1]=='maxRowClustCount', 2] == exptdMaxRowClustCount
  input.df[input.df[,1]=='unknownSamplePath', 2] == exptdUnknownSamplePath 
  unknown.df = read.csv(file = paste(folderDir, exptdUnknownSamplePath, sep = ""), header = T, as.is =T)
  
  
  mkrValues = as.logical(unknown.df[, allMkrs])
  exptdMkrValues = singleTest.df[sampleIndex, allMkrs] >= 
    singleTestThreshold.df$threshold[match(allMkrs, singleTestThreshold.df$marker)]
  if(!all(mkrValues == exptdMkrValues)){
    stop(sampleIndex)
  }
}


