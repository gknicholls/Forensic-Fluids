getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}


loocvBayesLogPaths <- c("/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_37.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_52.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_23.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_59.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_33.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_5.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_22.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_16.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/cvf/loocvTrain_cvf_28.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_15.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_17.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_18.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_6.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_26.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_10.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/mtb/loocvTrain_mtb_9.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/slv/loocvTrain_slv_2.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/bld/loocvTrain_bld_10.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/smn/loocvTrain_smn_8.log",
  "/Users/chwu/Documents/research/bfc/paper/analysis/Bayes/smn/loocvTrain_smn_76.log")


loocvCutLogPaths <- c("/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_37.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_52.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_23.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_59.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_33.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_5.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_22.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_16.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_28.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_15.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_17.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_18.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_6.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_26.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_10.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_mtb_9.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_slv_2.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_bld_10.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_8.log",
                        "/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_smn_76.log")


bayesCutComparePostMat<- matrix(nrow = 2*length(loocvBayesLogPaths ), ncol = 5)
for(index in 1:length(loocvBayesLogPaths )){
  bayesLog.df <- read.table(file = loocvBayesLogPaths[index], header = T, as.is = T, sep = "\t")
  cutLog.df <- read.table(file = loocvCutLogPaths[index], header = T, as.is = T, sep = "\t")
  bayesCutComparePostMat[index*2 - 1, ] <- getTypeDistr(bayesLog.df$unknownType.0[-c(1:round(nrow(bayesLog.df)/10))])
  bayesCutComparePostMat[index*2, ] <-getTypeDistr(cutLog.df$unknownType.0[-c(1:round(nrow(cutLog.df)/10))])
  
}

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2023_02_13/compareBayesCut_2023_02_13.pdf",
    height = 5, width = 6.5)
par(mar = c(5, 4, 1, 1) + 0.2)
plot(bayesCutComparePostMat[c(1:20)*2 - 1,], bayesCutComparePostMat[c(1:20)*2,], 
     pch = rep(rep(1:5, c(9, 7, 1, 1, 2)), 5), 
     col = rep(c("#6D2727", "#34B795", "#EC972D", "#EB4D28", "#093E42"), rep(19,5) ),
     xlab = "Bayes Type Posterior", ylab = "Cut Type Posterior") 
abline(0, 1, col="darkgrey")
legend("bottomright", c("True", "CVF", "MTB", "SLV", "BLD", "SMN", 
                    "Classified", "CVF", "MTB", "SLV", "BLD", "SMN"), ncol = 2,
       col = c("NA", rep("black", 5), 
               "NA", "#6D2727", "#34B795", "#EC972D", "#EB4D28", "#093E42"),
       pch = c(NA, 1:5, NA, rep(NA, 5)), lty = rep(c(NA, 1), c(7, 5)))
dev.off()

plot(bayesCutComparePostMat[c(1:20)*2 - 1,1], bayesCutComparePostMat[c(1:20)*2,1], type = "n",
     xlab = "Bayes Type Posterior", ylab = "Cut Type Posterior") 
text(label = sc(37, 52, 23, 59, 33, 5, 22, 16, 28, 15, 17, 18, 6, 26, 10, 9, 2, 10, 8, 76), 
     x = bayesCutComparePostMat[c(1:20)*2 - 1,1], y = bayesCutComparePostMat[c(1:20)*2,1],)



