mpi.bcast.cmd(np.mpi.initialize(),
              caller.execute=TRUE)
mpi.bcast.cmd(options(np.messages=FALSE),
              caller.execute=TRUE)
setwd("~/")
a<-read.csv("data.csv")
Y2<-a[12490:17574,7]
mydat<-data.frame(a[12490:17574,1:5],Y2)
mpi.bcast.Robj2slave(mydat)

bw1<-load('y2.Rbw')
mpi.bcast.Robj2slave(bw2)

t2 <- system.time(mpi.bcast.cmd(bw2 <- npregbw(formula=Y2~X1+X2+X3+X4+X5,
                                              bws=bw2,
#a bandwidth specification. This can be set as a rbandwidth object returned from a previous invocation, 
#or as a vector of bandwidths, with each element i corresponding to the bandwidth for column i in xdat. 
#In either case, the bandwidth supplied will serve as a starting point in the numerical search for 
#optimal bandwidths. If specified as a vector, then additional arguments will need to be supplied as 
#necessary to specify the bandwidth type, kernel types, selection methods, and so on. This can be left unset. 
# the method restarts 5 times to avoid local minima, I am unsure whether it is a good idea to use
# previously attained results in that respect
                                             regtype="ll",
                                             bwmethod="cv.ls",
                                             data=mydat),
                               caller.execute=TRUE))

summary(bw2)
t2
t2 <- t2 + system.time(mpi.bcast.cmd(model <- npreg(bws=bw2,
                                                  data=mydat),
                                   caller.execute=TRUE))
t2
summary(model)
save(bw2,file='y2.Rbw')
save(model,file='y2.Rmodel')
mpi.bcast.cmd(mpi.quit(),
              caller.execute=TRUE)
