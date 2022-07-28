source("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/codes/R/postProcessClassifySingleUnknownFunc.R")
library(LaplacesDemon)

###############################################################################################
######## Classify an unknown sample that only contains missing values (old a and b's) #########
###############################################################################################

classMissing20220720.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_1_2022_07_21.log",
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

###############################################################################################
######## Classify an unknown sample that only contains missing values (new a and b's) #########
###############################################################################################

classMissingV220220720.df = 
  read.table(file="/Users/chwu/Documents/research/bfc/output/2022_07_20/ex.missing_v2_2022_07_20.log",
             header = T, as.is = T, sep="\t")
plot(classMissingV220220720.df$log.posterior[-c(1:2500)], type="l")
plot(classMissingV220220720.df$multiTypeMDP, type="l")
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


