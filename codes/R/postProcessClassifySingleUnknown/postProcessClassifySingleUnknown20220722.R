source("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/codes/R/postProcessClassifySingleUnknownFunc.R")
library(LaplacesDemon)

slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
                  header = T, as.is = T)
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
                  header = T, as.is = T)


###############################################################################################
################### Classify an unknown sample that is close to an saliva #####################
###############################################################################################

# Read in the log file
classUnknownTypicalSlv20220718.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_22/ex.multiTypeObsWithUnknownEx1_2022_07_22.log",
             header = T, as.is = T, sep = "\t")
plot(classUnknownTypicalSlv20220718.df$log.posterior, ylim = c(-520, -480),
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
classUnknownTypicalSlv20220718.df = classUnknownTypicalSlv20220718.df[-c(1:200),]

classUnknownTypicalSlv20220718.parts = 
  do.call(rbind, sapply(classUnknownTypicalSlv20220718.df$typeList, strsplit, split = " "))
classUnknownTypicalSlv20220718.classSlv = grep(classUnknownTypicalSlv20220718.parts[,1], pattern = "146")
classUnknownTypicalSlv20220718.classBld = grep(classUnknownTypicalSlv20220718.parts[,2], pattern = "146")
length(classUnknownTypicalSlv20220718.classSlv)/
  (length(classUnknownTypicalSlv20220718.classSlv) + 
     length(classUnknownTypicalSlv20220718.classBld))

classUnknownTypicalSlv20220718.type = as.numeric(grepl(pattern = "146", classUnknownTypicalSlv20220718.parts[,1], fixed = TRUE))
plot(classUnknownTypicalSlv20220718.type, type = "l")

plot(classUnknownTypicalSlv20220718.df$log.posterior, 
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
ESS(classUnknownTypicalSlv20220718.df$log.posterior)


classUnknownSlvTypicalSlvclusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlv20220718.parts[classUnknownTypicalSlv20220718.classSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

classUnknownSlvTypicalSlvclusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlv20220718.parts[classUnknownTypicalSlv20220718.classSlv, 2], 
                        unknownLabel = "146", newUnknownLabel = "81")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_unknown_close_to_slv_in_slv.pdf",
    height = 7.5, width = 5)

par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = expression("Saliva: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(slv.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlvTypicalSlvclusterAssignPartSlv$index[
           nrow(classUnknownSlvTypicalSlvclusterAssignPartSlv$index),],
         unknown = 82,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#EB4D28"))

gridPlot(type = expression("Blood: Cluster Estimated at Step 10"^6), 
         singleBinPerType.mat = rbind(bld.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlvTypicalSlvclusterAssignPartBld$index[
           nrow(classUnknownSlvTypicalSlvclusterAssignPartBld$index),],
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888"))


dev.off()

classUnknownBldTypicalSlvclusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlv20220718.parts[classUnknownTypicalSlv20220718.classBld, 1], 
                        unknownLabel = "146", newUnknownLabel = "65")

classUnknownBldTypicalSlvclusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlv20220718.parts[classUnknownTypicalSlv20220718.classBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_unknown_close_to_slv_in_bld.pdf",
    height = 7.5, width = 5)
par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = "Saliva: Cluster Estimated at Step 621200", 
         singleBinPerType.mat = slv.df,
         printInfo = FALSE,
         clusterAssign = classUnknownBldTypicalSlvclusterAssignPartSlv$index[
           nrow(classUnknownBldTypicalSlvclusterAssignPartSlv$index),], 
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888"))

gridPlot(type =  "Blood: Cluster Estimated at Step 621200", 
         singleBinPerType.mat = rbind(bld.df, slvUnknownClose.df),
         printInfo = FALSE,
         clusterAssign = classUnknownBldTypicalSlvclusterAssignPartBld$index[
           nrow(classUnknownBldTypicalSlvclusterAssignPartBld$index),], 
         unknown = 66,
         c("white",  "#093E4277", "#EC972D77", "#EC972D77", "#EB4D28"))
dev.off()


classUnknown20220722.unknownSlvSubtypeSize = 
  unname(sapply(classUnknownSlvTypicalSlvclusterAssignPartSlv$parts, 
                getSubtypeSize, unknownLabel = "81"))

classUnknown20220722.unknownBldSubtypeSize = 
  sapply(classUnknownBldTypicalSlvclusterAssignPartBld$parts, 
         getSubtypeSize, unknownLabel = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_slv_unknown_close_subtype_size.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(classUnknown20220722.unknownSlvSubtypeSize, 
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(classUnknown20220722.unknownBldSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()

###############################################################################################
############## Classify an unknown sample that is close to an saliva (ver 2) ##################
###############################################################################################

# Read in the log file
classUnknownTypicalSlvEx3.20220722.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_22/ex.multiTypeObsWithUnknownEx3_2022_07_22.log",
             header = T, as.is = T, sep = "\t")
plot(classUnknownTypicalSlvEx3.20220722.df$log.posterior[-c(1:500)], ylim = c(-540, -480),
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
classUnknownTypicalSlvEx3.20220722.df = classUnknownTypicalSlvEx3.20220722.df[-c(1:500),]

classUnknownTypicalSlvEx3.20220722.parts = 
  do.call(rbind, sapply(classUnknownTypicalSlvEx3.20220722.df$typeList, strsplit, split = " "))
classUnknownTypicalSlvEx3.20220722.classSlv = 
  grep(classUnknownTypicalSlvEx3.20220722.parts[,1], pattern = "146")
classUnknownTypicalSlvEx3.20220722.classBld = 
  grep(classUnknownTypicalSlvEx3.20220722.parts[,2], pattern = "146")
length(classUnknownTypicalSlvEx3.20220722.classSlv)/
  (length(classUnknownTypicalSlvEx3.20220722.classSlv) + 
     length(classUnknownTypicalSlvEx3.20220722.classBld))
# [1] 0.8349647

classUnknownTypicalSlvEx3.20220722.type = 
  as.numeric(grepl(pattern = "146", classUnknownTypicalSlvEx3.20220722.parts[,1], fixed = TRUE))
plot(classUnknownTypicalSlvEx3.20220722.type, type = "l")
ESS(classUnknownTypicalSlvEx3.20220722.type)

plot(classUnknownTypicalSlvEx3.20220722.df$log.posterior, 
     xlab = "MCMC step", ylab = "log(Posterior)", type="l")
ESS(classUnknownTypicalSlvEx3.20220722.df$log.posterior)


classUnknownSlvTypicalSlvEx3clusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlvEx3.20220722.parts[classUnknownTypicalSlvEx3.20220722.classSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

classUnknownSlvTypicalSlvEx3clusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlvEx3.20220722.parts[classUnknownTypicalSlvEx3.20220722.classSlv, 2], 
                        unknownLabel = "146", newUnknownLabel = "81")




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_unknown_close_to_slv_atypical_in_slv.pdf",
    height = 7.5, width = 5)

par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = "Saliva: Cluster Estimated at Step 999800", 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlvTypicalSlvEx3clusterAssignPartSlv$index[
           nrow(classUnknownSlvTypicalSlvEx3clusterAssignPartSlv$index),],
         unknown = 82,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#EB4D28"))

gridPlot(type = "Blood: Cluster Estimated at Step 999800", 
         singleBinPerType.mat = rbind(bld.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlvTypicalSlvEx3clusterAssignPartBld$index[
           nrow(classUnknownSlvTypicalSlvEx3clusterAssignPartBld$index),],
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888"))

dev.off()

classUnknownBldTypicalEx3clusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlvEx3.20220722.parts[classUnknownTypicalSlvEx3.20220722.classBld, 1], 
                        unknownLabel = "146", newUnknownLabel = "65")

classUnknownBldTypicalEx3clusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownTypicalSlvEx3.20220722.parts[classUnknownTypicalSlvEx3.20220722.classBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_unknown_close_to_slv_atypical_in_bld.pdf",
    height = 7.5, width = 5)
par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = "Saliva: Cluster Estimated at Step 1000000", 
         singleBinPerType.mat = slv.df,
         printInfo = FALSE,
         clusterAssign = classUnknownBldTypicalEx3clusterAssignPartSlv$index[
           nrow(classUnknownBldTypicalSlvclusterAssignPartSlv$index),], 
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888"))

gridPlot(type =  "Blood: Cluster Estimated at Step 1000000", 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical.df),
         printInfo = FALSE,
         clusterAssign = classUnknownBldTypicalEx3clusterAssignPartBld$index[
           nrow(classUnknownBldTypicalSlvclusterAssignPartBld$index),], 
         unknown = 66,
         c("white",  "#093E4277", "#EC972D77", "#EC972D77", "#EB4D28"))
dev.off()



classUnknownEx3.20220722.unknownSlvSubtypeSize = 
  unname(sapply(classUnknownSlvTypicalSlvEx3clusterAssignPartSlv$parts, 
                getSubtypeSize, unknownLabel = "81"))

classUnknownEx3.20220722.unknownBldSubtypeSize = 
  sapply(classUnknownBldTypicalBldEx3clusterAssignPartBld$parts, 
         getSubtypeSize, unknownLabel = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_22/2022_07_22_slv_unknown_close_atypical_subtype_size.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(classUnknownEx3.20220722.unknownSlvSubtypeSize, 
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(classUnknownEx3.20220722.unknownBldSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     xlim = c(0, max(classUnknown20220718.unknownSlvSubtypeSize)),
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()


###############################################################################################
### Classify an unknown sample that has typical saliva and typical blood markers lit up  #####
############################# (new a and b's, col J = 2, row J = 5) ###########################
###############################################################################################

classUnknownAtypical220220722.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_22/ex.multiTypeObsWithUnknownAtypicalV2Ex1_2022_07_22.log",
             header = T, as.is = T, sep = "\t")
classUnknownAtypical220220722.df = classUnknownAtypical220220722.df[-c(1:501),]
classUnknownAtypical220220722.parts = 
  do.call(rbind, sapply(classUnknownAtypical220220722.df$typeList, strsplit, split = " "))
classUnknownAtypical220220722.classSlv = 
  grep(classUnknownAtypical220220722.parts[,1], pattern = "146")
classUnknownAtypical220220722.classBld = 
  grep(classUnknownAtypical220220722.parts[,2], pattern = "146")
length(classUnknownAtypical220220722.classSlv)/nrow(classUnknownAtypical220220722.df )

###############################################################################################
### Classify an unknown sample that has typical saliva and typical blood markers lit up  ######
############################ (new a and b's, col J = 2, row J = 15) ###########################
###############################################################################################


classUnknownAtypicalV2Ex2220220722.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_22/ex.multiTypeObsWithUnknownAtypicalV2Ex2_2022_07_22.log",
             header = T, as.is = T, sep = "\t")
plot(classUnknownAtypicalV2Ex2220220722.df$log.posterior[-c(1:1000)], ylim =c(-200, -50), type="l")
nrow(classUnknownAtypicalV2Ex2220220722.df)
classUnknownAtypicalV2Ex2220220722.df = classUnknownAtypicalV2Ex2220220722.df[-c(1:1000),]
plot(classUnknownAtypicalV2Ex2220220722.df$log.posterior, type="l")

classUnknownAtypicalV2Ex2220220722.parts = 
  do.call(rbind, sapply(classUnknownAtypicalV2Ex2220220722.df$typeList, strsplit, split = " "))
classUnknownAtypicalV2Ex2220220722.classSlv = 
  grep(classUnknownAtypicalV2Ex2220220722.parts[,1], pattern = "146")
classUnknownAtypicalV2Ex2220220722.classBld = 
  grep(classUnknownAtypicalV2Ex2220220722.parts[,2], pattern = "146")
length(classUnknownAtypicalV2Ex2220220722.classSlv)/nrow(classUnknownAtypicalV2Ex2220220722.df )

