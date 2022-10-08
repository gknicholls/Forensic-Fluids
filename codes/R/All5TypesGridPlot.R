source("/Users/chwu/Documents/research/bfc/github/forensic_bf/src/getPosteriorPredictiveBF.R")
source("/Users/chwu/Documents/research/bfc/github/forensic_bf/src/bfcFunctions.R")

singleTypeFilePath = "/Users/chwu/Downloads/forensic_data/mRNA_single_2019_binary.csv"
single.df = read.csv(singleTypeFilePath, header = TRUE) # whole single sample data
single.df = single.df[,-1] # single sample data, delete the index column
sum(single.df$Sample == 1) # number observations of CVF
sum(single.df$Sample == 2) # MB
sum(single.df$Sample == 3) # saliva
sum(single.df$Sample == 4) # blood
sum(single.df$Sample == 5) # semen

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

cvf.df = single.df[single.df$Type=="Vaginal Secretion", allMkrs]
mtb.df = single.df[single.df$Type=="Menstrual Blood", allMkrs]
slv.df = single.df[single.df$Type=="Saliva", allMkrs]
bld.df = single.df[single.df$Type=="Blood", allMkrs]
smn.df = single.df[single.df$Type=="Semen", allMkrs]


singleBinCVF.mat = as.matrix(cvf.df)
singleBinCVF.mat = singleBinCVF.mat[rowSums(singleBinCVF.mat) > 0,]

singleBinMTB.mat = as.matrix(mtb.df)
singleBinMTB.mat = singleBinMTB.mat[rowSums(singleBinMTB.mat) > 0,]

singleBinSLV.mat = as.matrix(slv.df)
singleBinSLV.mat = singleBinSLV.mat[rowSums(singleBinSLV.mat) > 0,]

singleBinBLD.mat = as.matrix(bld.df)
singleBinBLD.mat = singleBinBLD.mat[rowSums(singleBinBLD.mat) > 0,]

singleBinSMN.mat = as.matrix(smn.df)
singleBinSMN.mat = singleBinSMN.mat[rowSums(singleBinSMN.mat) > 0,]

set.seed(123)
pdf(file = '/Users/chwu/Documents/research/bfc/plots/2022_09_25/markProfileCVF.pdf',
    height = 10.5, width = 4)

par(mar = c(0.5,1,1.5,1) + 0.1, mfrow = c(5, 1))
mkrsPlot(type = "CVF", singleBinPerType.mat = singleBinCVF.mat)
box(lty = 'solid', col = 'black')
mkrsPlot(type = "MTB", singleBinPerType.mat = singleBinMTB.mat)
box(lty = 'solid', col = 'black')
mkrsPlot(type = "Saliva", singleBinPerType.mat = singleBinSLV.mat)
box(lty = 'solid', col = 'black')
mkrsPlot(type = "Blood", singleBinPerType.mat = singleBinBLD.mat)
box(lty = 'solid', col = 'black')
mkrsPlot(type = "SMN", singleBinPerType.mat = singleBinSMN.mat)
box(lty = 'solid', col = 'black')
dev.off()


set.seed(123)

singleBinList = 
  list(singleBinCVF.mat, singleBinMTB.mat, singleBinSLV.mat, 
     singleBinBLD.mat, singleBinSMN.mat)
singleBinList1 = singleBinList
singleBinClustList  = list()
for(typeIndex in 1:length(singleBinList)){
  clustPseudoF = c()
  clustPerTypeList = list()
  for(centerNum in 2:6){
    
  
    
    # kmeans
    clustPerTypeList[[centerNum - 1]] = kmeans(singleBinList[[typeIndex]], centers = centerNum,
                                               nstart = 1000, iter.max = 1000)
    # Pseudo F of the clustering configuration 
    clustPseudoF[centerNum - 1] = PseudoF(data1 = singleBinList[[typeIndex]], 
                                          clus1 = clustPerTypeList[[centerNum - 1]]$cluster)
  }
  clusterIndex = which.max(clustPseudoF)
  singleBinClustList[[typeIndex]] = clustPerTypeList[[clusterIndex]]
  singleBinList1[[typeIndex]] = singleBinList1[[typeIndex]]*singleBinClustList[[typeIndex]]$cluster + 1
}  


apply(as.matrix(singleBinList[[1]]), 1, table)
apply(as.matrix(singleBinList[[2]]), 1, table)
apply(as.matrix(singleBinList[[3]]), 1, table)
apply(as.matrix(singleBinList[[4]]), 1, table)
apply(as.matrix(singleBinList[[5]]), 1, table)


  
  orderByCluster1 = order(singleBinClustList[[1]]$cluster)
  orderByCluster2 = order(singleBinClustList[[2]]$cluster)
  orderByCluster3 = order(singleBinClustList[[3]]$cluster)
  orderByCluster4 = order(singleBinClustList[[4]]$cluster)
  orderByCluster5 = order(singleBinClustList[[5]]$cluster)
  
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_27/markProfile5Types.pdf",
    height = 7.5, width = 5)
  par(xpd = F, mar = c(1, 4, 1, 1) + 0.2)
  image(cbind(t(singleBinList1[[5]][orderByCluster5,]),
              t(singleBinList1[[4]][orderByCluster4,]),
              t(singleBinList1[[3]][orderByCluster3,]),
              t(singleBinList1[[2]][orderByCluster2,]),
              t(singleBinList1[[1]][orderByCluster1,])),
        col =c("white",  rev(c("#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28"))), 
        axes = FALSE,
        main = "")
  box(which = "plot",lty = "solid")
  grid(nx = 27 , ny = nrow(singleBinPerType.mat) , lty = "solid", lwd = 0.25)
  abline (v =4.5 /26); 
  abline (v =11.5 / 26) ; 
  abline (v =16.5 / 26) ; 
  abline (v =21.5 /26)
  abline (h = 85.5/320, lwd = 0.75)
  abline (h = 150.5/320, lwd = 0.75)
  abline (h = 230.5/320, lwd = 0.75)
  abline (h = 261.5/320, lwd = 0.75)
  par(xpd = NA)
  text(label = "Semen", x = -0.1, y = 85.5/2/320, srt = 90)
  text(label = "Blood", x = -0.1, y = (85.5 + 65/2)/320, srt = 90)
  text(label = "Saliva", x = -0.1, y = (150.5 + 80/2)/320, srt = 90)
  text(label = "Menstrual\nBlood", x = -0.1, y = (230.5 + 31/2)/320, srt = 90)
  text(label = "Cervical\nFluid", x = -0.1, y = (261.5 + 59/2)/320, srt = 90)
dev.off()


par(xpd = F, mar = c(1, 4, 1, 1) + 0.2)
image(cbind(t(singleBinList1[[2]][orderByCluster2,]),
            t(singleBinList1[[1]][orderByCluster1,])),
      col =c("white",  rev(c("#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28"))), 
      axes = FALSE,
      main = "")
box(which = "plot",lty = "solid")
grid(nx = 27 , ny = nrow(singleBinPerType.mat) , lty = "solid", lwd = 0.25)
abline (v =4.5 /26); 
abline (v =11.5 / 26) ; 
abline (v =16.5 / 26) ; 
abline (v =21.5 /26)

abline (h = 85.5/321)
abline (h = 150.5/321)
abline (h = 230.5/321)
abline (h = 261.5/321)
par(xpd = NA)
text(label = "Semen", x = -0.1, y = 85.5/2/321, srt = 90)
text(label = "Blood", x = -0.1, y = (85.5 + 65/2)/321, srt = 90)
text(label = "Saliva", x = -0.1, y = (150.5 + 80/2)/321, srt = 90)
text(label = "Menstrual\nBlood", x = -0.1, y = (230.5 + 31/2)/321, srt = 90)
text(label = "Cervical\nFluid", x = -0.1, y = (261.5 + 59/2)/321, srt = 90)