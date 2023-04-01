
cutMainJ5.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_27/cutSide/testSamplesBin_cut_2022_09_22_main.log",
                           header = T, as.is = T, sep = "\t")
cutMainJ10.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_03_23/testSamplesBin_cut_2022_09_22_J10_main.log",
                           header = T, as.is = T, sep = "\t")

cutMainJ15.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_03_23/testSamplesBin_cut_2022_09_22_J15_main.log",
           header = T, as.is = T, sep = "\t")
setList = strsplit(cutMainJ15.df$typeList, split = " ")
strsplit(setList[[30]], split = "],[", fixed = T)

setCountList <-lapply(setList, function(z){
  unlist(lapply(strsplit(z, split = "],[", fixed = T), length))
})

setCounts<-do.call(rbind, setCountList)




hist(setCounts[,5])

cutMainJ5.setList = strsplit(cutMainJ5.df$typeList, split = " ")
scutMainJ5.etCountList <-lapply(cutMainJ5.setList , function(z){
  unlist(lapply(strsplit(z, split = "],[", fixed = T), length))
})


cutMainJ10.setList = strsplit(cutMainJ10.df$typeList, split = " ")
scutMainJ10.etCountList <-lapply(cutMainJ10.setList , function(z){
  unlist(lapply(strsplit(z, split = "],[", fixed = T), length))
})

cutMainJ5.setCounts<-do.call(rbind, scutMainJ5.etCountList)
cutMainJ10.setCounts<-do.call(rbind, scutMainJ10.etCountList)

pdf(file = "/Users/chwu/Documents/research/bfc/analysis/2023_03_23/fluid.pdf",
    width = 10.5, height = 7.5)
label<-c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(3, 5), mar = c(4, 4, 2, 1) + 0.2)
for(i in 1:5){
  hist(cutMainJ5.setCounts[, i], xlab = "# subtypes", prob = T,
       main = paste(label[i], ", J = 5", sep = ""))
 
  
}

for(i in 1:5){
  hist(cutMainJ10.setCounts[, i], xlab = "# subtypes", prob = T,
       main = paste(label[i], ", J = 10", sep = ""))
  
}

for(i in 1:5){
  hist(setCounts[, i], xlab = "# subtypes", prob = T,
       main = paste(label[i], ", J = 15", sep = ""))
}
dev.off()

par(mfrow = c(1, 2))
for(i in 1:5){
  hist(cutMainJ10.setCounts[, i])
  hist(setCounts[, i])
  
}

