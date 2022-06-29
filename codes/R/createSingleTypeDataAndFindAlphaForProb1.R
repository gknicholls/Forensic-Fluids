library(salso)
source("forensicFunctions.R")

singleTypeFilePath = "data/data.csv"
single.df = read.csv(singleTypeFilePath, header = TRUE) # whole single sample data

cvfMkrs = c("CYP", "HBD1", "Lcris", "Lgas", "MUC4")
mtbMkrs = c("Hs202072", "LEFTY2", "MMP10", "MMP11", "MMP7", "MSX1", "SFRP4")
slvMkrs = c("HTN3", "MUC7", "PRB4", "SMR3B", "STATH")
bldMkrs = c("ALAS2", "GlycoA", "HBB", "PF4", "SPTB")
smnMkrs = c("MSMB", "PRM1", "PRM2", "SEMG1", "TGM4")
allMkrs = c(cvfMkrs, mtbMkrs, slvMkrs, bldMkrs, smnMkrs)
mkrList = list("cvf" = cvfMkrs, 
               "mtb" = mtbMkrs, 
               "slv" = slvMkrs, 
               "bld" = bldMkrs, 
               "smn" = smnMkrs)

cvf.df = single.df[single.df$Sample == 1, allMkrs] 
write.csv(cvf.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single.csv",
          quote = F, row.names = F)

mtb.df = single.df[single.df$Sample == 2, allMkrs] 
write.csv(mtb.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/mtb.single.csv",
          quote = F, row.names = F)

slv.df = single.df[single.df$Sample == 3, allMkrs] 
write.csv(slv.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
          quote = F, row.names = F)

bld.df = single.df[single.df$Sample == 4, allMkrs] 
write.csv(bld.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
          quote = F, row.names = F)

smn.df = single.df[single.df$Sample == 5, allMkrs] 
write.csv(smn.df, 
          file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv",
          quote = F, row.names = F)

J = 5
alpha = 0.49
n = 5
exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))


J = 7
alpha = 0.375
n = 7
exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))


J = 5
n = 32
counter = 1
for(alpha in  2245:2255){
  alpha = alpha/10000
  prob1n32[counter] = exp(lgamma(alpha) - lgamma(alpha/J) + 
                   lfactorial(J) - lfactorial(J - 1) +
                   lgamma(alpha/J + n) - lgamma(alpha + n))
  counter = counter + 1
}


J = 5
n = 65
alpha = 0.1894025
prob1n65 = exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))
prob1n65 - 0.5

J = 5
n = 73
alpha = 0.1845
prob1n73 = exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))
prob1n73 - 0.5

J = 5
n = 81
alpha = 0.18
prob1n81 = exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))
prob1n81 - 0.5

J = 5
n = 86
alpha = 0.178
prob1n86 = exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))
prob1n86 - 0.5