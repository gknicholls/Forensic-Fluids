loocvTrain_slv_1.df = read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_slv_1.log",
                                 header = T, as.is = T, sep="\t")
loocvTrain_smn_1.df = read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_smn_1.log",
                                 header = T, as.is = T, sep="\t")
table(loocvTrain_slv_1.df$unknownType.0 == 2)


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_15/loocvTrain_slv_mdp_post_1.pdf",
    height = 6.5, width = 8)
par(mar = c(4, 4, 2, 1) + 0.2, mfrow = c(2, 2))
plot(loocvTrain_slv_1.df$multiTypeMDP.2, 
     type = "l", main = "Classifying saliva sample: 10BuccalJ",
     xlab = "MCMC steps (10000's)", ylab = "Saliva log(MDP prior)")
plot(loocvTrain_slv_1.df$multiTypeMDP.4,
     type = "l", main = "Classifying saliva sample: 10BuccalJ",
     xlab = "MCMC steps (10000's)", ylab = "Semen log(MDP prior)")
plot(loocvTrain_slv_1.df$log.posterior, 
     type = "l", main = "Classifying saliva sample: 10BuccalJ",
     xlab = "MCMC steps (10000's)", ylab = "log(posterior)")
dev.off()


table(loocvTrain_smn_1.df$unknownType.0 == 4)
loocvTrain_smn_1.df = loocvTrain_smn_1.df[c(1:floor(nrow(loocvTrain_smn_1.df)/10))*10,]
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_15/loocvTrain_smn_mdp_post_1.pdf",
    height = 6.5, width = 8)
par(mar = c(4, 4, 2, 1) + 0.2, mfrow = c(2, 2))
plot(loocvTrain_smn_1.df$multiTypeMDP.2, 
     type = "l", main = "Classifying semen sample: Se510_12_RTP",
     xlab = "MCMC steps (10000's)", ylab = "Saliva log(MDP prior)")
plot(loocvTrain_smn_1.df$multiTypeMDP.4, 
     type = "l", main = "Classifying semen sample: Se510_12_RTP",
     xlab = "MCMC steps (10000's)", ylab = "Semen log(MDP prior)")
plot(loocvTrain_smn_1.df$log.posterior, 
     type = "l", main = "Classifying semen sample: Se510_12_RTP",
     xlab = "MCMC steps (10000's)", ylab = "log(posterior)")
dev.off()
