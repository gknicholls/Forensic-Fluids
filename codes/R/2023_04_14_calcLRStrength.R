testSingleBayesCalibr.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleBayesCalibr.csv",
                                  header = T, as.is = T)
head(testSingleBayesCalibr.df)
testJointBayesCalibr.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointBayesCalibr.csv",
                                 header = T, as.is = T)
testSingleCutCalibr.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testSingleCutCalibr.csv",
         header = T, as.is = T)
head(testSingleCutCalibr.df)
testJointCutCalibr.df = read.csv(file = "/Users/chwu/Documents/research/bfc/paper/analysis/calibration/testJointCutCalibr.csv",
                                  header = T, as.is = T)

typeLabels = c("cvf", "mtb", "slv", "bld", "smn")
getLRStrengthTable = function(data.df = NULL){
  correctTypePostProb = data.df[,paste(typeLabels, "PostProb", sep="")][cbind(1:nrow(data.df),match(data.df$trueType, typeLabels))]
  correctTypeLR = correctTypePostProb/(1 - correctTypePostProb)*4
  correctTypeLRCategory =cut(log10(correctTypeLR), c(-2,-1, -0.5, 0, 0.5, 1, 2, Inf))
  table(data.df$trueType,correctTypeLRCategory )
}
getLRStrengthTable(data.df = testSingleBayesCalibr.df)
# correctTypeLRCategory
#.    (-2,-1] (-1,-0.5] (-0.5,0] (0,0.5] (0.5,1] (1,2] (2,Inf]
# bld       0         0        0       0       0     0       2
# cvf       1         0        0       0       1    12      10
# slv       0         0        0       0       0     0      10
# smn       0         0        0       1       0     1       8
getLRStrengthTable(data.df = testSingleCutCalibr.df)
# correctTypeLRCategory
#     (-2,-1] (-1,-0.5] (-0.5,0] (0,0.5] (0.5,1] (1,2] (2,Inf]
# bld       0         0        0       0       0     0       2
# cvf       0         1        0       0       1    13       9
# slv       0         0        0       0       0     0      10
# smn       0         0        0       1       0     3       6
getLRStrengthTable(data.df = testJointBayesCalibr.df)
# correctTypeLRCategory
#     (-2,-1] (-1,-0.5] (-0.5,0] (0,0.5] (0.5,1] (1,2] (2,Inf]
# bld       0         0        0       0       0     0       2
# cvf       0         1        0       0       1    13       9
# slv       0         0        0       0       0     0      10
# smn       0         0        0       0       0     2       8
getLRStrengthTable(data.df = testJointCutCalibr.df)
# correctTypeLRCategory
#     (-2,-1] (-1,-0.5] (-0.5,0] (0,0.5] (0.5,1] (1,2] (2,Inf]
# bld       0         0        0       0       0     0       2
# cvf       0         1        0       1       0    15       7
# slv       0         0        0       0       0     0      10
# smn       0         0        0       0       1     4       5