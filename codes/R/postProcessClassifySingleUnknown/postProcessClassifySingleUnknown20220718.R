source("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/codes/R/postProcessClassifySingleUnknownFunc.R")
library(LaplacesDemon)

slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
                  header = T, as.is = T)
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
                  header = T, as.is = T)

slvUnknownClose.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_close.csv",
                              header = T, as.is = T)


###############################################################################################
################### Classify an unknown sample that is close to an saliva #####################
###############################################################################################

# Read in the log file
classUnknown20220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknown_2022_07_18.log",
         header = T, as.is = T, sep = "\t")
plot(classUnknown20220718.df$log.posterior, 
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
classUnknown20220718.df = classUnknown20220718.df[-c(1:2601),]

classUnknown20220718.parts = 
  do.call(rbind, sapply(classUnknown20220718.df$typeList, strsplit, split = " "))
classUnknown20220718.classSlv = grep(classUnknown20220718.parts[,1], pattern = "146")
classUnknown20220718.classBld = grep(classUnknown20220718.parts[,2], pattern = "146")

plot(classUnknown20220718.df$log.posterior, 
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
ESS(classUnknown20220718.df$log.posterior)


classSlvclusterAssign = 
  getclusterAssignIndex(partStr = classUnknown20220718.parts[classUnknown20220718.classSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_close_in_slv.pdf",
    height = 4.5, width = 5)

par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classSlvclusterAssign$index[nrow(classSlvclusterAssign$index),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#EB4D28"))

dev.off()

classBldclusterAssign = 
  getclusterAssignIndex(partStr =  classUnknown20220718.parts[classUnknown20220718.classBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_unknown_close_in_bld.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = bquote("Blood: Cluster Estimated at Step"~.(max(classBld)*100)), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classBldclusterAssign$index[nrow(classBldclusterAssign$index),], 
         unknown = 66,
         c("white",  "#093E4277", "#EC972D77", "#EC972D77", "#EB4D28"))
dev.off()


classUnknown20220718.unknownSlvSubtypeSize = 
  unname(sapply(classSlvclusterAssign$parts, getSubtypeSize, unknownLabel = "81"))

classUnknown20220718.unknownBldSubtypeSize = 
  sapply(classBldclusterAssign$parts, getSubtypeSize, unknownLabel = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_close_subtype_size.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(classUnknown20220718.unknownSlvSubtypeSize, 
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(classUnknown20220718.unknownBldSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()


###############################################################################################
############### Classify an unknown sample that is atypical of saliva (sample v1) #############
###############################################################################################

slvUnknownAtypical.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv_unknown_atypical.csv",
                                 header = T, as.is = T)

classUnknownEx220220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknownEx2_2022_07_18.log",
           header = T, as.is = T, sep = "\t")
plot(classUnknownEx220220718.df$multitypeLikelihood, type="l")


ex2Parts = do.call(rbind, sapply(classUnknownEx220220718.df$typeList, strsplit, split = " "))
ex2ClassSlv = grep(ex2Parts[,1], pattern = "146")
length(ex2ClassSlv)
ex2ClassBld = grep(ex2Parts[,2], pattern = "146")
length(ex2ClassBld)


ex2.classSlvclusterAssign = 
  getclusterAssignIndex(partStr = ex2Parts[ex2ClassSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

ex2.classBldclusterAssign = 
  getclusterAssignIndex(partStr = ex2Parts[ex2ClassBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")

ex2UnknownSlvSubtypeSize  = sapply(ex2.classSlvclusterAssign$parts, getSubtypeSize, unknown = "81")
ex2UnknownBldSubtypeSize  = sapply(ex2.classBldclusterAssign$parts, getSubtypeSize, unknown = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_slv_1.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex2.classSlvclusterAssign$index[7477,],
         unknown = 82,
         colours = c("white",  "#093E4277", "#EC972D77", "#EC972D"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_bld_1.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex2.classSlvclusterAssign$index[nrow(ex2.classSlvclusterAssign$index), ],
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


###############################################################################################
##################### Classify an unknown sample that is atypical of saliva ###################
################################ (sample v1 & different prior) ################################
###############################################################################################


classUnknownEx320220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknownEx3_2022_07_18.log",
             header = T, as.is = T, sep = "\t")
ex3Parts = do.call(rbind, sapply(classUnknownEx320220718.df$typeList, strsplit, split = " "))
ex3ClassSlv = grep(ex3Parts[,1], pattern = "146")
length(ex3ClassSlv)
ex3ClassBld = grep(ex3Parts[,2], pattern = "146")
length(ex3ClassBld)


ex3.classSlvclusterAssign = 
  getclusterAssignIndex(partStr = ex3Parts[ex3ClassSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

ex3.classBldclusterAssign = 
  getclusterAssignIndex(partStr = ex3Parts[ex3ClassBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")

ex3UnknownSlvSubtypeSize  = sapply(ex3.classSlvclusterAssign$parts, getSubtypeSize, unknown = "81")
ex3UnknownBldSubtypeSize  = sapply(ex3.classBldclusterAssign$parts, getSubtypeSize, unknown = "65")




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_slv_2.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex3.classSlvclusterAssign$index[nrow(ex3.classSlvclusterAssign$index),],
         unknown = 82,
         colours = c("white",  "#093E4277", "#34B79577", "#EC972D77", "#EB4D2877", "#6D2727" ))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_18/2022_07_18_slv_unknown_atypical_in_bld_2.pdf",
    height = 4.5, width = 5)
par(mar = c(1,1,2,1) + 0.2)
gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = ex3.classBldclusterAssign$index[nrow(ex3.classBldclusterAssign$index) - 1, ],
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
