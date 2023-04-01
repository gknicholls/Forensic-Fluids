loocvTrain_slv_2.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_slv_2.log",
                                 header = T, as.is = T, sep="\t")
loocvTrain_slv_33.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_slv_33.log",
                                  header = T, as.is = T, sep="\t")
loocvTrain_slv_62.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_slv_62.log",
                                 header = T, as.is = T, sep="\t")

loocvTrain_smn_8.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_smn_8.log",
                                  header = T, as.is = T, sep="\t")
loocvTrain_smn_76.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_smn_76.log",
                                 header = T, as.is = T, sep="\t")

plot(loocvTrain_slv_2.df$multiTypeMDP.4, type="l")
abline(v=2300, col="red")
abline(v=9150, col="red")
abline(v=12100, col="red")
abline(v=14100, col="red")
abline(v=16800, col="red")
abline(v=18200, col="red")
abline(v=19700, col="red")
abline(v=20300, col="red")
abline(v=20900, col="red")
abline(v=21100, col="red")
abline(v=22400, col="red")


loocvTrain_slv_2_mode1Index = c(10:2300,9150:12100,14100:16800,18200:19700,20300:20900,21100:22400)
loocvTrain_slv_2_in_mode1 = vector(length = nrow(loocvTrain_slv_2.df)) 
loocvTrain_slv_2_in_mode1[loocvTrain_slv_2_mode1Index] = T
plot(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2_in_mode1], type="l")
plot(loocvTrain_slv_2.df$multiTypeMDP.4[!loocvTrain_slv_2_in_mode1], type="l")

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_16/slv_2_atypical_bf_post_cond_mode_2022_10_16.pdf",
    height = 4.5, width = 10)

par(mfrow = c(1,2), mar = c(5, 4, 1, 1)+0.2, las = 1)
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2_in_mode1], prob = T,
     xlim = c(-140, -50), col="#0000FF55", main = "", 
     xlab = "MDP prior on semen samples", ylim = c(0, 0.05), border = "blue")
hist(loocvTrain_slv_2.df$multiTypeMDP.4[!loocvTrain_slv_2_in_mode1], 
     xlim = c(-140, -50), , col="#FF000055", add = T, prob = T, nclass = 30, border = "red")
legend("topleft", c("Mode 1", "Mode 2"), col = c("#0000FF55", "#FF000055"), pch = 15, border = c("blue", "red"), bty="n")
loocvTrain_slv_2_bf_freq_by_mode = rbind(table(loocvTrain_slv_2.df$unknownType.0[loocvTrain_slv_2_in_mode1])/
                                           sum(table(loocvTrain_slv_2.df$unknownType.0[loocvTrain_slv_2_in_mode1])),
                                         table(loocvTrain_slv_2.df$unknownType.0[!loocvTrain_slv_2_in_mode1])/
                                           sum(table(loocvTrain_slv_2.df$unknownType.0[!loocvTrain_slv_2_in_mode1])))
colnames(loocvTrain_slv_2_bf_freq_by_mode) = c("CVF", "MTB", "SLV", "BLD", "SMN")
barplot(loocvTrain_slv_2_bf_freq_by_mode,  xlab = "Body Fluid Type", ylab = "(Conditional) Posterior Probability",
        beside = T, col = c("#0000FF55", "#FF000055"), border = c("blue", "red"))
dev.off()


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_16/slv_2_atypical_2022_10_16.pdf",
    height = 6.5, width = 7)
par(mfrow = c(5, 2), mar = c(4, 4, 1, 1) + 0.2, las = 1)
layout(matrix(c(1,2,3, 4, 5, 6,6,6,6,6), 5, 2))
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2.df$unknownType.0==0], 
     main = "", nclass = 200, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.035, "Cervical Fluid", pos = 4)
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2.df$unknownType.0==1], 
     main = "", nclass = 50, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.05, "Menstrual Blood", pos = 4)
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2.df$unknownType.0==2], 
     main = "", nclass = 200, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.06, "Saliva", pos = 4)
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2.df$unknownType.0==3], 
     main = "", nclass = 100, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.06, "Blood", pos = 4)
hist(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2.df$unknownType.0==4], 
     main = "", nclass = 100, xlim = c(-140, -50), prob = T,
     xlab = "MDP prior on semen samples")
text(x = -135, y = 0.07, "Semen", pos = 4)
loocvTrain_slv_2_bf_freq = table(loocvTrain_slv_2.df$unknownType.0)/length(loocvTrain_slv_2.df$unknownType.0)
names(loocvTrain_slv_2_bf_freq) = c("CVF", "MTB", "SLV", "BLD", "SMN")
barplot(loocvTrain_slv_2_bf_freq, col="darkgrey", border=NA, 
        xlab = "Body Fluid Classification", ylab = "Posterior Probabilty")
dev.off()

par(mfrow = c(1, 2), las = 1)
barplot(table(loocvTrain_slv_33.df$unknownType.0)/nrow(loocvTrain_slv_33.df))
barplot(table(loocvTrain_slv_62.df$unknownType.0)/nrow(loocvTrain_slv_62.df))


loocvTrain_slv_2_mode1Index = c(10:2300,9150:12100,14100:16800,18200:19700,20300:20900,21100:22400)
loocvTrain_slv_2_in_mode1 = vector(length = nrow(loocvTrain_slv_2.df)) 
loocvTrain_slv_2_in_mode1[loocvTrain_slv_2_mode1Index] = T
plot(loocvTrain_slv_2.df$multiTypeMDP.4[loocvTrain_slv_2_in_mode1], type="l")
plot(loocvTrain_slv_2.df$multiTypeMDP.4[!loocvTrain_slv_2_in_mode1], type="l")



plot(loocvTrain_slv_33.df$multiTypeMDP.4[-1], type="l")
plot(loocvTrain_slv_33.df$unknownType.0, type="l")
hist(loocvTrain_slv_33.df$unknownType.0)
loocvTrain_slv_33_bf_post_prob =  as.vector(table(loocvTrain_slv_33.df$unknownType.0[-1])/(nrow(loocvTrain_slv_33.df) - 1))
loocvTrain_slv_33_bf_post_prob[3:5] = loocvTrain_slv_33_bf_post_prob[2:4]
loocvTrain_slv_33_bf_post_prob[2] = 0
names(loocvTrain_slv_33_bf_post_prob) = c("CVF", "MTB", "SLV", "BLD", "SMN")


plot(loocvTrain_slv_62.df$multiTypeMDP.4[-c(1:5)], type="l")
loocvTrain_slv_62_bf_post_prob =  as.vector(table(loocvTrain_slv_62.df$unknownType.0[-1])/(nrow(loocvTrain_slv_62.df) - 1))
loocvTrain_slv_62_bf_post_prob[3:5] = loocvTrain_slv_62_bf_post_prob[2:4]
loocvTrain_slv_62_bf_post_prob[2] = 0



pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_11_02/slv_33_atypical_2022_11_03.pdf",
    height = 4, width = 9)
par(mfrow = c(1, 2), mar = c(5, 4, 1, 2) + 0.2)
plot(loocvTrain_slv_33.df$multiTypeMDP.4[-1], type="l", 
     xlab = "MCMC steps (10000 steps)", ylab = "log(MDP Prior on Semen)")
barplot(loocvTrain_slv_33_bf_post_prob, ylim = c(0, 1), las = 1, xlab = "Body Fluid Type",
        ylab = "Posterior probability")
text(x = 0.4, y = 0.75, label = signif(loocvTrain_slv_33_bf_post_prob[1],3), srt=-90, pos = 4)
text(x = 1.6, y = 0.75, label = signif(loocvTrain_slv_33_bf_post_prob[2],3), srt=-90, pos = 4)
text(x = 2.8, y = 0.75, label = signif(loocvTrain_slv_33_bf_post_prob[3],3), srt=-90, pos = 4)
text(x = 4, y = 0.75, label = signif(loocvTrain_slv_33_bf_post_prob[4],3), srt=-90, pos = 4)
text(x = 5.2, y = 0.75, label = signif(loocvTrain_slv_33_bf_post_prob[5],3), srt=-90, pos = 4)
dev.off()


signif(table(loocvTrain_slv_33.df$unknownType.0[-1])/(nrow(loocvTrain_slv_33.df) - 1),3)



plot(loocvTrain_smn_8.df$multiTypeMDP.4, type="l")
abline(v=7500, col="red")
abline(v=12600, col="red")
abline(v=13600, col="red")
abline(v=19300, col="red")
abline(v=21300, col="red")
loocvTrain_smn_8_mode1Index = c(1:7500,12600:13600,19300:21300)
loocvTrain_smn_8_in_mode1 = vector(length = nrow(loocvTrain_smn_8.df)) 
loocvTrain_smn_8_in_mode1[loocvTrain_smn_8_mode1Index] = T
par(mfrow = c(1,2))
plot(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8_in_mode1], type="l")
plot(loocvTrain_smn_8.df$multiTypeMDP.4[!loocvTrain_smn_8_in_mode1], type="l")

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_16/smn_8_atypical_bf_post_cond_mode_2022_10_16.pdf",
    height = 4.5, width = 10)

par(mfrow = c(1,2), mar = c(5, 4, 1, 1)+0.2, las = 1)
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8_in_mode1], prob = T,
     xlim = c(-140, -50), col="#0000FF55", main = "", nclass = 30,
     xlab = "MDP prior on semen samples", ylim = c(0, 0.065), border = "blue")
hist(loocvTrain_smn_8.df$multiTypeMDP.4[!loocvTrain_smn_8_in_mode1], 
     xlim = c(-140, -50), , col="#FF000055", add = T, prob = T, border = "red")
legend("topleft", c("Mode 1", "Mode 2"), col = c("#0000FF55", "#FF000055"), 
       pch = 15, border = c("blue", "red"), bty="n")
loocvTrain_smn_8_bf_freq_by_mode = rbind(table(loocvTrain_smn_8.df$unknownType.0[loocvTrain_smn_8_in_mode1])/
                                           sum(table(loocvTrain_smn_8.df$unknownType.0[loocvTrain_smn_8_in_mode1])),
                                         table(loocvTrain_smn_8.df$unknownType.0[!loocvTrain_smn_8_in_mode1])/
                                           sum(table(loocvTrain_smn_8.df$unknownType.0[!loocvTrain_smn_8_in_mode1])))
colnames(loocvTrain_smn_8_bf_freq_by_mode) = c("CVF", "MTB", "SLV", "BLD", "SMN")
barplot(loocvTrain_smn_8_bf_freq_by_mode,  xlab = "Body Fluid Type", ylab = "(Conditional) Posterior Probability",
        beside = T, col = c("#0000FF55", "#FF000055"), border = c("blue", "red"))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_16/smn_8_atypical_2022_10_16.pdf",
    height = 6.5, width = 7)
par(mfrow = c(5, 2), mar = c(4, 4, 1, 1) + 0.2, las = 1)
layout(matrix(c(1,2,3, 4, 5, 6,6,6,6,6), 5, 2))
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8.df$unknownType.0==0], 
     main = "", nclass = 100, xlim = c(-140, -50), xlab = "", prob = T)
text(x = -135, y = 0.12, "Cervical Fluid", pos = 4)
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8.df$unknownType.0==1], 
     main = "", nclass = 50, xlim = c(-140, -50), xlab = "", prob = T)
text(x = -135, y = 0.12, "Menstrual Blood", pos = 4)
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8.df$unknownType.0==2], 
     main = "", nclass = 50, xlim = c(-140, -50), xlab = "", prob = T)
text(x = -135, y = 0.1, "Saliva", pos = 4)
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8.df$unknownType.0==3], 
     main = "", nclass = 50, xlim = c(-140, -50), xlab = "", prob = T)
text(x = -135, y = 0.125, "Blood", pos = 4)
hist(loocvTrain_smn_8.df$multiTypeMDP.4[loocvTrain_smn_8.df$unknownType.0==4], 
     main = "", nclass = 100, xlim = c(-140, -50), prob = T,
     xlab = "MDP prior on semen samples")
text(x = -135, y = 0.055, "Semen", pos = 4)
loocvTrain_smn_8_bf_freq = table(loocvTrain_smn_8.df$unknownType.0)/length(loocvTrain_smn_8.df$unknownType.0)
names(loocvTrain_smn_8_bf_freq) = c("CVF", "MTB", "SLV", "BLD", "SMN")
barplot(loocvTrain_smn_8_bf_freq, col="darkgrey", border=NA, 
        xlab = "Body Fluid Classification", ylab = "Posterior Probabilty")
dev.off()




pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_16/smn_76_atypical_2022_10_16.pdf",
    height = 6.5, width = 7)
par(mfrow = c(5, 2), mar = c(4, 4, 1, 1) + 0.2, las = 1)
layout(matrix(c(1,2,3, 4, 5, 6,6,6,6,6), 5, 2))
hist(loocvTrain_smn_76.df$multiTypeMDP.4[loocvTrain_smn_76.df$unknownType.0==0], 
     main = "", nclass = 100, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.06, "Cervical Fluid", pos = 4)
hist(loocvTrain_smn_76.df$multiTypeMDP.4[loocvTrain_smn_76.df$unknownType.0==1], 
     main = "", nclass = 50, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.06, "Menstrual Blood", pos = 4)
hist(loocvTrain_smn_76.df$multiTypeMDP.4[loocvTrain_smn_76.df$unknownType.0==2], 
     main = "", nclass = 50, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.1, "Saliva", pos = 4)
hist(loocvTrain_smn_76.df$multiTypeMDP.4[loocvTrain_smn_76.df$unknownType.0==3], 
     main = "", nclass = 50, xlim = c(-140, -55), xlab = "", prob = T)
text(x = -135, y = 0.1, "Blood", pos = 4)
hist(loocvTrain_smn_76.df$multiTypeMDP.4[loocvTrain_smn_76.df$unknownType.0==4], 
     main = "", nclass = 100, xlim = c(-140, -55), prob = T,
     xlab = "MDP prior on semen samples")
text(x = -135, y = 0.04, "Semen", pos = 4)
loocvTrain_smn_76_bf_freq = table(loocvTrain_smn_76.df$unknownType.0)/length(loocvTrain_smn_76.df$unknownType.0)
names(loocvTrain_smn_76_bf_freq) = c("CVF", "MTB", "SLV", "BLD", "SMN")
barplot(loocvTrain_smn_76_bf_freq, col="darkgrey", border=NA, 
        xlab = "Body Fluid Classification", ylab = "Posterior Probabilty")
dev.off()


loocvTrain_smn_76.df = read.table(file="/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_smn_76.log",
                                  header = T, as.is = T, sep="\t")
clust = do.call(rbind, sapply(loocvTrain_smn_76.df$typeList, strsplit, split = " "))
rownames(clust) = NULL
par(mfrow = c(1, 1))
plot(loocvTrain_smn_76.df$multiTypeMDP.4, type='l')
abline(v = 1100)
abline(v = 2350)
abline(v = 4500)
abline(v = 4800)
abline(v = 6100)
smn.clust.mode1 = clust[c(1:1100,2351:4500, 4801:6100), 5]
smn.clust.mode2 = clust[c(1101:2350,4501:4800, 6101:6753), 5]

smn.clust.mode1 = gsub(smn.clust.mode1, pattern = "],[", replace = "], [", fixed = T)
smn.clust.mode1 = gsub(smn.clust.mode1, pattern = "[[", replace = "[", fixed = T)
smn.clust.mode1 = gsub(smn.clust.mode1, pattern = "]]", replace = "]", fixed = T)
smn.clust.mode1.list = strsplit(smn.clust.mode1, split = ", " , fixed = T)
hist(unlist(lapply(smn.clust.mode1.list, length)))
table(unlist(lapply(smn.clust.mode1.list, length)))


smn.clust.mode2 = gsub(smn.clust.mode2, pattern = "],[", replace = "], [", fixed = T)
smn.clust.mode2 = gsub(smn.clust.mode2, pattern = "[[", replace = "[", fixed = T)
smn.clust.mode2 = gsub(smn.clust.mode2, pattern = "]]", replace = "]", fixed = T)
smn.clust.mode2.list = strsplit(smn.clust.mode2, split = ", " , fixed = T)
hist(unlist(lapply(smn.clust.mode2.list, length)))
table(unlist(lapply(smn.clust.mode2.list, length)))



findSubtype = function(clust, target){
    index = c(grep(clust, pattern = paste(",", target, ",", sep="")),
              grep(clust, pattern = paste("[", target, ",", sep=""), fixed = T),
              grep(clust, pattern = paste(",", target, "]", sep=""), fixed = T),
              grep(clust, pattern = paste("[", target, "]", sep=""), fixed = T))
    clust[index]
}

findSubtype(clust = smn.clust.mode2.list[[1]], target = 7)
smn.subtype.mode1.obs8 = unlist(lapply(smn.clust.mode1.list, findSubtype, target = 7))
smn.subtype.mode2.obs8 = unlist(lapply(smn.clust.mode2.list, findSubtype, target = 7))


