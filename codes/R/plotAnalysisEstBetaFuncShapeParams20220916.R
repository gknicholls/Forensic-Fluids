library(TeachingDemos)

abPostDistr = function(data.df = NULL, fluidType = NULL){
  priorDensV6.2 = dgamma(x = 10^c(c(-1000:10)/10), shape=0.01, rate = 0.01)
  bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
  par(mfrow = c(5,2), mar = c(4,4,3,2) + 0.2, lend = 2)
  
  for(i in 0:4){
    hist(data.df[, paste("shape.a", i,sep=".")], prob = T, las = 1,
         main = paste(paste("Sample type = ", fluidType, sep = ""),
                      "Prior: Gamma(shape = rate = 0.01)", sep="\n"), 
         xlab = bquote(a[.(bfLabels[i+1])]), nclass = 100)
    lines(x = 10^c(c(-1000:10))/10, y = priorDensV6.2, col="red")
    legend("topright", c("prior", "posterior"), 
           lty ="solid",  lwd = c(1, 5),  
           col=c("red", "grey"), bty="n")
    
    hist(data.df[, paste("shape.b", i,sep=".")], prob = T,las = 1,
         main =  paste(paste("Sample type = ", fluidType, sep = ""),
                       "Prior: Gamma(shape = rate = 0.01)", sep="\n"),  
         xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 100)
    lines(x = 10^c(c(-1000:10))/10, y = priorDensV6.2, col="red")
    legend("topright", c("prior", "posterior"), 
           lty ="solid",  lwd = c(1, 5),  
           col=c("red", "grey"), bty="n")
  }
  
}


tracePlot = function(variable = NULL, fluidType = NULL, traceLabel = NULL, burninRemoved = F){
  essVal = ESS(variable)
  burninLabel = ""
  if(burninRemoved){
    burninLabel = "\n(burn-in removed)"
  }
  par(mar = c(4,4,4,2) + 0.2, lend = 2)
  plot(variable, type="l", 
       ylab = traceLabel, xlab = "MCMC steps (1000s)",
       main = paste(paste(fluidType, burninLabel, sep=""), 
                    paste("ESS = ", round(essVal, 2), sep = ""), sep="\n"))
}

abTrace = function(data.df = NULL, 
                        bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN"),
                        fluidType = NULL){
  
  par(mfrow = c(5,2), mar = c(4,4,3,2) + 0.2, lend = 2)
  for(i in 0:4){
    aESS = ESS(data.df[, paste("shape.a", i, sep=".")])
    bESS = ESS(data.df[, paste("shape.b", i, sep=".")])
    
    plot(data.df[, paste("shape.a", i, sep=".")], type="l", las = 1,
         main = paste(paste("Sample type = ", fluidType, sep = ""), 
                      paste( "(ESS = ", round(aESS, 2), ")", sep=""), sep = "\n"),
         xlab = "MCMC step (1000s)", ylab = bquote(a[.(bfLabels[i + 1])]) )
    
    plot(data.df[, paste("shape.b", i, sep=".")], type="l", las = 1,
         main = paste(paste("Sample type = ", fluidType, sep = ""), 
                      paste( "(ESS = ", round(bESS, 2), ")", sep=""), sep = "\n"),
         xlab = "MCMC step (1000s)", ylab = bquote(b[.(bfLabels[i + 1])]))
  }
  
}


abPriorTrace = function(data.df = NULL, 
                   bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN"),
                   fluidType = NULL){
  
  par(mfrow = c(5,2), mar = c(4,4,3,2) + 0.2, lend = 2)
  for(i in 0:4){
    a.gamma.ESS = ESS(data.df[, paste("gammaPrior.a", i, sep="")])
    b.gamma.ESS = ESS(data.df[, paste("gammaPrior.b", i, sep="")])
    plot(data.df[, paste("gammaPrior.a", i, sep="")], 
         type="l", xlab = "MCMC step (1000s)", las = 1,
         ylab = bquote(a[.(bfLabels[i + 1])]~"Prior"),
         main = paste(paste("Sample type = ", fluidType, sep = ""), 
                      paste( "(ESS = ", round(a.gamma.ESS, 2), ")", sep=""), sep = "\n"))
    plot(data.df[, paste("gammaPrior.b", i, sep="")], 
         type="l", xlab = "MCMC step (1000s)", las = 1,
         ylab = bquote(a[.(bfLabels[i + 1])]~"Prior"),
         main = paste(paste("Sample type = ", fluidType, sep = ""), 
                      paste( "(ESS = ", round(b.gamma.ESS, 2), ")", sep=""), sep = "\n"))
  }
  
}

betaPriorRep = function(data.df = NULL,
                        bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN"),
                        fluidType = NULL){
  
  par(mfrow = c(3,2), mar = c(4,4, 3,2) + 0.2, lend = 2)
  for(i in 0:4){
    tempA = data.df[, paste("shape.a", i, sep=".")]
    tempB = data.df[, paste("shape.b", i, sep=".")]
    betaMean = median(tempA/(tempA + tempB))
    betaVar = median(tempA*tempB/((tempA + tempB)^2*(tempA + tempB + 1)))
    
    medIndex = which.min(abs(tempA/(tempA + tempB) - betaMean) + 
                           abs(tempA*tempB/((tempA + tempB)^2*(tempA + tempB + 1)) - betaVar))
    betaDens = dbeta(c(0:1000)/1000, 
                     shape1 = tempA[medIndex], shape2 = tempB[medIndex])
    
    plot(x =  c(0:1000)/1000, y = betaDens, type = "l",
         main = bquote("Gamma(shape = rate = 0.01), Marker group"~.(bfLabels[i+1])),
         xlab = expression(theta), ylab = expression("Represented"~beta~"density"))
    print(summary(tempA/(tempA + tempB)))
  }
  
}


shapePostStats = function(data.df = NULL){
  shapeSumStats = matrix(nrow = 10, ncol = 8)
  for(i in 0:4){
    shapeSumStats[2*i + 1,] = c(summary(data.df[,paste("shape.a.", i, sep="")]), 
                               emp.hpd(data.df[,paste("shape.a.", i, sep="")]))
    shapeSumStats[2*i + 2,] = c(summary(data.df[,paste("shape.b.", i, sep="")]),
                               emp.hpd(data.df[,paste("shape.b.", i, sep="")]))
  }
  colnames(shapeSumStats) = c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.", 
                               "95% HPD lower", "95% HPD upper")
 
  rownames(shapeSumStats) = rep(c("CVF", "MTB", "SLV", "BLD", "SMN"), rep(2,5))
  
  return(shapeSumStats)
  
}


cvf.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single_noAll0s.csv",
         header = T, as.is = T)
which(rowSums(cvf.df)==0)
cvf.df[which(rowSums(cvf.df)==0),]


estBetaAB.cvf.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_cvf_single_estBetaShapes_2022_09_16.log",
                             as.is = T, header = T)
dim(estBetaAB.cvf.df)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/cvf_post_trace_2022_09_16.pdf",
    height = 4.5, width = 10)
par(mfrow  = c(1,2), mar = c(5, 4, 3, 2) + 0.2)
tracePlot(variable = estBetaAB.cvf.df$log.posterior, 
          fluidType = "Cervical fluid", 
          traceLabel = "log(Posterior)")
estBetaAB.cvf.df = estBetaAB.cvf.df[-c(1:10),]
tracePlot(variable = estBetaAB.cvf.df$log.posterior, 
          fluidType = "Cervical fluid", 
          traceLabel = "log(Posterior)", burninRemoved= T)
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/cvf_ab_post_distr_cvf_2022_09_16.pdf",
    height = 12, width = 8)
abPostDistr(data.df = estBetaAB.cvf.df, fluidType = "Cervical fluid")
dev.off()

cvf.stats = signif(shapePostStats(estBetaAB.cvf.df)[,c("Mean",  "Median", "Min.", "Max.", 
                                          "95% HPD lower", "95% HPD upper")], 3)
cbind(cvf.stats[,c(1,2)],
      apply(cvf.stats[,c(3,4)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}),
apply(cvf.stats[,c(5,6)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/cvf_ab_trace_2022_09_16.pdf",
    height = 12, width = 8)
abTrace(data.df = estBetaAB.cvf.df, fluidType = "Cervical fluid")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/cvf_ab_prior_2022_09_16.pdf",
    height = 12, width = 8)
abPriorTrace(data.df = estBetaAB.cvf.df, fluidType = "Cervical fluid")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/cvf_beta_rep_2022_09_16.pdf",
    height = 8.5, width = 8)
betaPriorRep(data.df = estBetaAB.cvf.df, fluidType = "Cervical fluid")
dev.off()



estBetaAB.mtb.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_mtb_single_estBetaShapes_2022_09_16.log",
                              as.is = T, header = T)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/mtb_post_trace_2022_09_16.pdf",
    height = 4.5, width = 5)
par(mfrow  = c(1,1), mar = c(5, 4, 4, 2) + 0.2)
tracePlot(variable = estBetaAB.mtb.df$log.posterior, 
          fluidType = "Menstrual blood", 
          traceLabel = "log(Posterior)")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/mtb_ab_post_distr_2022_09_16.pdf",
    height = 12, width = 8)
abPostDistr(data.df = estBetaAB.mtb.df, fluidType = "Menstrual blood")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/mtb_ab_2022_09_16.pdf",
    height = 12, width = 8)
abTrace(data.df = estBetaAB.mtb.df, fluidType = "Menstrual blood")
dev.off()

mtb.stats = signif(shapePostStats(estBetaAB.mtb.df)[,c("Mean",  "Median", "Min.", "Max.", 
                                                       "95% HPD lower", "95% HPD upper")], 3)
cbind(mtb.stats[,c(1,2)],
      apply(mtb.stats[,c(3,4)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}),
      apply(mtb.stats[,c(5,6)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/mtb_ab_prior_2022_09_16.pdf",
    height = 12, width = 8)
abPriorTrace(data.df = estBetaAB.mtb.df, fluidType = "Menstrual blood")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/mtb_beta_rep_2022_09_16.pdf",
    height = 8.5, width = 8)
betaPriorRep(data.df = estBetaAB.mtb.df, fluidType = "Menstrual blood")
dev.off()


estBetaAB.slv.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_slv_single_estBetaShapes_2022_09_16.log",
  as.is = T, header = T)

estBetaAB.slv.df = estBetaAB.slv.df[-c(1:500),]

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/slv_post_trace_2022_09_16.pdf",
    height = 4.5, width = 10)
par(mfrow  = c(1,2), mar = c(5, 4, 4, 2) + 0.2)
tracePlot(variable = estBetaAB.slv.df$log.posterior, 
          fluidType = "Saliva", 
          traceLabel = "log(Posterior)", burninRemoved= T)
tracePlot(variable = estBetaAB.slv.df$multitypeLikelihood, 
          fluidType = "Saliva", 
          traceLabel = "log(Likelihood)")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/slv_ab_post_distr_2022_09_16.pdf",
    height = 12, width = 8)
abPostDistr(data.df = estBetaAB.slv.df, fluidType = "Saliva")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/slv_ab_trace_2022_09_16.pdf",
    height = 12, width = 8)
abTrace(data.df = estBetaAB.slv.df, fluidType = "Saliva")
dev.off()

slv.stats = signif(shapePostStats(estBetaAB.slv.df)[,c("Mean",  "Median", "Min.", "Max.", 
                                                       "95% HPD lower", "95% HPD upper")], 3)
cbind(slv.stats[,c(1,2)],
      apply(slv.stats[,c(3,4)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}),
      apply(slv.stats[,c(5,6)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/slv_ab_prior_2022_09_16.pdf",
    height = 12, width = 8)
abPriorTrace(data.df = estBetaAB.slv.df, fluidType = "Saliva")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/slv_beta_rep_2022_09_16.pdf",
    height = 10, width = 8)
betaPriorRep(data.df = estBetaAB.slv.df, fluidType = "Saliva")
dev.off()



estBetaAB.bld.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_bld_single_estBetaShapes_2022_09_16.log",
             as.is = T, header = T)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/bld_post_trace_2022_09_16.pdf",
    height = 4.5, width = 10)
par(mfrow  = c(1,2), mar = c(5, 4, 4, 2) + 0.2)
tracePlot(variable = estBetaAB.bld.df$log.posterior, 
          fluidType = "Blood", 
          traceLabel = "log(Posterior)")
tracePlot(variable = estBetaAB.slv.df$multitypeLikelihood, 
          fluidType = "Blood", 
          traceLabel = "log(Likelihood)", burninRemoved= T)
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/bld_ab_post_distr_2022_09_16.pdf",
    height = 12, width = 8)
abPostDistr(data.df = estBetaAB.bld.df, fluidType = "Blood")
dev.off()

bld.stats = signif(shapePostStats(estBetaAB.bld.df)[,c("Mean",  "Median", "Min.", "Max.", 
                                                       "95% HPD lower", "95% HPD upper")], 3)
cbind(bld.stats[,c(1,2)],
      apply(bld.stats[,c(3,4)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}),
      apply(bld.stats[,c(5,6)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}))


pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/bld_ab_trace_2022_09_16.pdf",
    height = 12, width = 8)
abTrace(data.df = estBetaAB.bld.df, fluidType = "Blood")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/bld_ab_prior_2022_09_16.pdf",
    height = 12, width = 8)
abPriorTrace(data.df = estBetaAB.bld.df, fluidType = "Blood")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/bld_beta_rep_2022_09_16.pdf",
    height = 10, width = 8)
betaPriorRep(data.df = estBetaAB.bld.df, fluidType = "Blood")
dev.off()



estBetaAB.smn.df = 
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_smn_single_estBetaShapes_2022_09_16.log",
             as.is = T, header = T)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/smn_post_trace_2022_09_16.pdf",
    height = 4.5, width = 5)
par(mfrow  = c(1,1), mar = c(5, 4, 4, 2) + 0.2)
tracePlot(variable = estBetaAB.smn.df$log.posterior, 
          fluidType = "Semen", 
          traceLabel = "log(Posterior)")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/smn_ab_post_distr_2022_09_16.pdf",
    height = 12, width = 8)
abPostDistr(data.df = estBetaAB.smn.df, fluidType = "Semen")
dev.off()

smn.stats = signif(shapePostStats(estBetaAB.smn.df)[,c("Mean",  "Median", "Min.", "Max.", 
                                                       "95% HPD lower", "95% HPD upper")], 3)
cbind(smn.stats[,c(1,2)],
      apply(smn.stats[,c(3,4)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}),
      apply(smn.stats[,c(5,6)], 1, function(z){paste("(", z[1], ",", z[2], ")", sep="")}))

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/smn_ab_trace_2022_09_16.pdf",
    height = 12, width = 8)
abTrace(data.df = estBetaAB.smn.df, fluidType = "Semen")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/smn_ab_prior_2022_09_16.pdf",
    height = 12, width = 8)
abPriorTrace(data.df = estBetaAB.smn.df, fluidType = "Semen")
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/smn_beta_rep_2022_09_16.pdf",
    height = 10, width = 8)
betaPriorRep(data.df = estBetaAB.smn.df, fluidType = "Semen")
dev.off()


off.diag.a = rbind(cvf.stats[c(0:4)*2+1,c(5,6)][-1,],
      mtb.stats[c(0:4)*2+1,c(5,6)][-c(1,2,4),],
      slv.stats[c(0:4)*2+1,c(5,6)][-3,],
      bld.stats[c(0:4)*2+1,c(5,6)][-4,],
      smn.stats[c(0:4)*2+1,c(5,6)][-5,])

off.diag.b = rbind(cvf.stats[c(0:4)*2+2,c(5,6)][-1,],
                   mtb.stats[c(0:4)*2+2,c(5,6)][-c(1,2,4),],
                   slv.stats[c(0:4)*2+2,c(5,6)][-3,],
                   bld.stats[c(0:4)*2+2,c(5,6)][-4,],
                   smn.stats[c(0:4)*2+2,c(5,6)][-5,])

range(off.diag.a)

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_09_16/off_diag_ab_95_BCI.pdf",
    height = 8, width = 8)
par(mfrow = c(2, 2))
plot(1,1, type="n", xlim = c(1,18), ylim = range(off.diag.a),
     xlab = "Off-diagonal blocks", ylab = "shape a values",
     main = "95% BCI")
for(i in 1:18){
  lines(x = c(i, i), y= off.diag.a[i,])
}
abline(h = 0.174, col = "red")
abline(h = 0.1, col = "blue", lty="dashed")

plot(1,1, type="n", xlim = c(1,18), ylim = log(range(off.diag.a)),
     xlab = "Off-diagonal blocks", ylab = "log(shape a values)",
     main = "log(95% BCI)")
for(i in 1:18){
  lines(x = c(i, i), y= log(off.diag.a[i,]))
}
abline(h = -1.75, col = "red")
abline(h = log(0.1), col = "blue", lty="dashed")



plot(1,1, type="n", xlim = c(1,18), ylim = range(off.diag.b),
     xlab = "Off-diagonal blocks", ylab = "shape b values",
     main = "95% BCI")
for(i in 1:18){
  lines(x = c(i, i), y= (off.diag.b[i,]))
}
abline(h = exp(-0.214), col = "red")
abline(h = 1, col = "blue", lty="dashed")

plot(1,1, type="n", xlim = c(1,18), ylim = log(range(off.diag.b)),
     xlab = "Off-diagonal blocks", ylab = "log(shape b values)",
     main = "log(95% BCI)")
for(i in 1:18){
  lines(x = c(i, i), y= log(off.diag.b[i,]))
}

abline(h = -0.214, col = "red")
abline(h = log(1), col = "blue", lty="dashed")
dev.off()
