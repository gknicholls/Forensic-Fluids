gridPlot = function(type = NULL, 
                    singleBinPerType.mat = NULL,
                    printInfo = FALSE,
                    clusterAssign = NULL,
                    unknown = NULL,
                    colours = c("white",  "#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28")){
  
  if(max(clusterAssign) > 1){
    subtype = clusterAssign[unknown]
    subtypeElt = which(clusterAssign == subtype)
    subtypeMaxElt = which(clusterAssign == max(clusterAssign))
    clusterAssign[subtypeElt] = max(clusterAssign)
    clusterAssign[subtypeMaxElt] = subtype
    if(length(subtypeElt) > 1){
      clusterAssign[unknown] = max(clusterAssign) + 1
    }
  }
  
  singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  
  
  # if(length(unknown) == 0){
  #   singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  # }else{
  #   singleBinPerType.mat[-unknown, ] = singleBinPerType.mat[-unknown, ]*clusterAssign[-unknown]
  #   singleBinPerType.mat[unknown, ] = singleBinPerType.mat[unknown, ]*(max(clusterAssign) + 1)
  # }
  
  
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

library(LaplacesDemon)

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


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_close_in_slv.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classSlvclusterAssignIndex[nrow(classSlvclusterAssignIndex),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#EB4D28"))
dev.off()

classBldPartStr = partitions[classBld, 2]
classBldPartStr = gsub(classBldPartStr, pattern = "146", replace="65")
classBldParts = gsub(classBldPartStr, pattern = ",", replace = ", ")
classBldclusterAssignIndex= t(sapply(classBldParts, processParts))
rownames(classBldclusterAssignIndex) = NULL
colnames(classBldclusterAssignIndex) = NULL


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_close_in_bld.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = bquote("Blood: Cluster Estimated at Step"~.(max(classBld)*100)), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classBldclusterAssignIndex[ncol(classBldclusterAssignIndex),], 
         unknown = 66,
         c("white",  "#093E4277", "#EC972D77", "#EC972D77", "#EB4D28"))
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

slvUnknownAtypical.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_atypical.csv",
                              header = T, as.is = T)

classUnknownEx220220718.df = 
  read.csv(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknownEx2_2022_07_18.log",
             header = T, as.is = T)

ex2Parts = do.call(rbind, sapply(classUnknownEx220220718.df$typeList, strsplit, split = " "))
ex2ClassSlv = grep(ex2Parts[,1], pattern = "146")
length(ex2ClassSlv)
ex2ClassBld = grep(ex2Parts[,2], pattern = "146")
length(ex2ClassBld)


ex2ClassSlvPartStr = ex2Parts[ex2ClassSlv, 1]
ex2ClassSlvPartStr = gsub(ex2ClassSlvPartStr, pattern = "146", replace="81")
ex2ClassSlvParts = gsub(ex2ClassSlvPartStr, pattern = ",", replace = ", ")
ex2ClassSlvclusterAssignIndex = t(sapply(ex2ClassSlvParts, processParts))
rownames(ex2ClassSlvclusterAssignIndex) = NULL
colnames(ex2ClassSlvclusterAssignIndex) = NULL



ex2UnknownSlvSubtypeSize  = sapply(ex2ClassSlvParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "81")
summary(x)
table(ex2UnknownSlvSubtypeSize )


ex2ClassBldPartStr = ex2Parts[ex2ClassBld, 2]
ex2ClassBldPartStr = gsub(ex2ClassBldPartStr, pattern = "146", replace="65")
ex2ClassBldParts = gsub(ex2ClassBldPartStr, pattern = ",", replace = ", ")
ex2ClassBldclusterAssignIndex= t(sapply(ex2ClassBldParts, processParts))
rownames(ex2ClassBldclusterAssignIndex) = NULL
colnames(ex2ClassBldclusterAssignIndex) = NULL

ex2UnknownBldSubtypeSize  = sapply(ex2ClassBldParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "65")
summary(ex2UnknownBldSubtypeSize )
table(ex2UnknownBldSubtypeSize )


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_slv_1.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex2ClassSlvclusterAssignIndex[7477,],
         unknown = 82,
         colours = c("white",  "#093E4277", "#EC972D77", "#EC972D"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_bld_1.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex2ClassBldclusterAssignIndex[nrow(ex2ClassBldclusterAssignIndex), ],
         unknown = 66,
         colours = c("white",  "#093E4277", "#EC972D77", "#EC972D77", "#EB4D28"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_size_2.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(ex3UnknownSlvSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled (atypical saliva)\n sample is assigned to saliva",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
hist(ex3UnknownBldSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled  (atypical saliva)\n sample is assigned to blood",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
dev.off()




classUnknownEx320220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknownEx3_2022_07_18.log",
             header = T, as.is = T, sep = "\t")
ex3Parts = do.call(rbind, sapply(classUnknownEx320220718.df$typeList, strsplit, split = " "))
ex3ClassSlv = grep(ex3Parts[,1], pattern = "146")
length(ex3ClassSlv)
ex3ClassBld = grep(ex3Parts[,2], pattern = "146")
length(ex3ClassBld)




ex3ClassSlvPartStr = ex3Parts[ex3ClassSlv, 1]
ex3ClassSlvPartStr = gsub(ex3ClassSlvPartStr, pattern = "146", replace="81")
ex3ClassSlvParts = gsub(ex3ClassSlvPartStr, pattern = ",", replace = ", ")
ex3ClassSlvclusterAssignIndex = t(sapply(ex3ClassSlvParts, processParts))
rownames(ex3ClassSlvclusterAssignIndex) = NULL
colnames(ex3ClassSlvclusterAssignIndex) = NULL

ex3UnknownSlvSubtypeSize  = sapply(ex3ClassSlvParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "81")
summary(ex3UnknownSlvSubtypeSize )
table(ex3UnknownSlvSubtypeSize )


ex3ClassBldPartStr = ex3Parts[ex3ClassBld, 2]
ex3ClassBldPartStr = gsub(ex3ClassBldPartStr, pattern = "146", replace="65")
ex3ClassBldParts = gsub(ex3ClassBldPartStr, pattern = ",", replace = ", ")
ex3ClassBldclusterAssignIndex= t(sapply(ex3ClassBldParts, processParts))
rownames(ex3ClassBldclusterAssignIndex) = NULL
colnames(ex3ClassBldclusterAssignIndex) = NULL

ex3UnknownBldSubtypeSize  = sapply(ex3ClassBldParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "65")
summary(ex3UnknownBldSubtypeSize )
table(ex3UnknownBldSubtypeSize )




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_slv_2.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex3ClassSlvclusterAssignIndex[nrow(ex3ClassSlvclusterAssignIndex),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#6D2727" ))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_bld_2.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex3ClassBldclusterAssignIndex[nrow(ex3ClassBldclusterAssignIndex) - 1, ],
         unknown = 66,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D28"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_size_2.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(ex3UnknownSlvSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled (atypical saliva)\n sample is assigned to saliva",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
hist(ex3UnknownBldSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled  (atypical saliva)\n sample is assigned to blood",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
dev.off()



classUnknownEx420220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx4v2_2022_07_19.log",
           header = T, as.is = T, sep="\t")

ex4Parts = do.call(rbind, sapply(classUnknownEx420220719.df$typeList, strsplit, split = " "))
ex4ClassSlv = grep(ex4Parts[,1], pattern = "146")
length(ex4ClassSlv)
ex4ClassBld = grep(ex4Parts[,2], pattern = "146")
length(ex4ClassBld)


ex4ClassSlvPartStr = ex4Parts[ex4ClassSlv, 1]
ex4ClassSlvPartStr = gsub(ex4ClassSlvPartStr, pattern = "146", replace="81")
ex4ClassSlvParts = gsub(ex4ClassSlvPartStr, pattern = ",", replace = ", ")
ex4ClassSlvclusterAssignIndex = t(sapply(ex4ClassSlvParts, processParts))
rownames(ex4ClassSlvclusterAssignIndex) = NULL
colnames(ex4ClassSlvclusterAssignIndex) = NULL

ex4UnknownSlvSubtypeSize  = sapply(ex4ClassSlvParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "81")
summary(ex4UnknownSlvSubtypeSize )
table(ex4UnknownSlvSubtypeSize )


ex4ClassBldPartStr = ex4Parts[ex4ClassBld, 2]
ex4ClassBldPartStr = gsub(ex4ClassBldPartStr, pattern = "146", replace="65")
ex4ClassBldParts = gsub(ex4ClassBldPartStr, pattern = ",", replace = ", ")
ex4ClassBldclusterAssignIndex= t(sapply(ex4ClassBldParts, processParts))
rownames(ex4ClassBldclusterAssignIndex) = NULL
colnames(ex4ClassBldclusterAssignIndex) = NULL

ex4UnknownBldSubtypeSize  = sapply(ex4ClassBldParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "65")
summary(ex4UnknownBldSubtypeSize )
table(ex4UnknownBldSubtypeSize )

slvUnknownAtypical2.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_typical_slv_atypical_bld.csv",
                                 header = T, as.is = T)




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_in_slv_4.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = ex4ClassSlvclusterAssignIndex[nrow(ex4ClassSlvclusterAssignIndex),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#6D2727" ))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_in_bld_4.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = ex4ClassBldclusterAssignIndex[nrow(ex4ClassBldclusterAssignIndex) - 1, ],
         unknown = 66,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D28"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_size_4.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(ex3UnknownSlvSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled (atypical saliva)\n sample is assigned to saliva",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
hist(ex3UnknownBldSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled  (atypical saliva)\n sample is assigned to blood",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
dev.off()



classUnknownEx520220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx5_2022_07_19.log",
             header = T, as.is = T, sep="\t")

ex5Parts = do.call(rbind, sapply(classUnknownEx520220719.df$typeList, strsplit, split = " "))
ex5ClassSlv = grep(ex5Parts[,1], pattern = "113")
length(ex5ClassSlv)
ex5ClassBld = grep(ex5Parts[,2], pattern = "113")
length(ex5ClassBld)



classUnknownEx4v320220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx4v3_2022_07_19.log",
             header = T, as.is = T, sep="\t")

ex4v3Parts = do.call(rbind, sapply(classUnknownEx4v320220719.df$typeList, strsplit, split = " "))
ex4v3ClassSlv = grep(ex4v3Parts[,1], pattern = "146")
length(ex4v3ClassSlv)
ex4v3ClassBld = grep(ex4v3Parts[,2], pattern = "146")
length(ex4v3ClassBld)


classMissing20220720.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_20/ex.missing_2022_07_20.log",
             header = T, as.is = T, sep="\t")
plot(classMissing20220720.df$log.posterior[-c(1:600)], type="l")
ESS(classMissing20220720.df$log.posterior[-c(1:600)])
ESS(classMissing20220720.df$multitypeLikelihood[-c(1:600)])
ESS(classMissing20220720.df$multiTypeMDP[-c(1:600)])
missingParts = do.call(rbind, sapply(classMissing20220720.df$typeList, strsplit, split = " "))
missingSlv = grep(missingParts[-c(1:600),1], pattern = "146")
length(missingSlv)
missingBld = grep(missingParts[-c(1:600),2], pattern = "146")
length(missingBld)



classMissingV220220720.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_20/ex.missing_v2_2022_07_20.log",
             header = T, as.is = T, sep="\t")
plot(classMissingV220220720.df$log.posterior[-c(1:2500)], type="l")
ESS(classMissingV220220720.df$log.posterior[-c(1:2500)])
ESS(classMissingV220220720.df$multitypeLikelihood[-c(1:2500)])
ESS(classMissingV220220720.df$multiTypeMDP[-c(1:2500)])
missingV2Parts = do.call(rbind, sapply(classMissingV220220720.df$typeList[-c(1:2500)], strsplit, split = " "))
missingV2Slv = grep(missingV2Parts[,1], pattern = "146")
length(missingV2Slv)
missingV2Bld = grep(missingV2Parts[,2], pattern = "146")
length(missingV2Bld)

index = rep(0, nrow(classMissingV220220720.df[-c(1:2500),]))
index[grep(missingV2Parts[,1], pattern = "146")] = 1
plot(index, type="l")

sqrt(0.5357952*(1- 0.5357952)/ESS(index))
mean(index)

plot(sapply(1:length(index), function(z){mean(index[c(1:z)])}), type = "l", ylim = c(0.45,0.55))






classMissingV320220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v3_2022_07_21.log",
             header = T, as.is = T, sep="\t")
plot(classMissingV320220721.df$log.posterior[-c(1:500)], type="l")
plot(classMissingV320220721.df$multiTypeMDP[-c(1:500)], type="l")
plot(classMissingV320220721.df$multitypeLikelihood[-c(1:500)], type="l")
ESS(classMissingV320220721.df$log.posterior[-c(1:500)])
ESS(classMissingV320220721.df$multitypeLikelihood[-c(1:500)])
ESS(classMissingV320220721.df$multiTypeMDP[-c(1:500)])
missingV3Parts20220721 = do.call(rbind, sapply(classMissingV320220721.df$typeList, strsplit, split = " "))
missingV3Slv20220721 = grep(missingV3Parts20220721[-c(1:500),1], pattern = "146")
length(missingV3Slv20220721)
missingV3Bld20220721 = grep(missingV3Parts20220721[-c(1:500),2], pattern = "146")
length(missingV3Bld20220721)
index = rep(0, nrow(classMissingV220220721.df[-c(1:500),]))
index[grep(missingV2Parts20220721[-c(1:500),1], pattern = "146")] = 1
ESS(index)
mean(index)




classMissingV220220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v2_2022_07_21.log",
             header = T, as.is = T, sep="\t")
plot(classMissingV220220721.df$log.posterior[-c(1:500)], type="l")
plot(classMissingV220220721.df$multiTypeMDP[-c(1:500)], type="l")
plot(classMissingV220220721.df$multitypeLikelihood[-c(1:500)], type="l")
ESS(classMissingV220220721.df$log.posterior[-c(1:500)])
ESS(classMissingV220220721.df$multitypeLikelihood[-c(1:500)])
ESS(classMissingV220220721.df$multiTypeMDP[-c(1:500)])
missingV2Parts20220721 = do.call(rbind, sapply(classMissingV220220721.df$typeList, strsplit, split = " "))
missingV2Slv20220721 = grep(missingV2Parts20220721[,1], pattern = "146")
length(missingV2Slv20220721)
missingV2Bld20220721 = grep(missingV2Parts20220721[,2], pattern = "146")
length(missingV2Bld20220721)
index = rep(0, nrow(classMissingV220220721.df[-c(1:500),]))
index[grep(missingV2Parts20220721[-c(1:500),1], pattern = "146")] = 1
ESS(index)
mean(index)




classUnknownEx220220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.multiTypeObsWithUnknownEx4v2_2022_07_21.log",
             header = T, as.is = T, sep="\t")

ex2v2Parts20220721 = do.call(rbind, sapply(classUnknownEx220220721.df$typeList, strsplit, split = " "))
ex2v2ClassSlv20220721 = grep(ex2v2Parts20220721[,1], pattern = "146")
length(ex2v2ClassSlv20220721)
ex2v2ClassBld20220721 = grep(ex2v2Parts20220721[,2], pattern = "146")
length(ex2v2ClassBld20220721)

index = as.numeric(!is.na(match(1:nrow(ex2v2Parts20220721), grep(ex2v2Parts20220721[,1], pattern = "146"))))
ESS(index)
mean(index)
plot(index, type="l")


classUnknownEx2v320220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.multiTypeObsWithUnknownEx4v3_2022_07_21.log",
             header = T, as.is = T, sep="\t")

ex2v3Parts20220721 = do.call(rbind, sapply(classUnknownEx2v320220721.df$typeList, strsplit, split = " "))
ex2v3ClassSlv20220721 = grep(ex2v3Parts20220721[,1], pattern = "146")
length(ex2v3ClassSlv20220721)
ex2v3ClassBld20220721 = grep(ex2v3Parts20220721[,2], pattern = "146")
length(ex2v3ClassBld20220721)

index = as.numeric(!is.na(match(1:nrow(ex2v3Parts20220721), grep(ex2v3Parts20220721[,1], pattern = "146"))))
ESS(index)
mean(index)
plot(index, type="l")



ex4ClassSlvPartStr = ex4Parts[ex4ClassSlv, 1]
ex4ClassSlvPartStr = gsub(ex4ClassSlvPartStr, pattern = "146", replace="81")
ex4ClassSlvParts = gsub(ex4ClassSlvPartStr, pattern = ",", replace = ", ")
ex4ClassSlvclusterAssignIndex = t(sapply(ex4ClassSlvParts, processParts))
rownames(ex4ClassSlvclusterAssignIndex) = NULL
colnames(ex4ClassSlvclusterAssignIndex) = NULL

ex4UnknownSlvSubtypeSize  = sapply(ex4ClassSlvParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "81")
summary(ex4UnknownSlvSubtypeSize )
table(ex4UnknownSlvSubtypeSize )


ex4ClassBldPartStr = ex4Parts[ex4ClassBld, 2]
ex4ClassBldPartStr = gsub(ex4ClassBldPartStr, pattern = "146", replace="65")
ex4ClassBldParts = gsub(ex4ClassBldPartStr, pattern = ",", replace = ", ")
ex4ClassBldclusterAssignIndex= t(sapply(ex4ClassBldParts, processParts))
rownames(ex4ClassBldclusterAssignIndex) = NULL
colnames(ex4ClassBldclusterAssignIndex) = NULL

ex4UnknownBldSubtypeSize  = sapply(ex4ClassBldParts, function(z, unknown){
  subTypes = unlist(strsplit(z,split = "], [", fixed = T))
  length(unlist(strsplit(subTypes[grep(subTypes , pattern = unknown)], split=", ")))
}, unknown = "65")
summary(ex4UnknownBldSubtypeSize )
table(ex4UnknownBldSubtypeSize )

slvUnknownAtypical2.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_typical_slv_atypical_bld.csv",
                                  header = T, as.is = T)




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_in_slv_4.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = ex4ClassSlvclusterAssignIndex[nrow(ex4ClassSlvclusterAssignIndex),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#6D2727" ))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_in_bld_4.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = ex4ClassBldclusterAssignIndex[nrow(ex4ClassBldclusterAssignIndex) - 1, ],
         unknown = 66,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D28"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_size_4.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(ex3UnknownSlvSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled (atypical saliva)\n sample is assigned to saliva",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
hist(ex3UnknownBldSubtypeSize, prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unlabelled  (atypical saliva)\n sample is assigned to blood",
     xlab = "Size of the subtype to which\nthe unlabelled sample is assigned")
dev.off()