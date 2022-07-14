scaleMove20020713.df =read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_13/test_scale_gamma_2022_07_13.log",
                         header = T, as.is = T)
set.seed(123)
expt = rgamma(10001, shape = 2, rate = 2)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_13/test_scale_gamma_2022_07_13.pdf",
    width = 9, height = 4.5)
par(mfrow = c(1, 2))
hist(scaleMove20020713.df$Partition, 
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Comparing sampled distributions", xlab= "Values")
hist(expt, add = T, col = "#0000FF55", nclass = 50, prob = T, border = NA)

plot(sort(expt), sort(scaleMove20020713.df$Partition), 
     pch = ".", col = "red",
     main = "Q-Q plot for comparing\nsampled distribution",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)
legend("topright", c("Scale move", "rgamma"), pch = 16, 
       col = c("#FF000055", "#0000FF55"), border = "#00000055", bty = "n")
dev.off()

scaleEst = var(scaleMove20020713.df$Partition)/mean(scaleMove20020713.df$Partition)
shapeEst = mean(scaleMove20020713.df$Partition)/scaleEst


scaleMove20020714.df =read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_gamma_2022_07_14.log",
                         header = T, as.is = T)

set.seed(123)
expt = rgamma(100001, shape = 2, rate = 2)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_14/test_scale_gamma_2022_07_14.pdf",
  width = 9, height = 4.5)
par(mfrow = c(1, 2))
hist(scaleMove20020714.df$parameter1.0, col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Comparing sampled distributions", xlab= "Values")
hist(expt, add = T, col = "#0000FF55", nclass = 50, prob = T, border = NA)
legend("topright", c("Scale move", "rgamma"), pch = 16, 
       col = c("#FF000055", "#0000FF55"), border = "#00000055", bty = "n")

plot(sort(expt), sort(scaleMove20020714.df$parameter1.0), 
     pch = ".", col = "red",
     main = "Q-Q plot for comparing\nsampled distribution",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)
dev.off()

pgamma(2.8, shape = 2, rate = 2)



scaleMove20020714v2.df =read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_gamma_2022_07_14_v2.log",
                                 header = T, as.is = T)

set.seed(123)
expt = rgamma(100001, shape = 2, rate = 2)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_14/test_scale_gamma_2022_07_14_v2.pdf",
    width = 9, height = 4.5)
par(mfrow = c(1, 2))
hist(scaleMove20020714v2.df$parameter1.0, col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Comparing sampled distributions", xlab= "Values")
hist(expt, add = T, col = "#0000FF55", nclass = 50, prob = T, border = NA)
legend("topright", c("Scale move", "rgamma"), pch = 16, 
       col = c("#FF000055", "#0000FF55"), border = "#00000055", bty = "n")

plot(sort(expt), sort(scaleMove20020714v2.df$parameter1.0), 
     pch = ".", col = "red",
     main = "Q-Q plot for comparing\nsampled distribution",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)
dev.off()

all(scaleMove20020714v2.df$parameter1.0 == scaleMove20020714.df$parameter1.0)




scaleMoveMultiParam20020714.df =read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_multi_gamma_2022_07_14.log",
                                 header = T, as.is = T)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_14/test_scale_multi_gamma_2022_07_14.pdf",
    width = 6.5, height = 9)
par(mfrow = c(3,2))
set.seed(123)
expt0 = rgamma(nrow(scaleMoveMultiParam20020714.df), shape = 0.5, rate = 1)
hist(scaleMoveMultiParam20020714.df$parameter1.0,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter index = 0, Gamma(0.5, 1)", xlab= "Values")
hist(expt0, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)

plot(sort(expt0), sort(scaleMoveMultiParam20020714.df$parameter1.0), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 0,\nGamma(0.5, 1)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)

set.seed(123)
expt1 = rgamma(nrow(scaleMoveMultiParam20020714.df), shape = 1, rate = 1/1.5)
hist(scaleMoveMultiParam20020714.df$parameter1.1,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter Index = 1, Gamma(1, 1.5)", xlab= "Values")
hist(expt1, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)

plot(sort(expt1), sort(scaleMoveMultiParam20020714.df$parameter1.1), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 1,\nGamma(1, 1.5)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)

set.seed(123)
expt2 = rgamma(nrow(scaleMoveMultiParam20020714.df), shape = 2, rate = 1/1.25)
hist(scaleMoveMultiParam20020714.df$parameter1.2,
     col = "#FF000055", nclass = 50, prob = T, border = NA,
     main = "Parameter Index = 2, Gamma(2, 1.25)", xlab= "Values")
hist(expt2, add = T, col = "#0000FF55", 
     nclass = 50, prob = T, border = NA)


plot(sort(expt2), sort(scaleMoveMultiParam20020714.df$parameter1.2), 
     pch = ".", col = "red",
     main = "Q-Q plot: parameter Index = 2,\nGamma(2, 1.25)",
     xlab = "Samples from rgamma in R", ylab = "Samples from MCMC with scale mov")
abline(0, 1)
dev.off()
