require(jpeg)

plotFaceF = function(index,size=5){
  img    = readJPEG(paste(c('./images/',ims[index]),collapse=''))
  xLeft  = scores[index,1]-size
  yTop   = scores[index,2]+size*p2/p1
  xRight = scores[index,1]+size
  yBottom   = scores[index,2]-size*p2/p1
  rasterImage(img,xLeft,yBottom,xRight,yTop)
}

#Read in images
ims = dir('./images')
Xcol = list()
Xbw  = list()
X = matrix(0,nrow=length(ims),ncol= 320*240)
sweep = 0
for(im in ims){
  sweep = sweep + 1
  im = paste(c('./images/',im),collapse='')
  Xcol[[sweep]] = readJPEG(im)
  Xbw[[sweep]]  = t(apply(Xcol[[sweep]],1:2,sum))
  X[sweep,]     = as.numeric(Xbw[[sweep]])
}



cols = gray.colors(1000)[1000:1]

p1 = nrow(Xcol[[1]])
p2 = ncol(Xcol[[1]])
cat('Images are ',p1,' by ',p2,'\n')

#Get PCs
pcaOut = svd(scale(X,scale=FALSE))
scores = pcaOut$u %*% diag(pcaOut$d)


#Make plots
plot(scores[,1:2],xlab='PC1',ylab='PC2',pch=16,col='red',xlim=c(-150,150),ylim=c(-150,150))

indices = 1:length(ims)
indices = identify(scores[,1:2])

plot(scores[,1:2],xlab='PC1',ylab='PC2',pch=16,col='red',xlim=c(-150,150),ylim=c(-125,125))
tmp = sapply(indices,plotFaceF,size=10,simplify=TRUE)
