source("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/codes/R/postProcessClassifySingleUnknown/postProcessClassifySingleUnknownFunc.R")
library(LaplacesDemon)

slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
                  header = T, as.is = T)
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
                  header = T, as.is = T)

###############################################################################################
############### Classify an unknown sample that only contains missing values  #################
############ (new a and b's, re-run after bug fixing, correct input specification) ############
###############################################################################################

classMissingV220220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v2_2022_07_21.log",
             header = T, as.is = T, sep="\t")
classMissingV220220721.df = classMissingV220220721.df[-c(1:500),]
classMissingV220220721.post.ess = ESS(classMissingV220220721.df$log.posterior)
classMissingV220220721.prior.ess = ESS(classMissingV220220721.df$multiTypeMDP)
classMissingV220220721.lik.ess = ESS(classMissingV220220721.df$multitypeLikelihood)
plot(classMissingV220220721.df$log.posterior, 
     type="l", xlab = "MCMC step",
     ylab = bquote("log(posterior) (ESS ="~.(signif(classMissingV220220721.post.ess, 3))*")"))

plot(classMissingV220220721.df$multiTypeMDP, 
     type="l", xlab = "MCMC step",
     ylab = bquote("log(prior) (ESS ="~.(signif(classMissingV220220721.prior.ess, 3))*")"))
plot(classMissingV220220721.df$multitypeLikelihood,
     type="l", xlab = "MCMC step",
     ylab = bquote("log(likelihood) (ESS ="~.(signif(classMissingV220220721.lik.ess, 3))*")"))

ESS(classMissingV220220721.df$multitypeLikelihood)
ESS(classMissingV220220721.df$multiTypeMDP)
missingV2Parts20220721 = do.call(rbind, sapply(classMissingV220220721.df$typeList, strsplit, split = " "))
missingV2Slv20220721 = grep(missingV2Parts20220721[,1], pattern = "146")
length(missingV2Slv20220721)
missingV2Bld20220721 = grep(missingV2Parts20220721[,2], pattern = "146")
length(missingV2Bld20220721)

index = rep(0, nrow(classMissingV220220721.df))
index[grep(missingV2Parts20220721[,1], pattern = "146")] = 1
ESS(index)
mean(index)


missing.df = data.frame(t(rep(1,27)))
names(missing.df) = names(slv.df)

## When the unlabeled profile is assigned to saliva.
# Get the assignment index for each observations in saliva
missingClassSlvClusterAssignPartSlv = 
  getclusterAssignIndex(partStr = missingV2Parts20220721[missingV2Slv20220721, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

## When the unlabeled profile is assigned to saliva
# Get the assignment index for each observations in blood
missingClassSlvClusterAssignPartBld = 
  getclusterAssignIndex(partStr = missingV2Parts20220721[missingV2Slv20220721, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_ex.missing_v2_in_slv.pdf",
    height = 7.5, width = 5)

par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = bquote("Saliva: Cluster Estimated at Step"~.((max(missingV2Slv20220721) + 500 - 1)*100)), 
         singleBinPerType.mat = rbind(slv.df, missing.df),
         printInfo = FALSE,
         clusterAssign = missingClassSlvClusterAssignPartSlv$index[
           nrow(missingClassSlvClusterAssignPartSlv$index),],
         unknown = 82,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788", "#6D2727"))

gridPlot(type = bquote("Blood: Cluster Estimated at Step"~.((max(missingV2Slv20220721) + 500 - 1)*100 )), 
         singleBinPerType.mat = rbind(bld.df),
         printInfo = FALSE,
         clusterAssign = missingClassSlvclusterAssignIndexPartBld[
           nrow(missingClassSlvclusterAssignIndexPartBld),],
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788"))
dev.off()




missingClassBldClusterAssignPartSlv = 
  getclusterAssignIndex(partStr = missingV2Parts20220721[missingV2Bld20220721, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

missingClassBldClusterAssignPartBld = 
  getclusterAssignIndex(partStr = missingV2Parts20220721[missingV2Bld20220721, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_ex.missing_v2_in_bld.pdf",
    height = 7.5, width = 5)
par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = bquote("Saliva: Cluster Estimated at Step"~.((max(missingV2Bld20220721) + 500 - 1)*100 )), 
         singleBinPerType.mat = slv.df,
         printInfo = FALSE,
         clusterAssign = missingClassBldClusterAssignPartSlv$index[
           nrow(missingClassBldClusterAssignPartSlv$index),], 
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788"))

gridPlot(type =  bquote("Blood: Cluster Estimated at Step"~.((max(missingV2Bld20220721) + 500 - 1)*100)), 
         singleBinPerType.mat = rbind(bld.df, missing.df),
         printInfo = FALSE,
         clusterAssign = missingClassBldClusterAssignPartBld$index[
           nrow(missingClassBldClusterAssignPartBld$index),], 
         unknown = 66,
         c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788", "#6D2727"))
dev.off()



# Calculate the size of the subtype containing the all-missing profile,
# when it is assigned to saliva
missingSlvSubtypeSize = unname(sapply(missingClassSlvClusterAssignPartSlv$parts, 
                                      getSubtypeSizeOfTarget, 
                                      targetStr = "81"))
# Calculate the size of the subtype containing the all-missing profile,
# when it is assigned to blood
missingBldSubtypeSize  = unname(sapply(missingClassBldClusterAssignPartBld$parts, 
                                       getSubtypeSizeOfTarget, 
                                       targetStr = "65"))


par(mfrow = c(1,2), mar = c(5,4,2,1) + 0.2)
hist(missingSlvSubtypeSize, nclass = 50)
hist(missingBldSubtypeSize, nclass = 50)


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_ex.missing_v2_subtype_size.pdf",
    height = 4, width = 9) 
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(missingSlvSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(missingBldSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()

###############################################################################################
############### Classify an unknown sample that only contains missing values  #################
####### (new a and b's, re-run after bug fixing, correct intput specification, J = 5) #########
###############################################################################################


classMissingV320220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v3_2022_07_21.log",
             header = T, as.is = T, sep="\t")
plot(classMissingV320220721.df$log.posterior, type="l")
plot(classMissingV320220721.df$log.posterior[-c(1:4000)], type="l")
plot(classMissingV320220721.df$multiTypeMDP[-c(1:4000)], type="l")
plot(classMissingV320220721.df$multitypeLikelihood[-c(1:4000)], type="l")
ESS(classMissingV320220721.df$log.posterior[-c(1:4000)])
ESS(classMissingV320220721.df$multitypeLikelihood[-c(1:4000)])
ESS(classMissingV320220721.df$multiTypeMDP[-c(1:4000)])
missingV3Parts20220721 = do.call(rbind, sapply(classMissingV320220721.df$typeList, strsplit, split = " "))
missingV3Slv20220721 = grep(missingV3Parts20220721[-c(1:4000),1], pattern = "146")
length(missingV3Slv20220721)
missingV3Bld20220721 = grep(missingV3Parts20220721[-c(1:4000),2], pattern = "146")
length(missingV3Bld20220721)
index = rep(0, nrow(classMissingV220220721.df[-c(1:500),]))
index[grep(missingV2Parts20220721[-c(1:500),1], pattern = "146")] = 1
ESS(index)
mean(index)


###############################################################################################
################## Classify an unknown sample atypical of saliva (version 2)  #################
####### (new a and b's, re-run after bug fixing, correct intput specification, J = 15) ########
###############################################################################################

classUnknownEx2.20220721.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.multiTypeObsWithUnknownEx4v2_2022_07_21.log",
             header = T, as.is = T, sep="\t")
plot(classUnknownEx2.20220721.df$log.posterior[-c(1:500)], type="l",)
plot(classUnknownEx2.20220721.df$multiTypeMDP[-c(1:500)], type="l")
plot(classUnknownEx2.20220721.df$multitypeLikelihood[-c(1:500)], type="l")

ex2v2Parts20220721 = do.call(rbind, 
                             sapply(classUnknownEx2.20220721.df$typeList, 
                                    strsplit, split = " "))
classUnknownEx220220721.df = classUnknownEx2.20220721.df[-c(1:500),]
ESS(classUnknownTypicalSlvEx3.20220722.df$log.posterior)
ESS(classUnknownTypicalSlvEx3.20220722.df$multiTypeMDP)
ESS(classUnknownTypicalSlvEx3.20220722.df$multitypeLikelihood)

classUnknownSlv3Bld3.20220722.parts = 
  do.call(rbind, sapply(classUnknownEx2.20220721.df$typeList, strsplit, split = " "))
classUnknownSlv3Bld3.20220722.classSlv = 
  grep(classUnknownSlv3Bld3.20220722.parts[,1], pattern = "146")
classUnknownSlv3Bld3.20220722.classBld = 
  grep(classUnknownSlv3Bld3.20220722.parts[,2], pattern = "146")

length(classUnknownSlv3Bld3.20220722.classSlv)/
  (length(classUnknownSlv3Bld3.20220722.classSlv) + 
     length(classUnknownSlv3Bld3.20220722.classBld))
#[1] 0.3143686


classUnknownSlv3Bld3.20220722.type = 
  as.numeric(grepl(pattern = "146", classUnknownSlv3Bld3.20220722.parts[,1], fixed = TRUE))
plot(classUnknownSlv3Bld3.20220722.type, type = "l")
ESS(classUnknownSlv3Bld3.20220722.type)



classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownSlv3Bld3.20220722.parts[classUnknownSlv3Bld3.20220722.classSlv, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownSlv3Bld3.20220722.parts[classUnknownSlv3Bld3.20220722.classSlv, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_unknown_slv3_bld3_in_slv.pdf",
    height = 7.5, width = 5)

par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = "Saliva: Cluster Estimated at Step 993200", 
         singleBinPerType.mat = rbind(slv.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartSlv$index[
           nrow(classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartSlv$index),],
         unknown = 82,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788", "#6D2727"))

gridPlot(type = "Blood: Cluster Estimated at Step 993200", 
         singleBinPerType.mat = rbind(bld.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartBld$index[
           nrow(classUnknownSlv3Bld3.20220722.clusterAssignPartBld$index),],
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#EB4D2888"))

dev.off()




classUnknownSlv3Bld3inBld.20220722.clusterAssignPartSlv = 
  getclusterAssignIndex(partStr = classUnknownSlv3Bld3.20220722.parts[classUnknownSlv3Bld3.20220722.classBld, 1], 
                        unknownLabel = "146", newUnknownLabel = "81")

classUnknownSlv3Bld3inBld.20220722.clusterAssignPartBld = 
  getclusterAssignIndex(partStr = classUnknownSlv3Bld3.20220722.parts[classUnknownSlv3Bld3.20220722.classBld, 2], 
                        unknownLabel = "146", newUnknownLabel = "65")



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_unknown_slv3_bld3_in_bld.pdf",
    height = 7.5, width = 5)

par(mfrow = c(2,1), mar = c(1,1,2,1) + 0.2)

gridPlot(type = "Saliva: Cluster Estimated at Step 993200", 
         singleBinPerType.mat = slv.df,
         printInfo = FALSE,
         clusterAssign = classUnknownSlv3Bld3inBld.20220722.clusterAssignPartSlv$index[
           nrow(classUnknownSlv3Bld3inBld.20220722.clusterAssignPartSlv$index),],
         unknown = NULL,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D272788"))

gridPlot(type = "Blood: Cluster Estimated at Step 993200", 
         singleBinPerType.mat = rbind(bld.df, slvUnknownAtypical2.df),
         printInfo = FALSE,
         clusterAssign = classUnknownSlv3Bld3inBld.20220722.clusterAssignPartBld$index[
           nrow(classUnknownSlv3Bld3inBld.20220722.clusterAssignPartBld$index),],
         unknown = 66,
         colours = c("white",  "#093E4288", "#34B79588", "#EC972D88", "#EB4D2888", "#6D2727"))

dev.off()


classUnknownSlv3Bld3.20220721.unknownSlvSubtypeSize = 
  unname(sapply(classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartSlv$parts, 
                getSubtypeSize, unknownLabel = "81"))

classUnknownSlv3Bld3.20220721.unknownBldSubtypeSize = 
  unname(sapply(classUnknownSlv3Bld3inSlv.20220722.clusterAssignPartBld$parts, 
                getSubtypeSize, unknownLabel = "65"))




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_21/2022_07_21_slv3_bld3_subtype_size.pdf",
    height = 4, width = 9)
par(mar = c(5,4,3,1) + 0.2, mfrow = c(1,2), las = 1)
hist(classUnknownSlv3Bld3.20220721.unknownSlvSubtypeSize, 
     xlim = c(0, max(classUnknownSlv3Bld3.20220721.unknownSlvSubtypeSize)),
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     main = "When the unknown sample\nis assigned to saliva",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
hist(classUnknownSlv3Bld3.20220721.unknownBldSubtypeSize, 
     prob = T, border = NA, col ="#0000FF77", nclass = 50,
     xlim = c(0, max(classUnknownSlv3Bld3.20220721.unknownSlvSubtypeSize)),
     main = "When the unknown sample\nis assigned to blood",
     xlab = "Size of subtype to which\nthe unknown sample is assigned")
dev.off()


###############################################################################################
############### Classify an unknown sample that only contains missing values  #################
###### (new a and b's, re-run after bug fixing, correct intput specification, J = 15) #########
###############################################################################################

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


