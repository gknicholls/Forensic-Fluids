## Thursday 15 September 2022

slv_typical_v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_typical_unknown_5type_2022_09_10.log",
                        header = T, as.is =T, sep = "\t")
slv_typical_v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_typical_unknown_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(slv_typical_v2.df ), 
       function(z){
         all(slv_typical_v2.df[,z] == slv_typical_v3.df [,z])
       }
)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE


slv_atypicalv1_v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_atypical_v1_unknown_5type_2022_09_10.log",
                               header = T, as.is =T, sep = "\t")
slv_atypicalv1_v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_atypical_v1_unknown_5type_2022_09_15.log",
                               header = T, as.is =T, sep = "\t")

sapply(1:ncol(slv_atypicalv1_v2.df), 
       function(z){
         all(slv_atypicalv1_v2.df[,z] == slv_atypicalv1_v3.df[,z])
       }
)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE


slv_atypicalv2_v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/slv_atypical_v2_unknown_5type_2022_09_10.log",
                                  header = T, as.is =T, sep = "\t")
slv_atypicalv2_v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/slv_atypical_v2_unknown_5type_2022_09_15.log",
                                  header = T, as.is =T, sep = "\t")

sapply(1:ncol(slv_atypicalv2_v2.df), 
       function(z){
         all(slv_atypicalv2_v2.df[,z] == slv_atypicalv2_v3.df[,z])
       }
)
# [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE


all0s_5type_v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all0s_5type_2022_09_10.log",
                        header = T, as.is =T, sep = "\t")

all0s_5type_v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/all0s_5type_2022_09_15.log",
                        header = T, as.is =T, sep = "\t")

sapply(1:ncol(all0s_5type_v2.df), 
       function(z){
         all(all0s_5type_v2.df[,z] == all0s_5type_v3.df[,z])
       }
)
#[1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE


all1s_5type_v2.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_10/all1s_5type_2022_09_10.log",
                               header = T, as.is =T, sep = "\t")

all1s_5type_v3.df = read.table(file = "/Users/chwu/Documents/research/bfc/output/2022_09_15/all1s_5type_2022_09_15.log",
                               header = T, as.is =T, sep = "\t")

sapply(1:ncol(all1s_5type_v2.df), 
       function(z){
         all(all1s_5type_v2.df[,z] == all1s_5type_v3.df[,z])
       }
)
