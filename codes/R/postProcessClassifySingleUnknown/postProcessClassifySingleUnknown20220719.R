source("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/codes/R/postProcessClassifySingleUnknownFunc.R")
library(LaplacesDemon)

slvUnknownAtypical2.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_typical_slv_atypical_bld.csv",
                                  header = T, as.is = T)


###############################################################################################
##################### Classify an unknown sample that is atypical of saliva ###################
################################ (sample v2 & different J = 5) ################################
###############################################################################################

classUnknownEx4v1.20220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx4v1_2022_07_19.log",
             header = T, as.is = T, sep="\t")

ex4v1Parts = do.call(rbind, sapply(classUnknownEx4v1.20220719.df$typeList, strsplit, split = " "))
ex4v1ClassSlv = grep(ex4v1Parts[,1], pattern = "146")
length(ex4v1ClassSlv)
ex4v1ClassBld = grep(ex4v1Parts[,2], pattern = "146")
length(ex4v1ClassBld)
length(ex4v1ClassSlv)/nrow(ex4v1Parts)

ex4v1ClassSlvclusterAssign = getclusterAssignIndex(partStr = ex4v1Parts[ex4v1ClassSlv, 1], 
                                              unknownLabel = "146", newUnknownLabel = "81")

ex4v1ClassBldclusterAssign = getclusterAssignIndex(partStr = ex4v1Parts[ex4v1ClassSlv, 2], 
                                                   unknownLabel = "146", newUnknownLabel = "65")


ex4v1UnknownSlvSubtypeSize = 
  unname(sapply(ex4v1ClassSlvclusterAssign$parts, getSubtypeSize, unknownLabel = "81"))

ex4v1UnknownBldSubtypeSize = 
  unname(sapply(ex4v1ClassBldclusterAssign$parts, getSubtypeSize, unknownLabel = "65"))


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/2022_07_19_slv_unknown_atypical_in_slv_4.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = ex4v1ClassSlvclusterAssign$index[nrow(ex4v1ClassSlvclusterAssign$index),],
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



###############################################################################################
##################### Classify an unknown sample that is atypical of saliva ###################
############################## (sample v2 & different a and b's) ##############################
###############################################################################################



classUnknownEx4v220220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx4v2_2022_07_19.log",
             header = T, as.is = T, sep="\t")

plot(classUnknownEx4v220220719.df$log.posterior, ylim = c(-325, -225), type="l")
plot(classUnknownEx4v220220719.df$multiTypeMDP, type="l")
ESS(classUnknownEx4v220220719.df$log.posterior[-c(1:2000)])
ESS(classUnknownEx4v220220719.df$multiTypeMDP[-c(1:2000)])
ex4v2Parts = do.call(rbind, sapply(classUnknownEx4v220220719.df$typeList, strsplit, split = " "))
ex4v2ClassSlv = grep(ex4v2Parts[,1], pattern = "146")
length(ex4v2ClassSlv)
ex4v2ClassBld = grep(ex4v2Parts[,2], pattern = "146")
length(ex4v2ClassBld)





###############################################################################################
##################### Classify an unknown sample that is atypical of saliva ###################
################################ (sample v2 & different J = 20) ################################
###############################################################################################

classUnknownEx4v320220719.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_19/ex.multiTypeObsWithUnknownEx4v3_2022_07_19.log",
             header = T, as.is = T, sep="\t")

ex4v3Parts = do.call(rbind, sapply(classUnknownEx4v320220719.df$typeList, strsplit, split = " "))
ex4v3ClassSlv = grep(ex4v3Parts[,1], pattern = "146")
length(ex4v3ClassSlv)
ex4v3ClassBld = grep(ex4v3Parts[,2], pattern = "146")
length(ex4v3ClassBld)



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



