# Trace figures for the analyses performed from Saturday 8 -- Monday 10 October.

subClustKPrior1.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v9.log",
             header = T, as.is = T, sep="\t")
subClustKPrior2.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v7.log",
             header = T, as.is = T, sep="\t")
subClustKPrior3.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v10.log",
             header = T, as.is = T, sep="\t")

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/subtypeClust_slv_smn_mdp_2022_10_10.pdf",
    height = 8, width = 6)
par(mfrow = c(3, 2), mar = c(5, 4, 2, 1) + 0.2)
plot(subClustKPrior1.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K = 1) = 0.5")
plot(subClustKPrior1.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K = 1) = 0.5")
plot(subClustKPrior2.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(subClustKPrior2.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(subClustKPrior3.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: alpha = J  = 15")
plot(subClustKPrior3.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: alpha = J  = 15")
dev.off()

library(LaplacesDemon)
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/subtypeClust_slv_smn_mdp1_post_2022_10_10.pdf",
    height = 6, width = 8)
par(mfrow = c(2, 2), mar = c(5, 4, 4, 1) + 0.2)

plot(subClustKPrior1.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("Saliva: p(K = 1) = 0.5\nESS =",
                  round(ESS(subClustKPrior1.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)"))
plot(subClustKPrior2.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("Saliva: p(K <= 2) + 0.5*p(K = 3) = 0.5\nESS =",
                  round(ESS(subClustKPrior2.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)" ))
plot(subClustKPrior3.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("Saliva: alpha = J  = 15\nESS=",
                  round(ESS(subClustKPrior2.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)" ))

dev.off()

classCVF1Prior1.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v3.log",
             header = T, as.is = T, sep="\t")
classCVF1Prior1.replc.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v3.2.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf1_slv_smn_mdp1_post_2022_10_10.pdf",
    height = 9, width = 7.5)
par(mfrow = c(3, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF1Prior1.df$multiTypeMDP.2[c(1:671)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K = 1) = 0.5")
plot(classCVF1Prior1.replc.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K = 1) = 0.5")
plot(classCVF1Prior1.df$multiTypeMDP.4[c(1:671)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K = 1) = 0.5")
plot(classCVF1Prior1.replc.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K = 1) = 0.5")
plot(classCVF1Prior1.df$log.posterior[c(1:671)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K = 1) = 0.5, ESS =",
                  round(ESS(classCVF1Prior1.df$log.posterior[-c(1:336)])),
                  "\n(10% burnin removed)"))
plot(classCVF1Prior1.replc.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K = 1) = 0.5, ESS =",
                  round(ESS(classCVF1Prior1.replc.df$log.posterior[-c(1:500)])),
                  "\n(10% burnin removed)"))
dev.off()




classCVF1Prior2.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v4.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf1_slv_smn_mdp2_post_2022_10_10.pdf",
    height = 6.5, width = 8)
par(mfrow = c(2, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF1Prior2.df$multiTypeMDP.2[c(1:558)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) = 0.5")
plot(classCVF1Prior2.df$multiTypeMDP.4[c(1:558)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) = 0.5")
plot(classCVF1Prior2.df$log.posterior[c(1:558)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) = 0.5, ESS =",
                  round(ESS(classCVF1Prior2.df$log.posterior[-c(1:279)])),
                  "\n(10% burnin removed)"))
dev.off()


classCVF1Prior3.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v6.log",
             header = T, as.is = T, sep="\t")
classCVF1Prior3.replc.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_1_v6_copy.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf1_slv_smn_mdp3_post_2022_10_10.pdf",
    height = 9.5, width = 7.5)
par(mfrow = c(3, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF1Prior3.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF1Prior3.replc.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF1Prior3.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF1Prior3.replc.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF1Prior3.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) + 0.5*p(K = 3) = 0.5\nESS =",
                  round(ESS(classCVF1Prior3.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)"))
plot(classCVF1Prior3.replc.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) + 0.5*p(K = 3) = 0.5\nESS =",
                  round(ESS(classCVF1Prior3.replc.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)"))
dev.off()


classCVF2Prior1.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_2.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf2_slv_smn_mdp1_post_2022_10_10.pdf",
    height = 6.5, width = 7)
par(mfrow = c(2, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF2Prior1.df$multiTypeMDP.2[c(1:561)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K = 1) = 0.5")
plot(classCVF2Prior1.df$multiTypeMDP.4[c(1:561)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K = 1) = 0.5")
plot(classCVF2Prior1.df$log.posterior[c(1:561)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K = 1) = 0.5\nESS =",
                  round(ESS(classCVF2Prior1.df$log.posterior[-c(1:280)])),
                  "(10% burnin removed)"))
dev.off()




classCVF2Prior2.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_2_v2.log",
             header = T, as.is = T, sep="\t")
classCVF2Prior2.replc.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_2_v2_copy.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf2_slv_smn_mdp2_post_2022_10_10.pdf",
    height = 8.5, width = 7)
par(mfrow = c(3, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF2Prior2.df$multiTypeMDP.2[c(1:500)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) = 0.5")
plot(classCVF2Prior2.replc.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) = 0.5")
plot(classCVF2Prior2.df$multiTypeMDP.4[c(1:500)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) = 0.5")
plot(classCVF2Prior2.replc.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) = 0.5")
plot(classCVF2Prior2.df$log.posterior[c(1:500)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) = 0.5\nESS =",
                  round(ESS(classCVF2Prior2.df$log.posterior[-c(1:250)])),
                  "(10% burnin removed)"))
plot(classCVF2Prior2.replc.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) = 0.5\nESS =",
                  round(ESS(classCVF2Prior2.replc.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)"))
dev.off()



classCVF2Prior3.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/data/loocvTrain/test/cvf/loocvTrain_cvf_2_v4.log",
             header = T, as.is = T, sep="\t")
pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_10_10/classify_cvf2_slv_smn_mdp3_post_2022_10_10.pdf",
    height = 6.5, width = 7)
par(mfrow = c(2, 2), mar = c(5, 4, 2.5, 1) + 0.2)
plot(classCVF2Prior3.df$multiTypeMDP.2[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Saliva: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF1Prior3.df$multiTypeMDP.4[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(MDP prior)',
     main = "Semen: p(K <= 2) + 0.5*p(K = 3) = 0.5")
plot(classCVF2Prior3.df$log.posterior[c(1:1000)*5], type="l",
     xlab = "MCMC steps (5000)", ylab = 'log(posterior)',
     main = paste("p(K <= 2) + 0.5*p(K = 3) = 0.5\nESS =",
                  round(ESS(classCVF2Prior3.df$log.posterior[-c(1:500)])),
                  "(10% burnin removed)"))
dev.off()
