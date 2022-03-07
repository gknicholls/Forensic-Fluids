
#FOrensic Body Fluids stuff - 07-03-22 GKN
#exploring different partition models
#for example for paritioning rows within a fluid type we would have n=30 say and might want 
#a priori 2-4 clusters. Could do this with for eg

#Multinomial DP
#n=30; alpha=1; J=5; lambda=NA; dbn='MDP'
#tends to have the DP problem of lots of having several clusters (inspect "prt")

#Dirichlet Process
#n=30; alpha=0.5; J=NA; lambda=NA; dbn='DP_as_limit'
#gets the right number of clusters but usual issue - few big clusters, lots of small

#Discrete Uniform Partitions (where to have J bins and group by bin like a 1D Discrete MP)
#n=30; alpha=NA; J=5; lambda=NA; dbn='DUP_exact'
#Very even sized clusters but you always get J of them, little variability in number of clusters

#Discrete Uniform Partitions (where to have J bins and group by bin like a 1D Discrete MP)
#n=30; alpha=NA; J=5; lambda=NA; dbn='DUP_as_limit'
#same as last just checking math should get same as above (if "infinity" is set big enough)

#AND THE WINNER IS

#Mondrian Process - full continuous process in 1D with Poisson J
#n=30; alpha=NA; J=NA; lambda=3; dbn='MP' 
#actually J~Poisson(lambda) and alpha=J but we know that because dbn='MP'
#seems to give good range of cluster sizes and number of clusters

library(MCMCpack)

rpartition<-function(n,alpha,J,lambda=NA,dbn='MDP',infinity=100) {
  #"infinity" is the mutiplier used to take the limit alpha or J go to infinity - larger is more accurate but slower for 'DP_as_limit'
  
  if (sum(dbn==c('MDP','DP_as_limit','DUP_exact','DUP_as_limit','MP'))!=1) stop('bad dbn')
  
  if (dbn=='MDP') {q=rdirichlet(1,rep(alpha,J)/J)}                       # MDP(alpha,J)
  if (dbn=='DP_as_limit') {J=max(n,alpha)*infinity; q=rdirichlet(1,rep(alpha,J)/J)}  # DP(alpha)=MDP(alpha,inf) - need J big compare to alpha and n really
  if (dbn=='DUP_exact') {q=rep(1/J,J)}                                   # DUP(J)
  if (dbn=='DUP_as_limit') {alpha=J*infinity; q=rdirichlet(1,rep(alpha,J)/J)} # approx DUP(J)=MDP(inf,J)
  if (dbn=='MP') {J=rpois(1,lambda)+1; q=rdirichlet(1,rep(1,J))}           # MP(J) - this is a Mondrian Process with J ~ Poisson(lambda)
  
  #form partition as a list of sets of indices 1:n - will include empty sets
  i=rmultinom(n,1,q)
  z=apply(i==1,2,which)
  S=lapply(1:J,function(x){which(z==x)})
  
  #kill any empty sets
  mt=which(sapply(S,length)==0)
  if (length(mt)>0) S=S[-mt]
  
  #sort clusters by smallest entry to standardise
  j=sapply(S,function(x) {x[[1]]})
  S=S[order(j)]

  return(S)
}

#See Header for option breakdown
#n=30; alpha=1; J=5; lambda=NA; dbn='MDP'
#n=30; alpha=0.5; J=NA; lambda=NA; dbn='DP_as_limit'
#n=30; alpha=NA; J=5; lambda=NA; dbn='DUP_exact'
#n=30; alpha=NA; J=5; lambda=NA; dbn='DUP_as_limit'
n=30; alpha=NA; J=NA; lambda=3; dbn='MP' 

P=1000; prt=vector('character',P); K=rep(0,P)
for (p in 1:P) {
  S=rpartition(n=n,alpha=alpha,J=J,lambda=lambda,dbn=dbn)
  K[p]=length(S)
  prt[p]=paste(unlist(lapply(S,paste,collapse=' ')),collapse=' - ')
}

hist(K,breaks=0.5:(max(K)+0.5))
prt
