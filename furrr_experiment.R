library(tictoc)
library(purrr)
library(furrr)

#I hear the package furrr combines the optimization of purrr with parallel 
#processing methods. I want to see if I can use this to take advantage of my 
#shiny new computer's quad core processor. 

nsim = 10000
n = 30
#Let's demonstrate this by generating 10000 samples of 30 iid beta(2,2) random
#variables in three ways: with a for loop, with map_dfr(), and with 
#future_map_dfr(), timing each simulation with the package tictoc

#Using a for loop 
samps <- data.frame()

tic()
for(i in 1:nsim){
  samps <- rbind(samps, rbeta(n,2,2))
}
toc()

#let's use purrr now
tic()
samps <- map(rep(n,nsim),rbeta,shape1=2,shape2=2)
samps <- data.frame(matrix(unlist(samps), nrow=length(samps), byrow=T))
toc()

#by using purrr, we've reduced the time it takes to simulate the samples down 
#from nearly 20 seconds to around one tenth of a second on my machine. this
#allows us to feasibly generate MUCH larger samples:
nsim <- 1000000
tic()
samps <- map(rep(n,nsim),rbeta,shape1=2,shape2=2)
samps <- data.frame(matrix(unlist(samps), nrow=length(samps), byrow=T))
toc()

#now, I can generate a sample of 1,000,000 on my machine in just around ten 
#seconds. let's try upgrading to parallel processing using furrr:
remove(samps)
plan(multiprocess) #we have to tell furrr that we want to use parallel 
tic()
samps <- future_map(rep(n,nsim),rbeta,shape1=2,shape2=2)
samps <- data.frame(matrix(unlist(samps), nrow=length(samps), byrow=T))
toc()

#this should be improving the speed but it's not. I'm not sure why, maybe it's 
#just not improving it in a noticeable way. I'll have to do some investigation
#into why
