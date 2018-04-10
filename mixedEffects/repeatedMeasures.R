### repeated measures
t1 = c(45,42,36,39,51,44)
t2 = c(50,42,41,35,55,49)
t3 = c(55,45,43,40,59,56)

dataMat  = cbind(t1,t2,t3)

dataMat
residMat = cbind(t1-mean(t1),t2-mean(t2),t3-mean(t3))
residMat

cov(residMat)

mean(diag(cov(residMat)))


(sum(residMat[,1]*residMat[,2])/5+
    sum(residMat[,1]*residMat[,3])/5+
    sum(residMat[,2]*residMat[,3])/5)/3

(cov(residMat)[1,3]+cov(residMat)[2,3]+cov(residMat)[1,2])/3