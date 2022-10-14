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
#See Header for option breakdown
#n = 59; alpha=0.6025; J=5; lambda=NA; dbn='MDP'
#n=59; alpha=0.9125; J=5; lambda=NA; dbn='MDP'
#n=59; alpha=15; J=15; lambda=NA; dbn='MDP'
cvf.mdp.sim = sim.rparts(n = 59, alpha = 0.6025, J = 5, lambda = NA,  dbn = 'MDP', P = 10000)
cvf.mdp.sim.K.freq = table(cvf.mdp.sim$K)/sum(table(cvf.mdp.sim$K))
cvf.mdp.sim.K.freq 
# 1      2      3      4      5 
# 0.1319 0.3748 0.3557 0.1212 0.0164
sum(cvf.mdp.sim.K.freq[1:2])
# [1] 0.5067

set.seed(777)
#n = 31; alpha = 1; J=5; lambda=NA; dbn='MDP'
# n = 31; alpha=1.15; J=5; lambda=NA; dbn='MDP'
# n = 31; alpha=15; J=15; lambda=NA; dbn='MDP'
mtb.mdp.sim = sim.rparts(n = 31, alpha = 0.725, J = 5, lambda = NA,  dbn = 'MDP', P = 10000)
mtb.mdp.sim.K.freq = table(mtb.mdp.sim$K)/sum(table(mtb.mdp.sim$K))
mtb.mdp.sim.K.freq
# 1      2      3      4      5 
# 0.1269 0.3745 0.3569 0.1261 0.0156 
sum(mtb.mdp.sim.K.freq[1:2])
# [1] 0.5014

set.seed(777)
#n=80; alpha=0.18; J=5; lambda=NA; dbn='MDP'
#n=80; alpha=0.55; J=5; lambda=NA; dbn='MDP'
#n=80; alpha=0.84; J=5; lambda=NA; dbn='MDP'
#n=80; alpha=15; J=15; lambda=NA; dbn='MDP
slv.mdp.sim = sim.rparts(n = 80, alpha = 0.55, J = 5, lambda = NA,  dbn = 'MDP', P = 10000)
slv.mdp.sim.K.freq = table(slv.mdp.sim$K)/sum(table(slv.mdp.sim$K))
slv.mdp.sim.K.freq 
# 1      2      3      4      5 
# 0.1331 0.3708 0.3410 0.1344 0.0207 
sum(slv.mdp.sim.K.freq[1:2])
# [1] 0.5039

set.seed(777)
#n=65; alpha=0.575; J=5; lambda=NA; dbn='MDP'
#n=65; alpha=0.89; J=5; lambda=NA; dbn='MDP'
#n=65; alpha=15; J=15; lambda=NA; dbn='MDP'
bld.mdp.sim = sim.rparts(n = 65, alpha = 0.585, J = 5, lambda = NA,  dbn = 'MDP', P = 10000)
bld.mdp.sim.K.freq = table(bld.mdp.sim$K)/sum(table(bld.mdp.sim$K))
bld.mdp.sim.K.freq 
#      1      2      3      4      5 
# 0.1342 0.3706 0.3501 0.1309 0.0142
sum(bld.mdp.sim.K.freq[1:2])
# [1] 0.5048

set.seed(777)
#n=86; alpha=0.178; J=5; lambda=NA; dbn='MDP'
#n=86; alpha=0.82; J=5; lambda=NA; dbn='MDP'
#n=86; alpha=15; J=15; lambda=NA; dbn='MDP'
smn.mdp.sim = sim.rparts(n = 86, alpha = 0.525, J = 5, lambda = NA,  dbn = 'MDP', P = 10000)
smn.mdp.sim.K.freq = table(smn.mdp.sim$K)/sum(table(smn.mdp.sim$K))
smn.mdp.sim.K.freq 
#      1      2      3      4      5 
# 0.1450 0.3633 0.3486 0.1272 0.0159 
sum(smn.mdp.sim.K.freq[1:2])
# [1] 0.5083

cumsum(table(K)/sum(table(K)))