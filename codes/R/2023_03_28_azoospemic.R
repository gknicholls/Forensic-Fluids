smnSampleNames = c("Se510_12_RTP", "Se510_13_RTP", "Se510_14_RTP", "Se510_5_RTP", "Se510_7B_RTP", "Se510_9_RTP", 
                   "Se810_1_RTP", "Se810_10_RTP", "Se510_10B_RTP", "Se510_19B_RTP", "Se510_21_RTP", "Se510_25_RTP",
                   "Se510_6_RTP", "Se810_3B_RTP", "Se810_6_RTP", "Se810_8B_RTP", "Se510_2_RTP", "Se510_8_RTP", 
                   "Se810_11B_RTP", "Se810_12_RTP", "Se810_2_RTP", "SeBFD24_RTP", "CD1_RTP_MB", "CD2_RTP_MB", 
                   "CD3_RTP_MB", "CD4_RTP_MB", "CD5_RTP_MB", "CD6_RTP_MB", "CD7_RTP_MB", "CD8_RTP_MB", "AB2_RTP_MB", 
                   "1ul Se on swab", "10Se_fabric_RTP", "10Se_fabrictape_RTP", "5Se_fabric_RTP", "5Se_fabrictape_RTP", 
                   "3Se_fabric_RTP", "3Se_fabrictape_RTP", "1Se_fabric_RTP", "1Se_fabrictape_RTP", "10Se fabric tape_RTP", 
                   "5Se fabric tape_RTP", "3Se fabric tape_RTP", "5Se fabric_RTP", "3Se fabric_RTP", "5Se direct_RTP", 
                   "3Se direct_RTP", "5Se tape_RTP", "3Se tape_RTP", "SeFE1_RTP", "SeFE2_RTP", "SeFE3_RTP", "SeFE4_RTP", 
                   "SeME1_RTP", "SeME2_RTP", "SeME3_RTP", "SeME4_RTP", "6_RTP", "5ul semen on swab", "1ul semen on swab", 
                   "1ul Se on swab", "6_RTP", "5ul semen on swab", "1ul semen on swab", "unknown sample_5p", 
                   "2ul Se directly into tube ", "2ul Se directly into tube ", "2ul Se directly into tube ", 
                   "1 ul Se directly into tube ", "1 ul Se directly into tube", "1 ul Se directly into tube", 
                   "17Oct19_15Se_10_RTP", "17Oct19_2Se_11_RTP", "17Oct19_15Se_12_RTP", "17Oct19_2Se_7_RTP", 
                   "17Oct19_15Se_8_RTP", "17Oct19_2Se_9_RTP", "1ul Se directly into tube", "1ul Se directly into tube", 
                   "1ul Se directly into tube", "1ul Se directly into tube", "2ul Se directly into tube", 
                   "2ul Se directly into tube", "2ul Se directly into tube", "2ul Se directly into tube", "4_Feb training")

trainLog.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_cut_2022_09_22_main.log",
           header = T, as.is = T, se = "\t")

rowJ5ColJMax.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_28/testSamplesBin_2022_09_22_bayes_all.log",
                             header = T, as.is = T, sep = "\t")
rowJ5ColJMax.df = rowJ5ColJMax.df[-c(1:ceiling(nrow(rowJ5ColJMax.df)/10)),]

trainLog.df = trainLog.df[-c(1:ceiling(nrow(trainLog.df)/10)),]
postClustSizeMat = matrix(nrow = nrow(trainLog.df), ncol= 86)

for(postSampleIndex in 1:nrow(trainLog.df)){
  
  subtypeConfigStr = unlist(strsplit(trainLog.df$typeList[postSampleIndex], split = " "))[5]
  subtypeConfigStr = gsub(subtypeConfigStr, pattern = "[[", replace = "", fixed=T)
  subtypeConfigStr = gsub(subtypeConfigStr, pattern = "]]", replace = "", fixed=T)
  subtypes = unlist(strsplit(subtypeConfigStr, split = "],[", fixed = T))
  
  for(subtypeIndex in 1:length(subtypes)){
    subtypeElts = as.numeric(unlist(strsplit(subtypes[subtypeIndex], split = ",")))
    postClustSizeMat[postSampleIndex, subtypeElts+1] = length(subtypeElts)
  }
  
}

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_03_28/smn_subtype_size_dat2019.pdf",
    height = 15, width = 19)
par(mfrow = c(5, 6), mar = c(4, 4, 2, 1) + 0.2)
for(i in 1:29){
  hist(postClustSizeMat[,i], prob = T, nclass = 30,
       xlab = "subtype size",  main = smnSampleNames[i], 
       cex.main = 0.75)
}

par(mfrow = c(5, 6), mar = c(4, 4, 2, 1) + 0.2)
for(i in 30:58){
  hist(postClustSizeMat[,i], prob = T, nclass = 30,
       xlab = "subtype size", main = smnSampleNames[i], 
       cex.main = 0.75)
}

par(mfrow = c(5, 6), mar = c(4, 4, 2, 1) + 0.2)
for(i in 59:86){
  hist(postClustSizeMat[,i], prob = T, nclass = 30,
       xlab = "subtype size", main = smnSampleNames[i], 
       cex.main = 0.75)
}
dev.off()


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_03_28/smn_subtype_size_dat2019_v2.pdf",
    height = 10, width = 18)
par(mfrow = c(5, 9), mar = c(4, 4, 2, 1) + 0.2)
for(i in 1:43){
  hist(postClustSizeMat[,i], prob = T, nclass = 30,
       xlab = "subtype size",  main = smnSampleNames[i], 
       cex.main = 0.75)
}

par(mfrow = c(5, 9), mar = c(4, 4, 2, 1) + 0.2)
for(i in 44:86){
  hist(postClustSizeMat[,i], prob = T, nclass = 30,
       xlab = "subtype size", main = smnSampleNames[i], 
       cex.main = 0.75)
}

dev.off()

apply(postClustSizeMat, 2, 
      function(z){
        length(which(z==1)) 
      })[8]
871/4500

apply(postClustSizeMat, 2, 
      function(z){
        length(which(z==1)) 
        })[76]

smnSampleNames[76]

rowJ5ColJMax.AV2c_RTP.subtypeList = list()
for(postSampleIndex in 1:nrow(rowJ5ColJMax.df)){
  
  rowJ5ColJMax.postClustSizeMat = matrix(nrow = nrow(rowJ5ColJMax.df), ncol= 86)
  rowJ5ColJMax.subtypeConfigStr = unlist(strsplit(rowJ5ColJMax.df$typeList[postSampleIndex], split = " "))[5]
  rowJ5ColJMax.subtypeConfigStr = gsub(rowJ5ColJMax.subtypeConfigStr, pattern = "[[", replace = "", fixed=T)
  rowJ5ColJMax.subtypeConfigStr = gsub(rowJ5ColJMax.subtypeConfigStr, pattern = "]]", replace = "", fixed=T)
  rowJ5ColJMax.subtypes = unlist(strsplit(rowJ5ColJMax.subtypeConfigStr, split = "],[", fixed = T))
  
  for(subtypeIndex in 1:length(rowJ5ColJMax.subtypes)){
    subtypeElts = as.numeric(unlist(strsplit(rowJ5ColJMax.subtypes[subtypeIndex], split = ",")))
    if(length(which(subtypeElts==347)) == 1){
      rowJ5ColJMax.AV2c_RTP.subtypeList[[postSampleIndex]] = subtypeElts
    }
    
  }
  
}

table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, function(z){any(z==7) })))
table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, length))>0)
3771/4177

table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, function(z){any(z==353) })))
table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, length))>0)
3150/4177


rowJ5ColJMax.AV2c_RTP.subtypeList = list()
for(postSampleIndex in 1:nrow(rowJ5ColJMax.df)){
  
  rowJ5ColJMax.postClustSizeMat = matrix(nrow = nrow(rowJ5ColJMax.df), ncol= 86)
  rowJ5ColJMax.subtypeConfigStr = unlist(strsplit(rowJ5ColJMax.df$typeList[postSampleIndex], split = " "))[5]
  rowJ5ColJMax.subtypeConfigStr = gsub(rowJ5ColJMax.subtypeConfigStr, pattern = "[[", replace = "", fixed=T)
  rowJ5ColJMax.subtypeConfigStr = gsub(rowJ5ColJMax.subtypeConfigStr, pattern = "]]", replace = "", fixed=T)
  rowJ5ColJMax.subtypes = unlist(strsplit(rowJ5ColJMax.subtypeConfigStr, split = "],[", fixed = T))
  
  for(subtypeIndex in 1:length(rowJ5ColJMax.subtypes)){
    subtypeElts = as.numeric(unlist(strsplit(rowJ5ColJMax.subtypes[subtypeIndex], split = ",")))
    if(length(which(subtypeElts==353)) == 1){
      rowJ5ColJMax.AV2c_RTP.subtypeList[[postSampleIndex]] = subtypeElts
    }
    
  }
  
}

table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, function(z){any(z==7) })))
table(unlist(lapply(rowJ5ColJMax.AV2c_RTP.subtypeList, length))>0)
