load("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/allParts5And7EltsMatsAndSets.rda")
setwd("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/")

singleTypeFilePath = "data.csv"
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

########################################################################################
############# Calculation with full column integration over 5 columns ##################
########################################################################################

startTime <- Sys.time()

slv.sub.col5.df = slv.df[, slvMkrs]

pXgvCol5PartVec = vector(length = length(elts5AllPartSet))
## Iterate through all possible partitions across 5 columns.
for(partIndex in 1:length(elts5AllPartSet)){
  
  ## Initiate the likelihood for calculating the product of 
  ## likelihoods across sets within the current partition scheme.
  pXgvCol5PartVec[partIndex] = 1
  setCount = length(elts5AllPartSet[[partIndex]])
  
  ## Iterate through each set within the current partition scheme for 5 columns.
  for(setIndex in 1:setCount){
    
    ## Extract the columns of the current set.
    setCols = slv.sub.col5.df[, elts5AllPartSet[[partIndex]][[setIndex]]]
    col5PartCellCount = NA
    setColsDim = dim(setCols)
    
    if(is.null(setColsDim)){
      
      ## If there is only a single column, then the total number of cells is 
      ## the length of that column.
      col5PartCellCount = length(setCols)
      
    }else{
      
      ## Otherwise,the total number of cells is the product 
      ## if the dimensions of the 2-D lattice.
      col5PartCellCount = prod(setColsDim)
      
    }
    
    ## Compute the number of 1's in the columns of the current set.
    col5Part1Count = sum(slv.sub.col5.df[, elts5AllPartSet[[partIndex]][[setIndex]]])
    ## Compute the number of 0's in the columns of the current set.
    col5Part0Count = col5PartCellCount - col5Part1Count
    ## Update the likelihood of that partition.
    pXgvCol5PartVec[partIndex] = pXgvCol5PartVec[partIndex] * 
      beta(alphaC + col5Part1Count, betaC + col5Part0Count)
  }
}

endTime <- Sys.time()
endTime - startTime
# Time difference of 0.04383612 secs


startTime <- Sys.time()
slv.sub.col7.df = slv.df[,mtbMkrs]

pXgvCol7PartVec = vector(length = length(elts7AllPartSet))
## Iterate through all possible partitions across 7 columns.
for(partIndex in 1:length(elts7AllPartSet)){
  
  ## Initiate the likelihood for calculating the product of 
  ## likelihoods across sets within the current partition scheme.
  pXgvCol7PartVec[partIndex] = 1
  setCount = length(elts7AllPartSet[[partIndex]])
  
  ## Iterate through each set within the current partition scheme for 7 columns.
  for(setIndex in 1:setCount){
    
    ## Extract the columns of the current set.
    
    setCols = slv.sub.col7.df[,elts7AllPartSet[[partIndex]][[setIndex]]]
    colPartCellCount = NA
    setColsDim = dim(setCols)
    
    if(is.null(setColsDim)){
      
      ## If there is only a single column, then the total number of cells is 
      ## the length of that column.
      colPartCellCount = length(setCols)
    }else{
      
      ## Otherwise,the total number of cells is the product 
      ## if the dimensions of the 2-D lattice.
      colPartCellCount = prod(setColsDim)
    }
    
    ## Compute the number of 1's in the columns of the current set.
    colPart1Count = sum(slv.sub.col7.df[,elts7AllPartSet[[partIndex]][[setIndex]]])
    ## Compute the number of 0's in the columns of the current set.
    colPart0Count = colPartCellCount - colPart1Count
    ## Update the likelihood of that partition.
    pXgvCol7PartVec[partIndex] = pXgvCol7PartVec[partIndex] * 
      beta(alphaC + colPart1Count , betaC + colPart0Count)
  }
}
endTime <- Sys.time()
endTime - startTime
# Time difference of 0.2303112 secs



