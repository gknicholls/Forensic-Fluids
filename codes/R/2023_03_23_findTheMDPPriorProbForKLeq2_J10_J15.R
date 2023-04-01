# rpartition function directly taken from Geoff's part.R script
library(MCMCpack)
rpartition<-function(n,alpha,J,lambda=NA,dbn='MDP',set=NA,infinity=100) {
  
  #"set" is the set of objects we wish to partition
  #"infinity" is the mutiplier used to take the limit alpha or J go to infinity - larger is more accurate but slower for 'DP_as_limit'
  
  if (sum(dbn==c('MDP','DP_as_limit','DUP_exact','DUP_as_limit','MP'))!=1) {print(dbn); stop('bad dbn')}
  
  if (dbn=='MDP') {q=rdirichlet(1,rep(alpha,J)/J)}                       # MDP(alpha,J)
  if (dbn=='DP_as_limit') {J=max(n,alpha)*infinity; q=rdirichlet(1,rep(alpha,J)/J)}  # DP(alpha)=MDP(alpha,inf) - need J big compare to alpha and n really
  if (dbn=='DUP_exact') {q=rep(1/J,J)}                                   # DUP(J)
  if (dbn=='DUP_as_limit') {alpha=J*infinity; q=rdirichlet(1,rep(alpha,J)/J)} # approx DUP(J)=MDP(inf,J)
  if (dbn=='MP') {J=rpois(1,lambda)+1; q=rdirichlet(1,rep(1,J))}           # MP(J) - this is a Mondrian Process with J ~ Poisson(lambda)
  
  if (is.na(set[1])) {set=1:n} else {n=length(set)}
  
  #form partition as a list of sets of indices 1:n - will include empty sets
  #print(n)
  i=rmultinom(n,1,q)
  z=apply(i==1,2,which)
  S=lapply(1:J,function(x){set[which(z==x)]})
  #kill any empty sets
  mt=which(sapply(S,length)==0)
  if (length(mt)>0) S=S[-mt]
  
  #sort clusters by smallest entry to standardise
  j=sapply(S,function(x) {x[[1]]})
  S=S[order(j)]
  
  return(S)
}

sim.rparts = function(n = NULL, alpha = NULL, J = NULL, lambda = NULL,  dbn = NULL, P = NULL){
  
  prt = vector('character', P); 
  V = K = rep(0,P)
  L = matrix(NA, P, n)
  N = vector('list', P)
  for (p in 1:P) {
    R=rpartition(n=n,alpha=alpha,J=J,lambda=lambda,dbn=dbn)
    N[[p]]=sapply(R,length)
    K[p]=length(R)
    L[p,]=sapply(1:n,function(x) mean(N[[p]]==x))
    V[p]=sd(N[[p]])
    prt[p]=paste(unlist(lapply(R,paste,collapse=' ')),collapse=' - ')
  }
  par(mfrow=c(3,1))
  plot(1:n, apply(L, 2, mean), 
       ylim = c(0, 0.5), type = 'l', 
       xlab = 'cluster size',ylab = 'proportion of clusters')
  #lines(1:n,apply(L,2,mean),col=3)
  hist(K, breaks = 0.5:(max(K)+0.5), xlab='number of clusters K', main='')
  hist(V, sqrt(P), xlab='variance of cluster sizes in partition', main='')
  return(list(K = K, V = V))
}

set.seed(777)
cvf.mdp.sim.J10 = sim.rparts(n = 59, alpha = 2.2, J = 10, lambda = NA,  dbn = 'MDP', P = 10000)
cvf.mdp.sim.J10.K.freq = table(cvf.mdp.sim.J10$K)/sum(table(cvf.mdp.sim.J10$K))
cvf.mdp.sim.J10.K.freq 
# 1      2      3      4      5      6      7      8      9     10 
# 0.0007 0.0097 0.0553 0.1704 0.2714 0.2653 0.1587 0.0558 0.0117 0.001
sum(cvf.mdp.sim.J10.K.freq[1:5])
# [1] 0.5075


set.seed(777)
mtb.mdp.sim.J10 = sim.rparts(n = 31, alpha = 3, J = 10, lambda = NA,  dbn = 'MDP', P = 10000)
mtb.mdp.sim.J10.K.freq = table(mtb.mdp.sim.J10$K)/sum(table(mtb.mdp.sim.J10$K))
mtb.mdp.sim.J10.K.freq
# 1      2      3      4      5      6      7      8      9     10 
# 0.0003 0.0100 0.0565 0.1639 0.2706 0.2837 0.1513 0.0533 0.0098 0.0006
sum(mtb.mdp.sim.J10.K.freq[1:5])
# [1] 0.5013


set.seed(777)
slv.mdp.sim.J10 = sim.rparts(n = 80, alpha = 1.95, J = 10, lambda = NA,  dbn = 'MDP', P = 10000)
slv.mdp.sim.J10.K.freq = table(slv.mdp.sim.J10$K)/sum(table(slv.mdp.sim.J10$K))
slv.mdp.sim.J10.K.freq 
# 1      2      3      4      5      6      7      8      9     10 
# 0.0013 0.0118 0.0636 0.1694 0.2604 0.2622 0.1594 0.0610 0.0104 0.0005 
sum(slv.mdp.sim.J10.K.freq[1:5])
# [1] 0.5065


set.seed(777)
bld.mdp.sim.J10 = sim.rparts(n = 65, alpha = 2.125, J = 10, lambda = NA,  dbn = 'MDP', P = 10000)
bld.mdp.sim.J10.K.freq = table(bld.mdp.sim.J10$K)/sum(table(bld.mdp.sim.J10$K))
bld.mdp.sim.J10.K.freq 
#      1      2      3      4      5      6      7      8      9     10 
# 0.0015 0.0108 0.0607 0.1600 0.2732 0.2529 0.1703 0.0583 0.0113 0.0010 
sum(bld.mdp.sim.J10.K.freq[1:5])
# [1] 0.5062



set.seed(777)
smn.mdp.sim.J10 = sim.rparts(n = 86, alpha = 1.915, J = 10, lambda = NA,  dbn = 'MDP', P = 10000)
smn.mdp.sim.J10.K.freq = table(smn.mdp.sim.J10$K)/sum(table(smn.mdp.sim.J10$K))
smn.mdp.sim.J10.K.freq 
#      1      2      3      4      5      6      7      8      9     10 
# 0.0004 0.0117 0.0622 0.1635 0.2626 0.2659 0.1599 0.0613 0.0112 0.0013 
sum(smn.mdp.sim.J10.K.freq[1:5])
# [1] 0.5004



set.seed(777)
cvf.mdp.sim.J15 = sim.rparts(n = 59, alpha = 3.875, J = 15, lambda = NA,  dbn = 'MDP', P = 10000)
cvf.mdp.sim.J15.K.freq = table(cvf.mdp.sim.J15$K)/sum(table(cvf.mdp.sim.J15$K))
cvf.mdp.sim.J15.K.freq 
#      2      3      4      5      6      7      8      9     10     11     12     13     14 
# 0.0003 0.0032 0.0141 0.0485 0.1208 0.1977 0.2352 0.1941 0.1199 0.0493 0.0138 0.0030 0.0001 
sum(na.omit(as.numeric(cvf.mdp.sim.J15.K.freq[as.character(1:7)]) ))+cvf.mdp.sim.J15.K.freq["8"]*0.5
# 0.5022 

set.seed(777)
mtb.mdp.sim.J15 = sim.rparts(n = 31, alpha = 5.875, J = 15, lambda = NA,  dbn = 'MDP', P = 10000)
mtb.mdp.sim.J15.K.freq = table(mtb.mdp.sim.J15$K)/sum(table(mtb.mdp.sim.J15$K))
mtb.mdp.sim.J15.K.freq
#      2      3      4      5      6      7      8      9     10     11     12     13     14 
# 0.0001 0.0019 0.0098 0.0452 0.1156 0.2090 0.2488 0.2081 0.1091 0.0410 0.0103 0.0009 0.0002 
sum(na.omit(as.numeric(mtb.mdp.sim.J15.K.freq[as.character(1:7)]) ))+mtb.mdp.sim.J15.K.freq["8"]*0.5
# 0.506 

set.seed(777)
slv.mdp.sim.J15 = sim.rparts(n = 80, alpha = 3.35, J = 15, lambda = NA,  dbn = 'MDP', P = 10000)
slv.mdp.sim.J15.K.freq = table(slv.mdp.sim.J15$K)/sum(table(slv.mdp.sim.J15$K))
slv.mdp.sim.J15.K.freq 
#      2      3      4      5      6      7      8      9     10     11     12     13     14 
# 0.0007 0.0022 0.0167 0.0511 0.1214 0.2036 0.2279 0.1934 0.1170 0.0477 0.0155 0.0025 0.0003 
sum(na.omit(as.numeric(slv.mdp.sim.J15.K.freq[as.character(1:7)]) )) + slv.mdp.sim.J15.K.freq["8"]*0.5
# 0.50965 

set.seed(777)
bld.mdp.sim.J15 = sim.rparts(n = 65, alpha = 3.7, J = 15, lambda = NA,  dbn = 'MDP', P = 10000)
bld.mdp.sim.J15.K.freq = table(bld.mdp.sim.J15$K)/sum(table(bld.mdp.sim.J15$K))
bld.mdp.sim.J15.K.freq 
#      3      4      5      6      7      8      9     10     11     12     13     14 
# 0.0026 0.0152 0.0506 0.1234 0.1984 0.2281 0.1980 0.1141 0.0518 0.0150 0.0027 0.0001
sum(na.omit(as.numeric(bld.mdp.sim.J15.K.freq[as.character(1:7)]) )) + bld.mdp.sim.J15.K.freq["8"]*0.5
# 0.50425

set.seed(777)
smn.mdp.sim.J15 = sim.rparts(n = 86, alpha = 3.25, J = 15, lambda = NA,  dbn = 'MDP', P = 10000)
smn.mdp.sim.J15.K.freq = table(smn.mdp.sim.J15$K)/sum(table(smn.mdp.sim.J15$K))
smn.mdp.sim.J15.K.freq 
#      3      4      5      6      7      8      9     10     11     12     13     14 
# 0.0026 0.0133 0.0527 0.1248 0.1937 0.2286 0.1917 0.1174 0.0548 0.0169 0.0033 0.0002
sum(na.omit(as.numeric(smn.mdp.sim.J15.K.freq[as.character(1:7)]) )) + smn.mdp.sim.J15.K.freq["8"]*0.5
# 0.5014 