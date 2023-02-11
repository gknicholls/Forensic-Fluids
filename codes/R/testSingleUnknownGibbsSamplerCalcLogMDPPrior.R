X<-rbeta(100000, 2,3)
qtl<-pbeta(X, 2, 3)
Y<-qnorm(qtl, 2, 3)
hist(Y)

alpha = 0.6025
J = 5
K = 3
counts = c(8, 26, 25)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
part1 + part2 + part3

currLogMDPPrior = c(-47.26127067791871, -22.87807218558841, -76.70274010726419,
                    -41.53562408804975, -89.88950063110903)

alpha = 0.6025
K = 3
counts = c(31, 27, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3, digits=16)

alpha = 0.6025
K = 3
counts = c(31, 27, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-1]), digits=16)
# [1] -278.9327790446595


K = 3
counts = c(30, 28, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-1]), digits=16)
# [1] -279.0376951482387

K = 3
counts = c(30, 27, 2)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-1]), digits=16)
# [1] -282.2242100334603


K = 4
counts = c(30, 27, 1, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-1]), digits=16)
# [1] -283.7609433932106

################################################
alpha=0.725
K = 3
counts = c(25, 5, 2)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-2]), digits=16)
# [1] -278.5402353842051


K = 3
counts = c(24,  6,  2)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-2]), digits=16)
# [1] -280.0862873342446

K = 3
counts = c(24, 5, 3)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-2]), digits=16)
# [1] -280.9611731511506

K = 4
counts = c(24, 5, 2, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-2]), digits=16)
# [1] -282.9621870595322

################################################
alpha=0.55
K = 3
counts = c(49, 23,  9)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-3]), digits=16)
# [1] -278.2672076899302

K = 3
counts = c(48, 24,  9)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-3]), digits=16)
# [1] -279.5158203752669

K = 3
counts = c(48, 23,  10)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-3]), digits=16)
# [1] -280.4467130882813

K = 4
counts = c(48, 23,  9, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-3]), digits=16)
# [1] -284.1702135321829


################################################
alpha =  0.585
K = 3
counts = c(51, 14, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-4]), digits=16)
# [1] -278.5361944293055


K = 3
counts = c(50, 15, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-4]),  digits=16)
# [1] -279.8031749562952

K = 3
counts = c(50, 14, 2)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-4]), digits=16)
# [1] -282.3399081811102

K = 4
counts = c(50, 14, 1, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-4]), digits=16)
# [1] -283.9029888648216


################################################
alpha = 0.525
K = 3
counts = c(41, 34, 12)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-5]), digits=16)
# [1] -279.0361400646326


K = 3
counts = c(40, 35, 12)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-5]), digits=16)
# [1] -279.1981970783448

K = 3
counts = c(40, 34, 13)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-5]), digits=16)
# [1] -280.2340224890614

K = 4
counts = c(40, 34, 12, 1)
tot = sum(counts)
part1 = lgamma(alpha) - (K*lgamma(alpha/J))
part2 = lfactorial(J) - lfactorial(J - K)
part3 = sum(lgamma(alpha/J + counts)) - lgamma(alpha + tot)
print(part1 + part2 + part3 + sum(currLogMDPPrior[-5]), digits=16)
# [1] -284.2882888277161
