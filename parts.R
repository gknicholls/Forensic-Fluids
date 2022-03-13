
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

#See Header for option breakdown
#n=30; alpha=1; J=5; lambda=NA; dbn='MDP'
#n=30; alpha=0.5; J=NA; lambda=NA; dbn='DP_as_limit'
#n=30; alpha=NA; J=4; lambda=NA; dbn='DUP_exact'
#n=30; alpha=NA; J=5; lambda=NA; dbn='DUP_as_limit'
n=30; alpha=NA; J=NA; lambda=2; dbn='MP' 

P=1000; prt=vector('character',P); V=K=rep(0,P); L=matrix(NA,P,n); N=vector('list',P)
for (p in 1:P) {
  R=rpartition(n=n,alpha=alpha,J=J,lambda=lambda,dbn=dbn,set=seq(2,60,2))
  N[[p]]=sapply(R,length)
  K[p]=length(R)
  L[p,]=sapply(1:n,function(x) mean(N[[p]]==x))
  V[p]=sd(N[[p]])
  prt[p]=paste(unlist(lapply(R,paste,collapse=' ')),collapse=' - ')
}
par(mfrow=c(3,1))
plot(1:n,apply(L,2,mean),ylim=c(0,0.5),type='l',xlab='cluster size',ylab='proportion of clusters')
#lines(1:n,apply(L,2,mean),col=3)
hist(K,breaks=0.5:(max(K)+0.5),xlab='number of clusters K',main='')
hist(V,sqrt(P),xlab='variance of cluster sizes in partition',main='')
prt

##########################################################################
#Some experiments simulating synthetic data

{
set.seed(4)
F=2; Mg=5; Nf=15; #for a figure you can actually read
F=5; Mg=5; Nf=25; #5 fluid types, 25 obs per FT, 5 markers target each FT

#indices of rows and columns
row.set=lapply(1:F,function(f){ c(((f-1)*Nf+1):(f*Nf)) } )
col.set=lapply(1:Mg,function(g){ c(((g-1)*Mg+1):(g*Mg)) } )

#beta prior parameters - we probably want these different in the diagonal boxes
a=matrix(0.5,F,F); diag(a)<-0.5;
b=matrix(2,F,F); diag(b)<-0.25;

#Mondrian on the row cluster, DUP (discrete bin model) on the marker columns
alphaR=NA; JR=NA; lambdaR=2; dbnR='MP' 
alphaS=NA; JS=3; lambdaS=NA; dbnS='DUP_exact' 

#the data structures are mean to mimic the notation in the paper so
#the row clusters are R[[f]][[k]]=R_{f(k)} and KR[f]=K_{f}
R=lapply(1:F, function(f) {rpartition(n=NA,alpha=alphaR,J=JR,lambda=lambdaR,dbn=dbnR,set=row.set[[f]])})
KR=sapply(R,length)

m=n=KS=thetat=S=vector('list',F)
fkgl=theta=X=matrix(NA,Nf*F,F*Mg,dimnames=list(paste(1:(Nf*F)),paste(1:(F*Mg))))

for (f in 1:F) {
  m[[f]]=KS[[f]]=thetat[[f]]=S[[f]]=vector('list',KR[f])
  n[[f]]=numeric(KR[f])
  for (k in 1:KR[f]) {
    
    #the columns clusters mimic paper notation so S[[f]][[k]][[g]][[l]]=S_{f(k),g(l)}
    #and KS[[f]][[k]][g]=K_{f(k),g}
    S[[f]][[k]]=lapply(1:F,function(g) {rpartition(n=NA,alpha=alphaS,J=JS,lambda=lambdaS,dbn=dbnS,set=col.set[[g]])})
    KS[[f]][[k]]=unlist(lapply(S[[f]][[k]],length))
    
    #similarly thetat[[f]][[k]][[g]][l]=\tilde\theta_{f(k),g(l)}
    thetat[[f]][[k]]=lapply(1:F,function(g) {rbeta(KS[[f]][[k]][g],a[f,g],b[f,g])})
    
    #i are the row indices in R_{f(k)}
    i=R[[f]][[k]]; 
    
    #n[[f]][k]=n_{f(k)}
    n[[f]][k]=length(i)
    
    m[[f]][[k]]=vector('list',F)
    for (g in 1:F) {
      m[[f]][[k]][[g]]=numeric(KS[[f]][[k]][g])
      for (l in 1:KS[[f]][[k]][g]) {
        
        #j are the marker/column indices in S_{f(k),g(l)} 
        j=S[[f]][[k]][[g]][[l]]
        
        #m[[f]][[k]][[g]][l]=n_{f(k),g(l)}
        m[[f]][[k]][[g]][l]=length(j)
        
        #fkgl[i,j] for any i a row index and j a column index gives the (f(k),g(l)) string of the cluster to which (i,j) belongs 
        fkgl[i,j]=paste( c(f,"(",k,"),",g,"(",l,")"),collapse='')
        
        #this is the map \theta_{ij}=\tilde\theta_{f(k),g(l)}
        theta[i,j]=thetat[[f]][[k]][[g]][l]; 
        
        #simulate the binary X entries using \theta_{ij} - this does all the X's in one (f(k),g(l)) block
        X[i,j]=(runif(n[[f]][k]*m[[f]][[k]][[g]][l])<theta[i,j])
      }
    }
  }
}

#plot some figures illustrating the notation and realised X, theta and (f(k),g(l)) patterns
library('plot.matrix')

col.ramp=colorRampPalette(c("white","red","orange","yellow","green","skyblue","black"))

#plot everything for one fluid type - assumes you want all the marker groups for this fluid type
plot.fluid.marker.matrix<-function(F,col.set,Y,cols,digits=NA,box.vec,axis.col=3) {
  j=col.set[[1]]
  par(mai=c(box.vec[1:3],0))
  plot(Y[,j],axis.col=axis.col,col=cols,key=NULL,ann=FALSE,digits=digits,text.cell=list(cex=0.8,adj=c(0.5,0.35)))
  if (F>2) {
    for (g in 2:(F-1)) {
      j=col.set[[g]]; 
      par(mai=c(box.vec[1],0.15,box.vec[3],0))
      plot(Y[,j],axis.col=axis.col,axis.row=NULL,col=cols,key=NULL,ann=FALSE,digits=digits,text.cell=list(cex=0.8,adj=c(0.5,0.35)))
    }
  }
  j=col.set[[F]]; 
  par(mai=c(box.vec[1],0.15,box.vec[3],box.vec[4]))
  plot(Y[,j],axis.col=axis.col,axis.row=NULL,col=cols,key=NULL,ann=FALSE,digits=digits,text.cell=list(cex=0.8,adj=c(0.5,0.35)))
}

#plot all the fluid types - taking F<5 works if you want it less crowded
plot.marker.matrix<-function(F,row.set,col.set,Y,cols,digits=NA) {
  par(mfrow=c(F,F),omi=c(0.1,0.1,0.1,0.1))
  i=row.set[[1]]
  plot.fluid.marker.matrix(F,col.set,Y[i,],cols,digits=digits,box.vec=c(0,0.2,0.2,0.1),axis.col=3)
  if (F>2) {
    for (f in 2:(F-1)) {
      i=row.set[[f]]; 
      plot.fluid.marker.matrix(F,col.set,Y[i,],cols,digits=digits,box.vec=c(0,0.2,0.1,0.1),axis.col=NULL)
    }
  }
  i=row.set[[F]]; 
  plot.fluid.marker.matrix(F,col.set,Y[i,],cols,digits=digits,box.vec=c(0,0.2,0.1,0.1),axis.col=NULL)
}

#sort the rows so they are grouped by the row clusters in R
row.set=lapply(R,unlist)
#pdf(file = "similated-data.pdf")
plot.marker.matrix(F,row.set,col.set,Y=X,cols=c('black','white'))
#dev.off()
#pdf(file = "simulated-theta.pdf")
plot.marker.matrix(F,row.set,col.set,Y=theta,cols=col.ramp,digits=2)
#dev.off()
#pdf(file = "simulated-fkgl-matrix.pdf")
plot.marker.matrix(F,row.set,col.set,Y=fkgl,cols=col.ramp,digits=9)
#dev.off()
}
