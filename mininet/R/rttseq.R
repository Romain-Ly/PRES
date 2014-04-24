
a <- seq(1,10,by=0.1)
slope=-1

max1 = 10
result1=  max1/(1+exp((a-5)/slope))

max2 = 20
result2=  max2/(1+exp((a-5)/slope))

max3 = 100
result3=  max3/(1+exp((a-5)/slope))

max4 = 470
result4= 30+max4/(1+exp((a-5)/slope))

plot(result1,
     ylim=c(0,10))
points(result2)
points(result3)
points(result4)


