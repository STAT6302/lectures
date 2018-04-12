########### Regression Example
n = 100
p = 2
X = matrix(rnorm(n*p,mean=20),nrow=n,ncol=p)
X[1:n,1] = 1
beta0 = matrix(rnorm(p),nrow=p)
Y = X %*% beta0 + rnorm(n)

# Continuous valued regression
fit = lm(Y ~ X[,2])
summary(fit)

plot(X[,2],Y,xlab='heat',ylab='lifespan',main='Lifespan of lightbulb under various heating conditions')
abline(a = fit$coef[1],b = fit$coef[2])

# Discrete valued regression
Ynew = Y > mean(Y)
fit = lm(Ynew ~ X[,2])
summary(fit)

plot(X[,2],Ynew,xlab='heat',ylab='survive?',main='Did lightbulb survive?')
abline(a = fit$coef[1],b = fit$coef[2])

########### ANOVA example
lam    = 5000#.1#
n      = 200

placebo = rpois(n,lam)
cancer  = rpois(n,lam)
nothing = rpois(n,lam)

Y = c(placebo,cancer,nothing)
X = rep(n,3)
X = rep(1:3,X)

cancerDrugData = data.frame(y = Y, drug = factor(X))

fit = lm(Y ~ drug, data=cancerDrugData)
anova(fit)

par(mfrow=c(1,3))
boxplot(placebo,main='placebo')
boxplot(cancer,main='cancer')
boxplot(nothing,main='nothing')

evalGrid = seq(lam - 4*sqrt(lam),lam+4*sqrt(lam),length.out=1000)
par(mfrow=c(3,1))
plot(density(placebo),main='placebo')
lines(evalGrid,dnorm(evalGrid,mean=lam,sd=sqrt(lam)),col='red')
legend(x=1.5,y = 2.5, legend=c("sample's distribution",'normal approximation'),lty=1,col=c('black','red'))
plot(density(cancer),main='cancer')
lines(evalGrid,dnorm(evalGrid,mean=lam,sd=sqrt(lam)),col='red')
plot(density(nothing),main='nothing')
lines(evalGrid,dnorm(evalGrid,mean=lam,sd=sqrt(lam)),col='red')

