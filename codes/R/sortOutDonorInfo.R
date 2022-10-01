single.df = read.csv(file = "/Users/chwu/Downloads/forensic_data/mRNA_single source samples_2019.csv", header = T, as.is = T)
singleThreshold.df = read.csv(file = "/Users/chwu/Downloads/forensic_data/mRNASingleThreshold.csv", header = T, as.is = T)
dummyMarkerIndex = c(grep(names(single.df), pattern = "TEF"),
                     grep(names(single.df), pattern = "UCE"))
dummyThresholdIndex = c(grep(singleThreshold.df$marker, pattern = "TEF"),
                     grep(singleThreshold.df$marker, pattern = "UCE"))
names(single.df)[dummyMarkerIndex]
singleThreshold.df$marker[dummyThresholdIndex]
single1.df = single.df[, -dummyMarkerIndex]
singleThreshold1.df = singleThreshold.df[-dummyThresholdIndex ,]
singleBin.df = single1.df
for(i in 1:nrow(singleThreshold1.df)){
  lessThresholdIndex = which(singleBin.df[, singleThreshold1.df[i,1]] < singleThreshold1.df[i,2])
  naThresholdIndex = which(is.na(singleBin.df[, singleThreshold1.df[i,1]]))
  singleBin.df[lessThresholdIndex,singleThreshold1.df[i,1]] = 0
  singleBin.df[naThresholdIndex,singleThreshold1.df[i,1]] = 0
  
  meetThresholdIndex = which(singleBin.df[, singleThreshold1.df[i,1]] >= singleThreshold1.df[i,2])
  singleBin.df[meetThresholdIndex, singleThreshold1.df[i,1]] = 1
  
}

colSums(singleBin.df[,-c(1,2)])

singleBin.df$Type[which(rowSums(singleBin.df[,-c(1,2)]) == 0)]
single1.df[which(rowSums(singleBin.df[,-c(1,2)]) == 0),]
t(singleThreshold1.df)

singleBin.df[-which(rowSums(singleBin.df[,-c(1,2)]) == 0),]
singleBin.df = singleBin.df[-which(rowSums(singleBin.df[,-c(1,2)]) == 0),]

which(rowSums(singleBin.df[,-c(1,2)]) == 0)
table(singleBin.df$Type)

write.csv(singleBin.df,
          file = "/Users/chwu/Downloads/forensic_data/mRNA_single_2019_binary.csv",
          quote = F, row.names = F, col.names = T)


blood.diff.donor = c("Bl1_RTP", "Bl2_RTP", "Bl3_RTP", "Bl4_RTP", "Bl5_RTP", "Bl6_RTP", "Bl7_RTP", "Bl8_RTP", 
  "Bl9_RTP", "Bl10_RTP", "Bl11_RTP", "Bl12_RTP", "Bl13_RTP", "Bl14_RTP", "Bl15_RTP", 
  "Bl16_RTP", "Bl17_RTP", "Bl18_RTP", "Bl19_RTP", "Bl20_RTP", "Bl21_RTP")
singleBin.df$donor = rep(NA, nrow(singleBin.df))
singleBin.df$donor[match(blood.diff.donor, singleBin.df$Sample)] = paste("blood", c(1:length(blood.diff.donor )), sep="")

blood.same.donor1 = c("5ul blood_SS III", "5ul blood_SS IV", "5ul blood_quantitect RT", "1ul blood_SS III", 
                      "1ul blood_SS IV", "1ul blood_quantitect RT")
singleBin.df$donor[match(blood.same.donor1, singleBin.df$Sample)] = 
  paste("blood", (length(blood.diff.donor ) + 1), sep="")

blood.same.donor2 = c("10Blfabric_RTP", "5Blfabric_RTP", "3Blfabric_RTP", "1Blfabric_RTP", "10Bltaped fabric_RTP", 
"5Bltaped fabric_RTP", "3Bltaped fabric_RTP", "1Bltaped fabric_RTP", "10Blfabric_RTP", 
"5Blfabric_RTP", "3Blfabric_RTP", "1Blfabric_RTP", "10Bltaped fabric_RTP", "5Bltaped fabric_RTP", 
"3Bltaped fabric_RTP", "1Bltaped fabric_RTP")

singleBin.df$donor[!is.na(match(singleBin.df$Sample, blood.same.donor2))] = 
  paste("blood", (length(blood.diff.donor ) + 2), sep="")

singleBin.df$donor[singleBin.df$Sample=="3Bl_RTP"] = 
  paste("blood", (length(blood.diff.donor ) + 3), sep="")

singleBin.df$donor[singleBin.df$Sample=="3EDTA_Bl_RTP"] = 
  paste("blood", (length(blood.diff.donor ) + 4), sep="")


singleBin.df$donor[singleBin.df$Sample=="1_RTP"] = 
  paste("blood", (length(blood.diff.donor ) + c(5, 6)), sep="")



singleBin.df$donor[singleBin.df$Sample=="5ul Bl swab"] = 
  paste("blood", (length(blood.diff.donor ) + 7), sep="")

blood.same.donor3 = c("17Oct18_15bl_1_RTP", "17Oct18_15bl_2_RTP", "17Oct18_15bl_3_RTP", 
                      "17Oct18_1bl_4_RTP", "17Oct18_1bl_5_RTP", "17Oct18_1bl_6_RTP")

singleBin.df$donor[match(blood.same.donor3, singleBin.df$Sample)] = 
  paste("blood", (length(blood.diff.donor ) + 8), sep="")

singleBin.df$donor[singleBin.df$Sample=="1ul Bl directly into tube"] = 
  paste("blood", (length(blood.diff.donor ) + 9), sep="")
singleBin.df$donor[singleBin.df$Sample=="2ul Bl directly into tube"] = 
  paste("blood", (length(blood.diff.donor ) + 9), sep="")

singleBin.df$donor[singleBin.df$Sample=="2_Feb training"] = 
  paste("blood", (length(blood.diff.donor ) + 10), sep="")

singleBin.df$Sample[singleBin.df$Type=="Blood"][which(is.na(singleBin.df$donor[singleBin.df$Type=="Blood"]))]
singleBin.df$donor[singleBin.df$Type=="Blood"]


##############################################################################
##############################################################################
## These buccal swab samples were part of two MSc projects (J and F).
## The samples were taken and extracted in 2011 (F) and 2012 (J) and then and were taken and processed in different years.
## These results were obtained by retesting the frozen extracts in 2017.
## The samples were taken and extracted in small batches.  There will be some overlap of donors between the F & J groups.
## Within a group the majority of the samples will be from different donors.

saliva.diff.donor1 = c("10BuccalJ", "11BuccalF", "11BuccalJ", "12BuccalF", "12BuccalJ", "13BuccalF", "14BuccalF", 
"15BuccalF", "16BuccalF", "17BuccalF", "18BuccalF", "19BuccalF", "20BuccalF", "21BuccalF", 
"22BuccalF", "23BuccalF", "24BuccalF", "25BuccalF", "26BuccalF", "27BuccalF", "28BuccalF", 
"30BuccalJ", "4BuccalF", "5BuccalF", "5BuccalJ", "6BuccalF", "6BuccalJ", "7BuccalF", 
"7BuccalJ", "8BuccalF", "8BuccalJ", "9BuccalJ")
saliva.diff.donor1[is.na(match(saliva.diff.donor1, singleBin.df$Sample))]
#"20BuccalF" not present in the dataset (possibly the all zero profile)
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.diff.donor1))] = 
  paste("saliva", 1:(length(saliva.diff.donor1) - 1), sep="")

## fresh buccal swabs, different donors for each swab
saliva.diff.donor2 = c("buccal1", "buccal2", "buccal3", "buccal4", 
                       "buccal5", "buccal6", "buccal7", "buccal8")
saliva.diff.donor2[is.na(match(saliva.diff.donor2, singleBin.df$Sample))]
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.diff.donor2))] = 
  paste("saliva", 1:length(saliva.diff.donor2) + (length(saliva.diff.donor1) - 1), sep="")

## 10 ul saliva seeded onto a swab - processed the same day
singleBin.df$donor[singleBin.df$Sample == "AB1_RTP_MB"] = "saliva40"

saliva.same.donor1 = 
  c("BC1_RTP_MB", "BC2_RTP_MB", "BC3_RTP_MB", "BC4_RTP_MB", 
    "BC5_RTP_MB", "BC6_RTP_MB", "BC7_RTP_MB", "BC8_RTP_MB")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor1))] = "saliva41"

# These samples would have all been from the same donor.
# The  swab was dried and then processed in the lab the same day as the sample was collected.  
# This experiment was to test one of the enzymes used in the lab.  
#SS III samples are the same enzyme (all the other sample on the list were processed with this enzyme) SSIV are the same enzyme and quantitect are processed with the same enzyme. 
saliva.same.donor2 = c("buccal_SS III",
                       "buccal_SS IV",
                       "buccal_quantitect RT")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor2))] = "saliva42"

singleBin.df$donor[singleBin.df$Sample == "6_10ul saliva"] = "saliva43"

# 6810-6815  10 ul of saliva seeded directly onto mini-tape.  
# same donor for all samples but donor unique to this set of samples
saliva.same.donor3 = c("6810_RTP", "6811_RTP", "6812_RTP", 
                       "6813_RTP", "6814_RTP", "6815_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor3))] = "saliva44"

# 10 ul of saliva seeded onto cotton fabric, dried overnight and then mini-taped - tapes extracted.
# Samples were stored at room temperature for ~6 months prior to processing 
# same donor for all samples but donor unique to this set of samples
saliva.same.donor4 = c("96816_RTP", "96817_RTP", "96818_RTP", "96819_RTP", "96820_RTP", "96821_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor4))] = "saliva45"

singleBin.df$donor[singleBin.df$Sample == "10ul Sal_23Feb"] = "saliva46"

# 10 ul of saliva onto mini-tape, dried and then extracted same day
# 5 ul of saliva onto mini-tape, dried and then extracted same day
saliva.same.donor5 = c("10Satape_RTP", "5Satape_RTP")

singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor5))] = "saliva47"

singleBin.df$donor[singleBin.df$Sample == "2_RTP" & singleBin.df$Type=="Saliva"] = "saliva48"
singleBin.df$donor[singleBin.df$Sample == "4_RTP" & singleBin.df$Type=="Saliva"] = "saliva49"

saliva.same.donor6 = c("1p","4p")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor6))] = "saliva50"

# buccal swabs - same donor
# slighly different lab procedures
saliva.same.donor7 = c("buccal swab -  fast diff + 200ul G2  - Lg vol EZ1", 
  "buccal swab - fast diff - Lg vol EZ1", 
  "buccal swab - fast diff - std EZ1", 
  "buccal swab -  fast diff + 200ul G2  - Lg vol EZ1", 
  "buccal swab - fast diff - Lg vol EZ1", 
  "buccal swab - fast diff - std EZ1")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor7))] = "saliva51"

# saliva placed on arm and then area scratched with left (L) and (R) thumb.  
# nails clipped an hour later.
saliva.same.donor8 = c("r-thumbnail clipping*", "l-thumbnail clipping*")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, saliva.same.donor8))] = "saliva52"



singleBin.df$donor[singleBin.df$Sample == "1_Feb training" & singleBin.df$Type=="Saliva"]  = "saliva53"

singleBin.df$donor[singleBin.df$Type=="Saliva"]
length(unique(singleBin.df$donor[singleBin.df$Type=="Saliva"]))

###################################################
## Samples with the prefix Se510 will be from different donors
## Samples with the prefix Se810 will be from different donors 
## There may be overlap between the two sample sets.
smn.diff.donor1 = c("Se510_12_RTP", "Se510_13_RTP", "Se510_14_RTP", "Se510_5_RTP", "Se510_7B_RTP", 
                   "Se510_9_RTP", "Se810_10_RTP", "Se510_10B_RTP", "Se510_19B_RTP", "Se510_21_RTP", 
                   "Se510_25_RTP", "Se510_6_RTP", "Se810_3B_RTP", "Se810_6_RTP", "Se810_8B_RTP", 
                   "Se510_2_RTP", "Se510_8_RTP", "Se810_11B_RTP", "Se810_12_RTP", "Se810_2_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.diff.donor1)) & singleBin.df$Type=="Semen"] = 
  paste("smn", c(1:length(smn.diff.donor1)), sep="")

## These are samples that Amy has grabbed to either train people in the lab, 
## check that reagents were still okay or so that Amy could have the right number of samples 
## to keep a centrifuged balanced so Amy doesn’t know the donors and they aren’t necessarily from the same sample.
singleBin.df$donor[singleBin.df$Sample == "SeBFD24_RTP" & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 1, sep="")
singleBin.df$donor[singleBin.df$Sample == "AB2_RTP_MB" & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 2, sep="")
singleBin.df$donor[singleBin.df$Sample == "4_Feb training" & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 3, sep="")


smn.same.donor1 =  c("Se810_1_RTP", "5ul semen on swab", 
                     "1ul semen on swab", "1ul Se on swab", "unknown sample_5p")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor1)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 4, sep="")

#These are all from the same donor
smn.same.donor2 = c("CD1_RTP_MB", "CD2_RTP_MB", "CD3_RTP_MB", "CD4_RTP_MB",
                    "CD5_RTP_MB", "CD6_RTP_MB", "CD7_RTP_MB", "CD8_RTP_MB")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor2)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 5, sep="")

# These are all from the same donor
smn.same.donor3 = c("10Se_fabric_RTP", "10Se_fabrictape_RTP", "5Se_fabric_RTP", "5Se_fabrictape_RTP", 
                      "3Se_fabric_RTP", "3Se_fabrictape_RTP", "1Se_fabric_RTP", "1Se_fabrictape_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor3)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 6, sep="")

# These are all from the same donor Se510_7B_RTP (above) but were stored frozen prior to testing
# Se510_7B_RTP was tested within a week of receiving the sample
smn.same.donor4 = c("10Se fabric tape_RTP", "5Se fabric tape_RTP", 
  "3Se fabric tape_RTP", "5Se fabric_RTP", "3Se fabric_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor4)) & singleBin.df$Type=="Semen"] = 
  singleBin.df$donor[singleBin.df$Sample=="Se510_7B_RTP"]

# These are all from the same donor
smn.same.donor5 = c("5Se direct_RTP", "3Se direct_RTP", "5Se tape_RTP", "3Se tape_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor5)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 7, sep="")

# These are all from the same donor
smn.same.donor6 = c("SeFE1_RTP", "SeFE2_RTP", "SeFE3_RTP", "SeFE4_RTP", 
                    "SeME1_RTP", "SeME2_RTP", "SeME3_RTP", "SeME4_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor6)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 8, sep="")

# These are all from the same donor SE510_21 but were stored frozen prior to testing
# Se510_21_RTP  (above) was tested within a week of receiving the sample
smn.same.donor7 = c("2ul Se directly into tube ", "2ul Se directly into tube ", "2ul Se directly into tube ", 
                    "1 ul Se directly into tube ", "1 ul Se directly into tube", "1 ul Se directly into tube")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor7)) & singleBin.df$Type=="Semen"] = 
  singleBin.df$donor[singleBin.df$Sample=="Se510_21_RTP"]

# These are all from the same donor
smn.same.donor8 = c("17Oct19_15Se_10_RTP", "17Oct19_2Se_11_RTP", "17Oct19_15Se_12_RTP",  
                    "17Oct19_2Se_7_RTP", "17Oct19_15Se_8_RTP", "17Oct19_2Se_9_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor8)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 9, sep="")

# These are all from the same donor
smn.same.donor9 = c("1ul Se directly into tube", "1ul Se directly into tube", "1ul Se directly into tube", 
  "1ul Se directly into tube", "2ul Se directly into tube", "2ul Se directly into tube", 
  "2ul Se directly into tube", "2ul Se directly into tube")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, smn.same.donor9)) & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 10, sep="")

# No information
singleBin.df$donor[singleBin.df$Sample == "6_RTP" & singleBin.df$Type=="Semen"] = 
  paste("smn", length(smn.diff.donor1) + 11, sep="")


singleBin.df$Sample[is.na(singleBin.df$donor) & singleBin.df$Type=="Semen"]

vm.black1 = c("VS06", "MBd1", "VS10-11 (2)", "VS10-12 (2)", "VS10-13 (2)", "VS10-17 (2)", "VS10-18 (2)", 
              "VS10-19 (2)", "VS10-20 (2)", "VS10-21 (2)", "VS10-26", "VS10-30", "VS612-2", "VS612-5", 
              "VS612-8", "VS612-14", "VS612-15", "VS612-19", "VS612-21", "VS612-24", "VS612-29", 
              "VS712-2", "VS712-7", "VS710-31", "VS710-42 (2)", "VS710-44 (2)", "VS710-46 (2)", 
              "VS710-52 (2)", "VS710-64", "VS710-71", "VS710-84", "VS710-87", "VS710-88")

match(vm.black1, singleBin.df$Sample)

sort(table(gsub(singleBin.df$Sample[singleBin.df$Type == "Vaginal Secretion"], pattern = " (2)", replace = "", fixed = T)))
duplSampleID = c("VS612-1", "VS612-10", "VS612-17", "VS612-22", "VS612-31", 
                 "VS612-36", "VS612-4", "VS710-89", "VS712-7")
match(paste(duplSampleID, " (2)", sep=""), singleBin.df$Sample)

match(duplSampleID, vm.black1)
match(paste(duplSampleID, " (2)", sep=""), vm.black1)

sort(table(gsub(singleBin.df$Sample[singleBin.df$Type == "Menstrual Blood"], pattern = " (2)", replace = "", fixed = T)))
duplSampleID.MTB = c("VS612-16", "VS712-1")


match(paste(duplSampleID.MTB, " (2)", sep=""), singleBin.df$Sample)
# VS612-16 is duplicated, there's no "VS612-16 (2)"
which(singleBin.df$Sample=="VS712-1")

match(duplSampleID.MTB, vm.black1)
match(paste(duplSampleID.MTB, " (2)", sep=""), vm.black1)


singleBin.df$Type[match(vm.black1, singleBin.df$Sample)]
  
vm.black1 = c("VS06", "MBd1", "VS10-11 (2)", "VS10-12 (2)", "VS10-13 (2)", "VS10-17 (2)", "VS10-18 (2)", 
              "VS10-19 (2)", "VS10-20 (2)", "VS10-21 (2)", "VS10-26", "VS10-30", "VS612-2", "VS612-5", 
              "VS612-8", "VS612-14", "VS612-15", "VS612-19", "VS612-21", "VS612-24", "VS612-29", 
              "VS712-2", "VS712-7", "VS710-31", "VS710-42 (2)", "VS710-44 (2)", "VS710-46 (2)", 
              "VS710-52 (2)", "VS710-64", "VS710-71", "VS710-84", "VS710-87", "VS710-88")

cvf.diff.donor1 = na.omit(vm.black1[singleBin.df$Type[match(vm.black1, singleBin.df$Sample)] == "Vaginal Secretion"])


singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.diff.donor1)) & singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", c(1:length(cvf.diff.donor1)), sep="")


singleBin.df$Type[match(c("VS612-1", "VS612-1 (2)"), singleBin.df$Sample)]
cvf.same.donor1 = c("VS612-1", "VS612-1 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor1)) & 
                     singleBin.df$Type=="Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 1, sep="")

singleBin.df$Type[match(c("VS612-4", "VS612-4 (2)"), singleBin.df$Sample)]
cvf.same.donor2 = c("VS612-4", "VS612-4 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor2)) & 
                     singleBin.df$Type=="Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 2, sep="")



singleBin.df$Type[match(c("VVS612-6",	"VS710-90", "VS712-3", "VS712-3"), singleBin.df$Sample)]
# VVS612-6 is not in the data, possibly an empty profile
cvf.same.donor3 = c("VS710-90", "VS712-3", "VS712-3")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor3)) & 
                     singleBin.df$Type=="Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 3, sep="")



singleBin.df$Type[match(c("VS612-10", "VS612-10 (2)"), singleBin.df$Sample)]
cvf.same.donor4 = c("VS612-10", "VS612-10 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor4)) & 
                     singleBin.df$Type=="Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 4, sep="")


singleBin.df$Type[match(c("VS612-11", "VS612-11 (2)", "VS612-23"), singleBin.df$Sample)]
# VS612-11 (2) is not in the data
cvf.same.donor5 = c("VS612-11", "VS612-23")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor5)) & 
                     singleBin.df$Type=="Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 5, sep="")

singleBin.df$Type[match(c("VS612-17", "VS612-17 (2)"), singleBin.df$Sample)]
cvf.same.donor6 = c("VS612-17", "VS612-17 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor6)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 6, sep="")

singleBin.df$Type[match(c("VS612-18", "VS612-22 (2)", "VS612-22"), singleBin.df$Sample)]
cvf.same.donor7 = c("VS612-18", "VS612-22 (2)", "VS612-22")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor7)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 7, sep="")

singleBin.df$Type[match(c("VS612-20", "VS612-32"), singleBin.df$Sample)]
cvf.same.donor8 = c("VS612-20", "VS612-32")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor8)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 8, sep="")




singleBin.df$Type[match(c("VS612-28 (2)", "VS612-33"), singleBin.df$Sample)]
# VS612-28 (2) not found
singleBin.df$donor[singleBin.df$Sample == "VS612-33" & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 9, sep="")



singleBin.df$Type[match(c("VS612-31", "VS612-31 (2)"), singleBin.df$Sample)]
cvf.same.donor9 = c("VS612-31", "VS612-31 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor9)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 10, sep="")

singleBin.df$Type[match(c("VS612-36", "VS612-36 (2)"), singleBin.df$Sample)]
cvf.same.donor10 = c("VS612-36", "VS612-36 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor10)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 11, sep="")

singleBin.df$Type[match(c("VS710-89", "VS710-89 (2)"), singleBin.df$Sample)]
cvf.same.donor11 = c("VS710-89", "VS710-89 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor11)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 12, sep="")



singleBin.df$Type[match(c("VS712-7", "VS712-7 (2)"), singleBin.df$Sample)]
cvf.same.donor12 = c("VS712-7", "VS712-7 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor12)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  singleBin.df$donor[singleBin.df$Sample == "VS712-7"]


singleBin.df$Type[singleBin.df$Sample =="2_RTP"]
singleBin.df$donor[singleBin.df$Sample == "2_RTP" & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 13, sep="")

singleBin.df$Type[match(c("VME1_RTP", "VME2_RTP", "VME3_RTP", "VME4_RTP"), singleBin.df$Sample)]
cvf.same.donor13 = c("VME1_RTP", "VME2_RTP", "VME3_RTP", "VME4_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor13)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 14, sep="")


singleBin.df$Type[singleBin.df$Sample =="MBFC1_RTP"]
singleBin.df$donor[singleBin.df$Sample == "MBFC1_RTP" & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 15, sep="")


singleBin.df$Type[match(c("1_1/4VS swab", "2_1/2VS swab", "3_VS swab"), singleBin.df$Sample)]
cvf.same.donor14 = c("1_1/4VS swab", "2_1/2VS swab", "3_VS swab")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, cvf.same.donor14)) & 
                     singleBin.df$Type == "Vaginal Secretion"] = 
  paste("cvf", length(cvf.diff.donor1) + 16, sep="")



##########################

mtb.diff.donor1 = na.omit(vm.black1[singleBin.df$Type[match(vm.black1, singleBin.df$Sample)] == "Menstrual Blood"])

singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.diff.donor1)) & singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", c(1:length(mtb.diff.donor1)), sep="")

singleBin.df$Type[match(c("VS612-16", "VS612-16"), singleBin.df$Sample)]
mtb.same.donor1 = c("VS612-16", "VS612-16")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor1)) & 
                     singleBin.df$Type=="Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 1, sep="")



mtb.same.donor1 = c("VS612-16", "VS612-16")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor1)) & 
                     singleBin.df$Type=="Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 1, sep="")



singleBin.df$Type[match(c("VS612-26", "VS612-26 (2)"), singleBin.df$Sample)]
# VS612-26 not found
singleBin.df$donor[singleBin.df$Sample == "VS612-26 (2)" & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(cvf.diff.donor1) + 2, sep="")


singleBin.df$Type[match(c("VS712-1", "VS712-1 (2)"), singleBin.df$Sample)]
mtb.same.donor2 = c("VS712-1", "VS712-1 (2)")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor2)) & 
                     singleBin.df$Type=="Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 3, sep="")



singleBin.df$Type[match(c("VS910_10_4", "VS910_10_5", "VS910_10_6", "VS910_10_7"), singleBin.df$Sample)]
mtb.same.donor3 = c("VS910_10_4", "VS910_10_5", "VS910_10_6", "VS910_10_7")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor3)) & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 4, sep="")



singleBin.df$Type[match(c("VS910_11_1", "VS910_11_4", "VS910_11_6", "VS910_11_7"), singleBin.df$Sample)]
mtb.same.donor4 = c("VS910_11_1", "VS910_11_4", "VS910_11_6", "VS910_11_7")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor4)) & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 5, sep="")

singleBin.df$Type[match(c("VS910_6_2", "VS910_6_3", "VS910_6_6", "VS910_6_7"), singleBin.df$Sample)]
mtb.same.donor5 = c("VS910_6_2", "VS910_6_3", "VS910_6_6", "VS910_6_7")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor5)) & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 6, sep="")

singleBin.df$Type[singleBin.df$Sample =="EDNAP4st8_MB"]
singleBin.df$donor[singleBin.df$Sample == "EDNAP4st8_MB" & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(cvf.diff.donor1) + 7, sep="")

singleBin.df$Type[match(c("MBFC3_RTP", "MBFC4_RTP"), singleBin.df$Sample)]
mtb.same.donor6 = c("MBFC3_RTP", "MBFC4_RTP")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor6)) & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 8, sep="")


singleBin.df$Type[match(c("4_1/2MB swab", "5_MB swab"), singleBin.df$Sample)]
mtb.same.donor7 = c("4_1/2MB swab", "5_MB swab")
singleBin.df$donor[!is.na(match(singleBin.df$Sample, mtb.same.donor7)) & 
                     singleBin.df$Type == "Menstrual Blood"] = 
  paste("mtb", length(mtb.diff.donor1) + 9, sep="")


