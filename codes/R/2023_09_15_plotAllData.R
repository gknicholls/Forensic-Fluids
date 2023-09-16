source("/Users/chwu/Documents/research/bfc/github/forensic_bf/src/getPosteriorPredictiveBF.R")
source("/Users/chwu/Documents/research/bfc/github/forensic_bf/src/bfcFunctions.R")

bdpJ5Log.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_24/testSamplesBin_cut_2022_09_22_main.log",
           header = T, as.is =T, sep = "\t")
bdpJ5Log.df = bdpJ5Log.df[-c(1:ceiling(nrow(bdpJ5Log.df)/10)),]

bdpJ5PostMode = which.max(bdpJ5Log.df$log.posterior)

subtypeClust = unlist(strsplit(bdpJ5Log.df$typeList[bdpJ5PostMode], split = " "))
subtypeClust = gsub(subtypeClust, pattern = "[[", replace = "[", fixed = T)
subtypeClust = gsub(subtypeClust, pattern = "]]", replace = "]", fixed = T)
subtypeClustList = strsplit(subtypeClust, split = "],[", fixed = T)
clustAssignList = lapply(subtypeClustList, function(clustStr = NULL){
  clustStr = gsub(clustStr, pattern = "[", replace = "", fixed = T)
  clustStr = gsub(clustStr, pattern = "]", replace = "", fixed = T)
  subtypeList = list()
  
  for(subtypeIndex in 1:length(clustStr)){
    subtypeList[[subtypeIndex]] = as.numeric(unlist(strsplit(clustStr[subtypeIndex], split = ",")))
    
  }
  
  clustAssign = c()
  for(subtypeIndex in 1:length(subtypeList)){
    clustAssign[subtypeList[[subtypeIndex]] + 1] = subtypeIndex
  }
  
  return(clustAssign)
  
})


cvf.df = read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_09_14/singleBin_cvf.csv",
                  header = T, as.is = T)
mtb.df = read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_09_14/singleBin_mtb.csv",
                  header = T, as.is = T)
slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_09_14/singleBin_slv.csv",
                  header = T, as.is = T)
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_09_14/singleBin_bld.csv",
                  header = T, as.is = T)
smn.df = read.csv(file = "/Users/chwu/Documents/research/bfc/analysis/2023_09_14/singleBin_smn.csv",
                  header = T, as.is = T)


cvf.mat = data.matrix(cvf.df)
mtb.mat = data.matrix(mtb.df)
slv.mat = data.matrix(slv.df)
bld.mat = data.matrix(bld.df)
smn.mat = data.matrix(smn.df)


lapply(clustAssignList, unique)


orderByCluster1 = order(clustAssignList[[1]])
orderByCluster2 = order(clustAssignList[[2]])
orderByCluster3 = order(clustAssignList[[3]])
orderByCluster4 = order(clustAssignList[[4]])
orderByCluster5 = order(clustAssignList[[5]])

cvf.mat1 = cvf.mat*clustAssignList[[1]]

pdf(file = "/Users/chwu/Documents/research/bfc/paper/plot/markerProfile5TypesPostMode.pdf",
    height = 7.5, width = 5.5)
par(xpd = F, mar = c(4.25, 3, 3, 1) + 0.2, mfrow = c(1,1))
image(cbind(t((smn.mat*clustAssignList[[5]])[orderByCluster5,] ),
            t((bld.mat*clustAssignList[[4]])[orderByCluster4,]),
            t((slv.mat*clustAssignList[[3]])[orderByCluster3,]),
            t((mtb.mat*clustAssignList[[2]])[orderByCluster2,]),
            t((cvf.mat*clustAssignList[[1]])[orderByCluster1,])),
      col =c("white",  rev(c("#6D2727", "#093E42", "#EC972D", "#836D70",  "#34B795", "#EB4D28"))), 
      axes = FALSE,
      main = "")
box(which = "plot",lty = "solid")
grid(nx = 27 , ny = nrow(single.df ) , lty = "solid", lwd = 0.05)
abline (v =4.5 /26); 
abline (v =11.5 / 26) ; 
abline (v =16.5 / 26) ; 
abline (v =21.5 /26)
abline (h = 85.5/320, lwd = 0.75)
abline (h = 150.5/320, lwd = 0.75)
abline (h = 230.5/320, lwd = 0.75)
abline (h = 261.5/320, lwd = 0.75)
par(xpd = NA)

text(label = "Fluid Type", x = -0.13, y = (150.5 + 60/2)/320, cex = 0.9, srt = 90, pos = 3)
text(label = "Semen", x = -0.05, y = 85.5/2/320, srt = 90, cex = 0.75, pos = 3)
text(label = "Blood", x = -0.05, y = (85.5 + 65/2)/320, srt = 90, cex = 0.75, pos = 3)
text(label = "Saliva", x = -0.05, y = (150.5 + 80/2)/320, srt = 90, cex = 0.75, pos = 3)
text(label = "Menstrual\nBlood", x = -0.05, y = (230.5 + 23/2)/320, srt = 90, cex = 0.75, pos = 3)
text(label = "Cervical Fluid", x = -0.05, y = (261.5 + 55/2)/320, srt = 90, cex = 0.75, pos = 3)

text(label = "Marker Group", x = 0.5, y = 1.07, cex = 0.9)
text(label = "CVF", x = 4.5/2/26, y = 1.025, cex = 0.8)
text(label = "MTB", x = (4.5 + 7/2)/26, y = 1.025, cex = 0.8)
text(label = "SLV", x = (11.5 + 5/2)/26, y = 1.025, cex = 0.8)
text(label = "BLD", x = (16.5 + 5/2)/26, y = 1.025, cex = 0.8)
text(label = "SMN", x = (21.5 + 5/2)/26, y = 1.025, cex = 0.8)

for(markerIndex in 1:ncol(cvf.mat)){
  text(label = colnames(cvf.mat)[markerIndex], 
       x = (markerIndex-0.25)/26, y = -0.025, srt = 90, cex = 0.6, pos = 2)
}
text(label = "mRNA Markers", x = (14-0.25)/26, y = -0.125, cex = 0.9, pos = 2)

dev.off()

