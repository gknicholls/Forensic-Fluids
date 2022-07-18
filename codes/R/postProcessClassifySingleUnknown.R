gridPlot = function(type = NULL, 
                    singleBinPerType.mat = NULL,
                    printInfo = FALSE,
                    clusterAssign = NULL,
                    unknown = NULL,
                    colours = c("white",  "#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28")){
  
  
  if(length(unknown) == 0){
    singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  }else{
    singleBinPerType.mat[-unknown, ] = singleBinPerType.mat[-unknown, ]*clusterAssign[-unknown]
    singleBinPerType.mat[unknown, ] = singleBinPerType.mat[unknown, ]*(max(clusterAssign) + 1)
  }
  
  
  orderByCluster = order(clusterAssign)
  
  image(t(singleBinPerType.mat[orderByCluster,]),
        col = colours, 
        axes = FALSE,
        main = type)
  box(which = "plot",lty = "solid")
  grid(nx = 27 , ny = nrow(singleBinPerType.mat) , lty = "solid", lwd = 0.5)
  abline (v =4.5 /26); 
  abline (v =11.5 / 26) ; 
  abline (v =16.5 / 26) ; 
  abline (v =21.5 /26)
  
}


processParts = function(z){
  tmp1 = gsub(z, pattern="[[", replace = "", fixed = T)
  tmp1 = gsub(tmp1, pattern="]]", replace = "", fixed = T)
  partSets = 
    lapply(sapply(unlist(strsplit(tmp1, split="], [", fixed = T)), strsplit, split = ", "), 
           as.numeric)
  
  clusterIndicator = c()
  for(clusterIndex in 1:length(partSets)){
    clusterIndicator[partSets[[clusterIndex]]+1] = clusterIndex
  }
  return(clusterIndicator)
}



classUnknown20220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknown_2022_07_18.log",
         header = T, as.is = T, sep = "\t")
partitions = do.call(rbind, sapply(classUnknown20220718.df$typeList, strsplit, split = " "))
classSlv = grep(partitions[,1], pattern = "146")

classBld = grep(partitions[,2], pattern = "146")

library(LaplacesDemon)
plot(classUnknown20220718.df$log.posterior[2600:nrow(classUnknown20220718.df)], type="l")
ESS(classUnknown20220718.df$log.posterior)


slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
         header = T, as.is = T)
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
                  header = T, as.is = T)

slvUnknownClose.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_close.csv",
                              header = T, as.is = T)

classSlvPartStr = partitions[classSlv, 1]
classSlvPartStr = gsub(classSlvPartStr, pattern = "146", replace="81")
classSlvParts = gsub(classSlvPartStr, pattern = ",", replace = ", ")
classSlvclusterAssignIndex= t(sapply(classSlvParts, processParts))
rownames(classSlvclusterAssignIndex) = NULL
colnames(classSlvclusterAssignIndex) = NULL


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_in_slv.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classSlvclusterAssignIndex[nrow(classSlvclusterAssignIndex),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#093E42"))
dev.off()

classBldPartStr = partitions[classBld, 2]
classBldPartStr = gsub(classBldPartStr, pattern = "146", replace="65")
classBldParts = gsub(classBldPartStr, pattern = ",", replace = ", ")
classBldclusterAssignIndex= t(sapply(classBldParts, processParts))
rownames(classBldclusterAssignIndex) = NULL
colnames(classBldclusterAssignIndex) = NULL


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_in_bld.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = bquote("Blood: Cluster Estimated at Step"~.(max(classBld))), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classBldclusterAssignIndex[ncol(classBldclusterAssignIndex),], 
         unknown = 66,
         c("white",  "#093E4277", "#EC972D", "#EB4D2877", "#EC972D"))
dev.off()

class(classBldParts)
bldSubTypes = unlist(strsplit(classBldParts[10],split = "], [", fixed = T))



unknownSlvSubtypeSize  = sapply(classSlvParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "81")
summary(unknownSlvSubtypeSize )
table(unknownSlvSubtypeSize )

par(mar = c(5,4,2,1) + 0.2)




unknownBldSubtypeSize  = sapply(classBldParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "65")
summary(unknownBldSubtypeSize )
table(unknownBldSubtypeSize )


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_close_subtype_size.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(unknownSlvSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(unknownBldSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()


classUnknownEx220220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknownEx2_2022_07_18.log",
             header = T, as.is = T, sep = "\t")
ex2Parts = do.call(rbind, sapply(classUnknownEx220220718.df$typeList, strsplit, split = " "))
ex2ClassSlv = grep(ex2Parts[,1], pattern = "146")
length(ex2ClassSlv)
ex2ClassBld = grep(ex2Parts[,2], pattern = "146")
length(ex2ClassBld)
