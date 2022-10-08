slvEstABv2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v2.log",
           as.is = T, header = T)

grep(slvEstABv2.df$typeList, pattern = "],[",fixed = T)

temp = sapply(slvEstABv2.df$typeList, function(z){ length(unlist(strsplit(z, split = "],[", fixed = T))) })
table(temp)

priorDensV2 = dexp(x = c(0:1000)/100, rate = 1)
bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  hist(slvEstABv2.df[, paste("shape.a", i,sep=".")], 
       prob = T, xlim = c(0, 10),
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 1)"),
       xlab = bquote(a[.(bfLabels[i+1])]), nclass = 30)
  lines(x = c(0:1000)/100, y = priorDensV2)
  legend("topright", c("prior", "posterior"), lty="solid",  lwd = c(1, 5),  col=c("black", "grey"), bty="n")
  hist(slvEstABv2.df[, paste("shape.b", i,sep=".")], 
       prob = T, xlim = c(0, 10),
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 1)"),
       xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 30)
  lines(x = c(0:1000)/100, y = priorDensV2)
  legend("topright", c("prior"), lty="solid", col="black", bty="n")
}


slvEstABv3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v3.log",
                           as.is = T, header = T)


temp = sapply(slvEstABv3.df$typeList, function(z){ length(unlist(strsplit(z, split = "],[", fixed = T))) })
table(temp)

priorDensV3 = dgamma(x = 10^(c(-1000:0)/100), shape = 0.01, rate = 0.01)
bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  hist(slvEstABv3.df[, paste("shape.a", i,sep=".")], 
       prob = T, xlim = c(0, 1),
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 1)"),
       xlab = bquote(a[.(bfLabels[i+1])]), nclass = 20000)
  lines(x = 10^(c(-1000:0)/100), y = priorDensV3, col = "red")
  legend("topright", c("prior", "posterior"), lty="solid",  lwd = c(1, 5),  col=c("red", "grey"), bty="n")
  hist(slvEstABv3.df[, paste("shape.b", i,sep=".")], 
       prob = T, xlim = c(0, 1),
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 1)"),
       xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 20000)
  lines(x = 10^(c(-1000:0)/100), y = priorDensV3, col = "red")
  legend("topright", c("prior"), lty="solid", col="red", bty="n")
}


slvEstABv5.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v5.log",
                           as.is = T, header = T)

priorDensV5 = dexp(x = c(0:500), rate = 0.01)
bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  hist(slvEstABv5.df[, paste("shape.a", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"), 
       xlim = c(0, 500),
       xlab = bquote(a[.(bfLabels[i+1])]), nclass = 30)
  lines(x = c(0:500), y = priorDensV5)
  legend("topright", c("prior", "posterior"), lty="solid",  lwd = c(1, 5),  col=c("black", "grey"), bty="n")
  hist(slvEstABv5.df[, paste("shape.b", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"),  xlim = c(0, 500),
       xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 30)
  lines(x = c(0:500), y = priorDensV5)
  legend("topright", c("prior"), lty="solid", col="black", bty="n")
}

temp = sapply(slvEstABv5.df$typeList, function(z){ length(unlist(strsplit(z, split = "],[", fixed = T))) })
table(temp)


slvEstABv6.2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v6.2.log",
                           as.is = T, header = T)

priorDensV6.2 = dexp(x = c(0:500), rate = 0.01)
bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  hist(slvEstABv6.2.df[, paste("shape.a", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"), 
       # = c(0, 500),
       xlab = bquote(a[.(bfLabels[i+1])]), nclass = 30)
  lines(x = c(0:500), y = priorDensV6.2)
  legend("topright", c("prior", "posterior"), lty="solid",  lwd = c(1, 5),  col=c("black", "grey"), bty="n")
  hist(slvEstABv6.2.df[, paste("shape.b", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"),  
       #xlim = c(0, 500),
       xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 30)
  lines(x = c(0:500), y = priorDensV6.2)
  legend("topright", c("prior"), lty="solid", col="black", bty="n")
}

par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  slvEstABv6.2ESSa = ESS(slvEstABv6.2.df[, paste("shape.a", i,sep=".")])
  slvEstABv6.2ESSb = ESS(slvEstABv6.2.df[, paste("shape.b", i,sep=".")])
  plot(slvEstABv6.2.df[, paste("shape.a", i,sep=".")], type="l",
       main = paste("ESS =", round(slvEstABv6.2ESSa, 1)))
  plot(slvEstABv6.2.df[, paste("shape.b", i,sep=".")], type="l",
       main = paste("ESS =", round(slvEstABv6.2ESSb, 1)))
}


for(i in 0:4){
  print(summary(slvEstABv6.2.df[, paste("shape.a", i,sep=".")]))
}

for(i in 0:4){
  print(summary(slvEstABv6.2.df[, paste("shape.b", i,sep=".")]))
}

par(mfrow = c(3,2))
for(i in 0:4){
  tempA = slvEstABv6.2.df[, paste("shape.a", i,sep=".")]
  tempB = slvEstABv6.2.df[, paste("shape.b", i,sep=".")]
  which(tempA/(tempA + tempB) == median(tempA/(tempA + tempB)))
  betaDens = dbeta(c(0:1000)/1000, shape1 = tempA[1698], shape2 = tempB[1698])
  plot(x =  c(0:1000)/1000, y = betaDens, type = "l",
       main = bquote("Exp(rate = 0.01), Marker group"~.(bfLabels[i+1])),
       xlab = expression(theta), ylab="density")
  print(summary(tempA/(tempA + tempB)))
}



ESS(slvEstABv6.2.df$shape.a.3[-c(1:200)])
plot(slvEstABv6.2.df$shape.a.3[-c(1:200)], type="l")


slvEstABv6.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v6.log",
                           as.is = T, header = T)

priorDensV5 = dexp(x = c(0:500), rate = 0.01)
bfLabels = c("CVF", "MTB", "SLV", "BLD", "SMN")
par(mfrow = c(5,2), mar = c(4,4,3,2)+0.2, lend = 2)
for(i in 0:4){
  hist(slvEstABv6.df[, paste("shape.a", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"), 
       # = c(0, 500),
       xlab = bquote(a[.(bfLabels[i+1])]), nclass = 30)
  lines(x = c(0:500), y = priorDensV5)
  legend("topright", c("prior", "posterior"), lty="solid",  lwd = c(1, 5),  col=c("black", "grey"), bty="n")
  hist(slvEstABv6.df[, paste("shape.b", i,sep=".")], prob = T,
       main = paste("Saliva: Prior = Gamma(shape = 1, rate = 0.01)"),  
       #xlim = c(0, 500),
       xlab = bquote(b[.(bfLabels[i+1])]) , nclass = 30)
  lines(x = c(0:500), y = priorDensV5)
  legend("topright", c("prior"), lty="solid", col="black", bty="n")
}


slvEstABv7.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/test_slv_single_7obs_part_shapeA_2022_09_15_v7.log",
                           as.is = T, header = T)
temp = sapply(slvEstABv7.df$typeList, function(z){ length(unlist(strsplit(z, split = "],[", fixed = T))) })
table(temp)
plot(temp)
