### Two way anova
dataset = matrix(c(46.5,138.4,180.9,39.8,132.4,176.8,47.3,144.4,180.5,40.3,
               132.4,173.6,46.9,142.7,183,41.2,130.3,174.9),nrow=3,byrow=TRUE)
J     = 2 #A, 2 levels 1:3 and 4:6
K     = 3 #B, 3 levels, columns 1,4 2,5 3,6
repli = 3#rows

#Additive
(ssA = K*repli*((mean(dataset[,1:3]) - mean(dataset) )**2 + 
                (mean(dataset[,4:6]) - mean(dataset) )**2))
(ssB = J*repli*((mean(dataset[,c(1,4)]) - mean(dataset) )**2 + 
                (mean(dataset[,c(2,5)]) - mean(dataset) )**2 +
                (mean(dataset[,c(3,6)]) - mean(dataset) )**2))

(ssTot = sum( (dataset - mean(dataset))**2 ))
(ssE = sum((dataset[,1] - mean(dataset[,1:3]) - mean(dataset[,c(1,4)]) + mean(dataset))**2 +
      (dataset[,2]-mean(dataset[,1:3]) - mean(dataset[,c(2,5)])+ mean(dataset))**2 +
      (dataset[,3]-mean(dataset[,1:3]) - mean(dataset[,c(3,6)])+ mean(dataset))**2 +
      (dataset[,4]-mean(dataset[,4:6]) - mean(dataset[,c(1,4)])+ mean(dataset))**2 + 
      (dataset[,5]-mean(dataset[,4:6]) - mean(dataset[,c(2,5)])+ mean(dataset))**2 + 
      (dataset[,6]-mean(dataset[,4:6]) - mean(dataset[,c(3,6)])+ mean(dataset))**2))


## Nested
abrasive = c(1,1,2,2,3,3,4,4,5,5,6,6)
site = c(rep(1,4),rep(2,4),rep(3,4))
Y = c(25,29,14,11,11,6,22,18,17,20,5,2)

ssB_A = 2*((mean(Y[abrasive==1])-mean(Y[site==1]))**2 + 
  (mean(Y[abrasive==2])-mean(Y[site==1]))**2 +
  (mean(Y[abrasive==3])-mean(Y[site==2]))**2 + 
  (mean(Y[abrasive==4])-mean(Y[site==2]))**2 +
  (mean(Y[abrasive==5])-mean(Y[site==3]))**2 +
  (mean(Y[abrasive==6])-mean(Y[site==3]))**2)

ssA = 2*2*( (mean(Y[site==1])-mean(Y))**2 + 
             (mean(Y[site==2])-mean(Y))**2 +
           (mean(Y[site==3])-mean(Y))**2 )

#Additive instead of nested: Not working, yet
(ssA = K*repli*((mean(dat[,1:3]) - mean(dat) )**2 + 
                  (mean(dat[,4:6]) - mean(dat) )**2))
(ssB = J*repli*((mean(dat[,c(1,4)]) - mean(dat) )**2 + 
                  (mean(dat[,c(2,5)]) - mean(dat) )**2 +
                  (mean(dat[,c(3,6)]) - mean(dat) )**2))

