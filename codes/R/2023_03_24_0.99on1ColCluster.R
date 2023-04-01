J = 5
alpha = 0.006
n = 5
exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))

J = 7
alpha = 0.0045
n = 7
exp(lgamma(alpha) - lgamma(alpha/J) + 
      lfactorial(J) - lfactorial(J - 1) +
      lgamma(alpha/J + n) - lgamma(alpha + n))