cvf.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single.csv", 
                  header = T, as.is = T)
table(rowSums(cvf.df))
mtb.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/mtb.single.csv", 
                  header = T, as.is = T)
table(rowSums(mtb.df))
slv.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv", 
                  header = T, as.is = T)
table(rowSums(slv.df))
bld.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv", 
                  header = T, as.is = T)
table(rowSums(bld.df))
smn.df = read.csv(file = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv", 
                  header = T, as.is = T)
table(rowSums(smn.df))


ex.missing_obsCount_probs_equal.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_equal.log.ops",
           header = F, as.is = T, sep="\t")
ex.missing_obsCount_probs_rdm1.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_rdm1.log.ops",
             header = F, as.is = T, sep="\t")
ex.missing_obsCount_probs_rdm2.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/ex.missing_obsCount_2022_09_09_probs_rdm2.log.ops",
             header = F, as.is = T, sep="\t")
slv_typical_unknown_5type.ops.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_typical_unknown_5type_2022_09_09.log.ops",
             header = F, as.is = T, sep="\t")
slv_atypical_v1_unknown_5type.log.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_atypical_v1_unknown_5type_2022_09_09.log.ops",
             header = F, as.is = T, sep="\t")
slv_atypical_v2_unknown_5type.log.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_09/slv_atypical_v2_unknown_5type_2022_09_09.log.ops",
             header = F, as.is = T, sep="\t")
all0s_5type.log.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all0s_5type_2022_09_10.log.ops",
             header = F, as.is = T, sep="\t")
all1s_5type.log.df =
  read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all1s_5type_2022_09_10.log.ops",
             header = F, as.is = T, sep="\t")

analysisLabel = 
  c("Missing profile (equal prior)",
  "Missing profile (abituray prior ver. 1)",
  "Missing profile (abituray prior ver. 2)",
  "Synthetic profile typical saliva training",
  "Synthetic profile atypical saliva training (ver. 1)",
  "Synthetic profile atypical saliva training (ver. 2)",
  "All-zero profile",
  "All-one profile")
getAcceptProb = function(data){
  accProbs = data[,2]/(data[,2]+data[,3])
  names(accProbs) = data[,1]
  return(accProbs)
}

data.frame(analysis = analysisLabel, 
      rbind(getAcceptProb(ex.missing_obsCount_probs_equal.df),
            getAcceptProb(ex.missing_obsCount_probs_rdm1.df),
            getAcceptProb(ex.missing_obsCount_probs_rdm2.df),
            getAcceptProb(slv_typical_unknown_5type.ops.df),
            getAcceptProb(slv_atypical_v1_unknown_5type.log.df),
            getAcceptProb(slv_atypical_v2_unknown_5type.log.df),
            getAcceptProb(all0s_5type.log.df),
            getAcceptProb(all1s_5type.log.df))
)

