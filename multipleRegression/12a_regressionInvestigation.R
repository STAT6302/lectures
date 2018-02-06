### Confounding Example
n  = 5
ep = 0.1
set.seed(1)
X = cbind(1:n,1:n+rnorm(n,0,ep))
b = c(1,1)
Y = X%*%b + rnorm(n)
lm_out = lm(Y~X)
summary(lm_out)

require(scatterplot3d)
s3d = scatterplot3d(x=X[,1],y=X[,2],z=Y,angle=65)
s3d$plane3d(lm_out,lty.box='solid')


require(rgl)
allData = as.data.frame(cbind(X,Y))
names(allData) = c('police','population','crime')
plot3d(allData, type = "s",size=.8)
a = coef(lm_out)[2];b = coef(lm_out)[3];c=-1;d=coef(lm_out)[1]
planes3d(a, b, c, d, col = 'red', alpha = 0.6)
xData = as.data.frame(cbind(X,rep(0,n)))
names(xData) =  c('police','population','crime')
plot3d(xData, type = "s",col='blue',add=TRUE,size=.6)

### Multicollinearity Example
n  = 5
ep = .005
set.seed(1)
X = cbind(1:n,1:n+rnorm(n,0,ep))
b = c(1,1)
Y = X%*%b + rnorm(n)
lm_out = lm(Y~X)
summary(lm_out)


require(rgl)
allData = as.data.frame(cbind(X,Y))
names(allData) = c('left arm','right arm','body wgt.')
plot3d(allData, type = "s",size=.8)
a = coef(lm_out)[2];b = coef(lm_out)[3];c=-1;d=coef(lm_out)[1]
planes3d(a, b, c, d, col = 'red', alpha = 0.6)
xData = as.data.frame(cbind(X,rep(0,n)))
names(xData) =  c('police','population','crime')
plot3d(xData, type = "s",col='blue',add=TRUE,size=.6)

