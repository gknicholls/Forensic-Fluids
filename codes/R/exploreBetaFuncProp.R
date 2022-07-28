
x = c(-100:20)/10
y1= list()
for(j in 1:3){
  y1[[j]] = matrix(nr = length(x), nc = length(x))
  for(i in 1:length(x)){
    y1[[j]][i,] = beta(10^x[i] + 8*j*3*5, 10^x+j*3*5)
  }
}

y2= list()
for(j in 1:3){
  y2[[j]] = matrix(nr = length(x), nc = length(x))
  for(i in 1:length(x)){
    y2[[j]][i,] = beta(10^x[i]+j*3*5, 10^x+ 8*j*3*5)
  }
}

y3 = list()
for(j in 1:3){
  y3[[j]] = matrix(nr = length(x), nc = length(x))
  for(i in 1:length(x)){
    y3[[j]][i,] = 10*log(beta(10^x[i]+5*j*3*5, 10^x+ 5*j*3*5))
  }
}

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_15/investigateBeta.pdf",
    width = 6, height = 9)
par(mfrow = c(3,2), mar = c(4,4,4,1)+0.2, las = 1)
image((y1[[1]]), main = "#1's = 120, #0's 15\n(27 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
image((y2[[1]]), main = "#1's = 15, #0's 120\n(27 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))

image((y1[[2]]), main = "#1's = 240, #0's 30\n(54 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))

image((y2[[2]]), main = "#1's = 30, #0's 240\n(54 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))

image((y1[[3]]), main = "#1's = 360, #0's 45\n(81 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
image((y2[[3]]), main = "#1's = 45, #0's 360\n(81 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
dev.off()

pdf(file = "/Users/chwu/Documents/research/bfc/plots/2022_07_19/investigateBeta_5050.pdf",
    width = 6, height = 9)
par(mfrow = c(2,2), mar = c(4,4,4,1)+0.2, las = 1)
image((y3[[1]]), main = "#1's = 75, #0's 75\n(81 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
image((y3[[2]]), main = "#1's = 150, #0's 150\n(81 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
image((y3[[3]]), main = "#1's = 225, #0's 225\n(81 rows, 5 columns)", 
      xaxt = "n", yaxt = "n", xlab = "log10(a)", ylab = "log10(b)")
axis(side = 1, at = 1/13*c(0:12), label= c(-10:2))
axis(side = 2, at = 1/13*c(0:12), label= c(-10:2))
dev.off()