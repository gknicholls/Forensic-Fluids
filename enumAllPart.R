## Print out all possible partitions for a given set of elements.
printClust = function(rawPart = NULL){
  clustCount = max(rawPart)
  tempPart = c()
  for(j in 1:clustCount){
    index = which(rawPart == j)
    if(length(index) == 1){
      tempPart = c(tempPart, paste("(", index, ")", sep=""))
    }else{
      tempPart = c(tempPart, paste("(", paste(index, collapse=", "), ")", sep=""))
    }
  }
  clust = paste(sort(tempPart), collapse=", ")
  return(clust)
}

## Calculate all permutation
permute = function(vec){
  if(length(vec) ==1){
    return(vec)
  }else{
    temp = c()
    for(i in 1:length(vec)){
      tmp1 = permute(vec[-i])
      if(length(tmp1) == 1){
        temp = rbind(temp, c(vec[i], tmp1))
      }else{
        temp = rbind(temp, cbind(rep(vec[i], nrow(tmp1)), tmp1))
      }
      
    }
    
    return(temp)
  }
  
}

## Calculate the power sets for a given set of elements.
powerSet = function(k, vec){
  if(k ==1){
    return(vec)
  }else{
    temp = c()
    for(i in 1:length(vec)){
      if(k - 1 == 1){
        temp = rbind(temp,
                     cbind(rep(vec[i], length(vec)), powerSet(k -1, vec)))
      }else{
        tmp1 = powerSet(k -1, vec)
        temp = rbind(temp,
                     cbind(rep(vec[i], nrow(tmp1)), tmp1))
      }
      
      
    }
    
    return(temp)
  }
  
}

##################################################################################
############ Calculate all possible partitions for 5 elements #################### 
##################################################################################

## Calculate the power set for 5 elements.
power5set = powerSet(5, 1:5)
## Calculate all possible partition counts.
groups5 = unique(unlist(apply(power5set, 1, 
                              function(z){
                                paste(sort(table(z)), collapse=", ") 
                                } 
                              )
                        )
                 )
## Calculate all possible partition membership vector
groups5List = lapply(groups5, function(z){ 
  groupCount = as.numeric(unlist(strsplit(z, split = ", ")) )
  return(rep(1:length(groupCount), groupCount))
  })
  
## Calculate all permutation
perm5 = permute(1:5)

## Calculate all partitions
group5partList = list()
for(groupCountIndex in 1:length(groups5List)){
  group5tmp = matrix(groups5List[[groupCountIndex]][t(perm5)], ncol = 5, byrow = T)
  group5partList[[groupCountIndex]] = unique(apply(group5tmp, 1, printClust))
}

## Count the number different partitions
sum(unlist(lapply(group5partList, length)))

##################################################################################
############ Calculate all possible partitions for 7 elements #################### 
##################################################################################

######################## Calculate all permutations ##############################
x1 = c(1:7)
x2 = c()

for(i in 1:length(x1)){
  temp  = cbind(rep(i, length(x1) -1 ),x1[-i])
  if(i == 1){
    x2 = temp
  }else{
    x2 = rbind(x2, temp)
  }
}

x3 = c()
for(i in 1:nrow(x2)){
  temp  = cbind(matrix(rep(x2[i,], rep(length(x1) - ncol(x2), ncol(x2))),
                       ncol = 2), x1[-x2[i,]])
  if(i == 1){
    x3 = temp
  }else{
    x3 = rbind(x3, temp)
  }
}

x4 = c()
for(i in 1:nrow(x3)){
  temp  = cbind(matrix(rep(x3[i,], rep(length(x1) - ncol(x3), ncol(x3))), ncol = ncol(x3)), x1[-x3[i,]])
  if(i == 1){
    x4 = temp
  }else{
    x4 = rbind(x4, temp)
  }
}


x5 = c()
for(i in 1:nrow(x4)){
  temp  = cbind(matrix(rep(x4[i,], rep(length(x1) - ncol(x4), ncol(x4))), ncol = ncol(x4)), x1[-x4[i,]])
  if(i == 1){
    x5 = temp
  }else{
    x5 = rbind(x5, temp)
  }
}



x6 = c()
for(i in 1:nrow(x5)){
  temp  = cbind(matrix(rep(x5[i,], rep(length(x1) - ncol(x5), ncol(x5))), ncol = ncol(x5)), x1[-x5[i,]])
  if(i == 1){
    x6 = temp
  }else{
    x6 = rbind(x6, temp)
  }
}


x7 = c()
for(i in 1:nrow(x6)){
  temp  = cbind(matrix(rep(x6[i,], rep(length(x1) - ncol(x6), ncol(x6))), ncol = ncol(x6)), x1[-x6[i,]])
  if(i == 1){
    x7 = temp
  }else{
    x7 = rbind(x7, temp)
  }
}
##################################################################################

##################### Calculate all possible partition counts#####################
grp1 = rep(1, 7)
grp2.1 = c(1, rep(2, 6))
grp2.2 = c(rep(1,2), rep(2, 5))
grp2.3 = c(rep(1,3), rep(2, 4))
grp3.1 = c(1, 2, rep(3, 5))
grp3.2 = c(1, rep(2,2), rep(3, 4))
grp3.3 = c(1, rep(2,3), rep(3, 3))
grp3.4 = c(rep(1,2), rep(2,2), rep(3, 3))
grp4.1 = c(1:3, rep(4, 4))
grp4.2 = c(1, 2, rep(3, 2), rep(4, 3))
grp4.3 = c(1, rep(2,2), rep(3, 2), rep(4, 2))
grp5.1 = c(1:4, rep(5, 3))
grp5.2 = c(1:3, rep(4, 2), rep(5, 2))
grp6 = c(1:5, rep(6, 2))
grp7 = 1:7
##################################################################################

############## Calculate partition for a given number of clusters ################
tmp1 = matrix(grp1[t(x7)], ncol = 7, byrow = T)
part1 = unique(apply(tmp1, 1, paste, collapse=""))

tmp2.1 = matrix(grp2.1[t(x7)], ncol = 7, byrow = T)
clustCount = max(grp2.1)

part2.1 = unique(apply(tmp2.1, 1, printClust))

tmp2.2 = matrix(grp2.2[t(x7)], ncol = 7, byrow = T)
part2.2 = unique(apply(tmp2.2, 1, printClust))

tmp2.3 = matrix(grp2.3[t(x7)], ncol = 7, byrow = T)
part2.3 = unique(apply(tmp2.3, 1, printClust))


tmp3.1 = matrix(grp3.1[t(x7)], ncol = 7, byrow = T)
part3.1 = unique(apply(tmp3.1, 1, printClust))

tmp3.2 = matrix(grp3.2[t(x7)], ncol = 7, byrow = T)
part3.2 = unique(apply(tmp3.2, 1, printClust))

tmp3.3 = matrix(grp3.3[t(x7)], ncol = 7, byrow = T)
part3.3 = unique(apply(tmp3.3, 1, printClust))

tmp3.4 = matrix(grp3.4[t(x7)], ncol = 7, byrow = T)
part3.4 = unique(apply(tmp3.4, 1, printClust))

tmp4.1 = matrix(grp4.1[t(x7)], ncol = 7, byrow = T)
part4.1 = unique(apply(tmp4.1, 1, printClust))

tmp4.2 = matrix(grp4.2[t(x7)], ncol = 7, byrow = T)
part4.2 = unique(apply(tmp4.2, 1, printClust))

tmp4.3 = matrix(grp4.3[t(x7)], ncol = 7, byrow = T)
part4.3 = unique(apply(tmp4.3, 1, printClust))

tmp5.1 = matrix(grp5.1[t(x7)], ncol = 7, byrow = T)
part5.1 = unique(apply(tmp5.1, 1, printClust))

tmp5.2 = matrix(grp5.2[t(x7)], ncol = 7, byrow = T)
part5.2 = unique(apply(tmp5.2, 1, printClust))

tmp6 = matrix(grp6[t(x7)], ncol = 7, byrow = T)
part6 = unique(apply(tmp6, 1, printClust))

tmp7  = matrix(grp7[t(x7)], ncol = 7, byrow = T)
part7 = unique(apply(tmp7, 1, printClust))


group7partList = list(part1, 
                      part2.1, part2.2, part2.3, 
                      part3.1, part3.2, part3.3, part3.4,
                      part4.1, part4.2, part4.3, 
                      part5.1, part5.2,
                      part6, part7)
sum(unlist(lapply(group7partList, length)))
##################################################################################

save(group5partList, group7partList,
     file="allParts5And7Elts.rda")
