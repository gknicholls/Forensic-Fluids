logAllConfigMDP = matrix(c(-278.9327790446595, -279.0376951482387, -282.2242100334603, -283.7609433932106, 0,
         -278.5402353842051, -280.0862873342446, -280.9611731511506, -282.9621870595322, 0,
         -278.2672076899302, -279.5158203752669, -280.4467130882813, -284.5322361798105, 0,
         -278.5361944293055, -279.8031749562952, -282.3399081811102, -283.9029888648216, 0,
         -279.0361400646326, -279.1981970783448, -280.2340224890614, -284.2882888277161, 0),
       nrow = 5, byrow = T)


logAllConfigLik = 
  matrix(c(-1380.0214837219269, -1389.8860020326733, -1379.2952920027442, -1382.6062370473599, 0.0,
           -1389.2018551475273, -1396.6556616305563, -1398.7057242040514, -1385.7942867409563, 0.0,
           -1407.4974772083563, -1390.739371081685, -1410.1043769203006, -1385.2450836609532, 0.0,
           -1416.7784384562235, -1395.4547240270258, -1394.4906765699395, -1385.2450836609532, 0.0,
           -1397.6757112863663, -1397.7615503598834, -1394.226583366867, -1384.1647759885443, 0.0),
         nrow = 5, byrow = T)
logTypePrior = log(c(0.05, 0.15, 0.2, 0.25, 0.35))
print(logTypePrior, digits = 17)


logAllConfigPost = logAllConfigMDP+logAllConfigLik 
logAllConfigPost[1:5, 1:4] = logAllConfigPost[1:5, 1:4] + logTypePrior
logAllConfigPost[1:5, 1:4] = logAllConfigPost[1:5, 1:4] - min(logAllConfigPost[1:5, 1:4])
allConfigPost = logAllConfigPost
allConfigPost[1:5, 1:4] = exp(allConfigPost[1:5, 1:4])
allConfigPost = allConfigPost/sum(allConfigPost)
print(allConfigPost, digits = 17)

cumsum(t(allConfigPost))
       
c(0.5, 0.92775,  0.999, 0.99925,  0.9995,  0.9999)[c(5, 2, 4, 3, 1, 6)]
(c(1, 3, 6, 12, 19, 24)-1)[c(5, 2, 4, 3, 1, 6)]
list(c(3,3), c(0, 2), c(2, 1), c(1,0), c(0, 0), c(4, 3))

log.df = read.table(file = "/Users/chwu/Documents/research/bfc/analysis/2023_02_10/loocvCut_side_cvf_1_v2_0.log",
           header = T, as.is = T, sep = "\t")

uniqueTypeList = unique(log.df$typeList)
unique.log.post = log.df$log.posterior[match(uniqueTypeList, log.df$typeList)]
unique.post = exp(unique.log.post - max(unique.log.post))
unique.post = unique.post/sum(unique.post)
plot(log(unique.post), 
     log(as.numeric(unname(table(log.df$typeList))/nrow(log.df))))
abline(a = 0, b = 1)

