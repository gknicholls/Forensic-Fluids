gridPlot = function(type = NULL, 
         singleBinPerType.mat = NULL,
         printInfo = FALSE,
         clusterAssign = NULL){
  
  
  singleBinPerType.mat = singleBinPerType.mat*clusterAssign
  
  orderByCluster = order(clusterAssign)
  image(t(singleBinPerType.mat[orderByCluster,]),
        col =c("white",  "#093E42", "#34B795", "#EC972D", "#836D70", "#6D2727",  "#EB4D28"), 
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

mtbMCMC.df=read.table(file = "/Users/chwu/Documents/research/bfc/output/mtb_single_clust1_0.5.log", 
                      header = TRUE, as.is = TRUE)
nrow(mtbMCMC.df)
ESS(mtbMCMC.df$Posterior)
nrow(mtbMCMC.df)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/mtb_posterior_trace.pdf",
    height = 5, width = 8)
par(mar = c(5, 4, 2, 1)+0.2)
plot(mtbMCMC.df$Posterior[-1], type = "l", las = 1,
     main = "MTB (32 observations)",
     xlab = expression("Posterior samples (10"^5*"steps; ESS = 3095)"), ylab = "# Subtypes", 
     xaxt = "n")
axis(side = 1, at = c(1:5)*2000, labels = (1:5)*2)
dev.off()


mtbMCMC.partitions = gsub(mtbMCMC.df$Partition, pattern=",", replace = ", ")
clusterAssignIndexMat = t(sapply(mtbMCMC.partitions, processParts))
rownames(clusterAssignIndexMat) = NULL
colnames(clusterAssignIndexMat) = NULL

pdf(file = "/Users/chwu/Documents/research/bfc/plots/mtb_posterior_sample_partition.pdf",
    height = 5, width = 8)
gridPlot(type = "MTB", 
         singleBinPerType.mat = data.matrix(mtb.df),
         printInfo = FALSE,
         clusterAssign = clusterAssignIndexMat[nrow(mtbMCMC.df),])
mtext(side = 1, line = 1.5, text = "Cluster estimated at step 1000000")
dev.off()

mtb.hclust = hclust(dist(mtb.df))
mtb.hclust5 = order(cutree(mtb.hclust, k= 2))

cooccur = matrix(NA, nrow = ncol(clusterAssignIndexMat), ncol = ncol(clusterAssignIndexMat))
for(i in 1:(ncol(clusterAssignIndexMat)-1)){
  for(j in (i+1):ncol(clusterAssignIndexMat)){
    cooccur[i, j] = length(which(clusterAssignIndexMat[, mtb.hclust5[i] ]==clusterAssignIndexMat[, mtb.hclust5[j]]))/nrow(clusterAssignIndexMat)
  }
}

pdf(file = "/Users/chwu/Documents/research/bfc/plots/mtb_posterior_co-exist.pdf",
    height = 5, width = 7)
par(mar = c(5, 1, 2, 4)+0.2)
image(t(cooccur), xaxt = "n", yaxt = "n", main = "MTB: Same cluster co-existing probabilities")
mtext(side = 1, line = 2.5, text = "Observations")
mtext(side = 4, line = 2, text = "Observations")
axis(side = 1, at = 1/31*((1:8)*4-1), label = c(1:8)*4)
axis(side = 4, at = 1/31*((1:8)*4-1), label = c(1:8)*4, las = 2)
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/mtb_posterior_cluster_count.pdf",
    height = 5, width = 8)
plot(apply(clusterAssignIndexMat[-1,],1, max), type="l", las = 1,
     main = "MTB (32 observations)",
     xlab = expression("Posterior samples (10"^5*"steps; ESS = 3095)"), ylab = "# Subtypes", 
     xaxt = "n", yaxt = "n")
axis(side = 1, at = c(1:5)*2000, labels = (1:5)*2)
axis(side = 2, at = 1:5, labels = 1:5, las = 1)
dev.off()
