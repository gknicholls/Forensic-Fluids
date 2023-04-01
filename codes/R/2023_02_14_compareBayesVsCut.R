getTypeDistr<-function(postTypeVar){
  counts<-sapply(c(0:4), 
                 function(type, post.type){
                   length(which(post.type == type))
                 }, post.type = postTypeVar)
  return(counts/length(postTypeVar))
}

loocvCutLogPaths1 <- c("/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_37.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_52.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_23.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_59.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_33.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_5.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_22.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_16.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_12/loocvCut_side_cvf_28.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_15.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_17.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_18.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_6.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_26.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_10.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_mtb_9.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_slv_2.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_bld_10.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_smn_8.log",
                      "/Users/chwu/Documents/research/bfc/analysis/2023_02_13/loocvCut_side_smn_76.log")


loocvCutLogPaths2 <- c("/Users/chwu/Documents/research/bfc/analysis/2023_02_14/loocvCut_side_cvf_37.log",
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

log.post.diff<-c()
for(i in 1:length(loocvCutLogPaths1)){
  log1.df <- read.table(file = loocvCutLogPaths1[i], header = T, as.is = T, sep = "\t")
  log2.df <- read.table(file = loocvCutLogPaths2[i], header = T, as.is = T, sep = "\t")
  log.post.diff[i] <- sum(abs(log1.df$log.posterior-log2.df$log.posterior))
}


