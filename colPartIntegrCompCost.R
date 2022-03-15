load("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/allParts5And7EltsMats.rda")


singleTypeFilePath = "/Users/chwu/Documents/research/bfc/data/data.csv"
single.df = read.csv(singleTypeFilePath, header = TRUE) # whole single sample data
single.df <-single.df[,-1] # single sample data, delete the index column
sum(single.df$Sample == 1) # number observations of CVF
sum(single.df$Sample == 2) # MB
sum(single.df$Sample == 3) # saliva
sum(single.df$Sample == 4) # blood
sum(single.df$Sample == 5) # semen

slv.df = single.df[single.df$Sample == 3,]
bfLevels = c("cvf", "mtb", "slv", "bld", "smn")
bfNames = c("CVF", "MB", "Saliva", "Blood", "Semen")
names(bfNames) = bfLevels
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

alphaC = 1; betaC = 1

startTime <- Sys.time()
slv.sub.col5.df = slv.df[,slvMkrs]

pXgvColPartVec = vector(length = length(elts5AllPartSet))
for(partIndex in 1:length(elts5AllPartSet)){
  pXgvColPartVec[partIndex] = 1
  setCount = length(elts5AllPartSet[[partIndex]])
  for(setIndex in 1:setCount ){
    colPart1Count = sum(slv.sub.col5.df[,elts5AllPartSet[[partIndex]][[setIndex]]])
    setCols = slv.sub.col5.df[,elts5AllPartSet[[partIndex]][[setIndex]]]
    colPartCellCount = NA
    setColsDim = dim(setCols)
    if(is.null(setColsDim)){
      colPartCellCount = length(setCols)
    }else{
      colPartCellCount = prod(setColsDim)
    }
    colPart0Count = colPartCellCount - colPart1Count
    pXgvColPartVec[partIndex] = pXgvColPartVec[partIndex] * 
      beta(alphaC + colPart1Count , betaC + colPart0Count)
  }
}

endTime <- Sys.time()
endTime - startTime
# Time difference of 0.04383612 secs


startTime <- Sys.time()
slv.sub.col7.df = slv.df[,mtbMkrs]

pXgvCol7PartVec = vector(length = length(elts7AllPartSet))
for(partIndex in 1:length(elts7AllPartSet)){
  pXgvCol7PartVec[partIndex] = 1
  setCount = length(elts7AllPartSet[[partIndex]])
  for(setIndex in 1:setCount){
    colPart1Count = sum(slv.sub.col7.df[,elts7AllPartSet[[partIndex]][[setIndex]]])
    setCols = slv.sub.col7.df[,elts7AllPartSet[[partIndex]][[setIndex]]]
    colPartCellCount = NA
    setColsDim = dim(setCols)
    if(is.null(setColsDim)){
      colPartCellCount = length(setCols)
    }else{
      colPartCellCount = prod(setColsDim)
    }
    colPart0Count = colPartCellCount - colPart1Count
    pXgvCol7PartVec[partIndex] = pXgvCol7PartVec[partIndex] * 
      beta(alphaC + colPart1Count , betaC + colPart0Count)
  }
}
endTime <- Sys.time()
endTime - startTime
# Time difference of 0.2303112 secs



