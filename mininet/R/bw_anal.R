

bwm_analysis <- function(filestring,iface){
  bwm <- read.csv(filestring,sep=";",header=FALSE)
  colnames(bwm) <- c("unix_timestamp","iface_name","bytes_out_s","bytes_in_s","bytes_total_s","bytes_in","bytes_out","packets_out_s","packets_in_s","packets_total_s","packets_in","packets_out","errors_out_s","errors_in_s","errors_in","errors_out")
  print(iface)
  bwm <- subset(bwm,iface_name==iface)
  return(bwm)
}

#garde toutes les ifs
bwm_analysis2 <- function(filestring){ 
  bwm <- read.csv(filestring,sep=";",header=FALSE)
  colnames(bwm) <- c("unix_timestamp","iface_name","bytes_out_s","bytes_in_s","bytes_total_s","bytes_in","bytes_out","packets_out_s","packets_in_s","packets_total_s","packets_in","packets_out","errors_out_s","errors_in_s","errors_in","errors_out")
  return(bwm)
}



#colnames(eth1) = colnames(eth0)=c("unix_timestamp","iface_name","bytes_out_s","bytes_in_s","bytes_total_s","bytes_in","bytes_out","packets_out_s","packets_in_s","packets_total_s","packets_in","packets_out","errors_out_s","errors_in_s","errors_in","errors_out")

#eth0 = subset(eth0,iface_name!="total")
#eth1 = subset(eth1,iface_name!="total")

#time_x0=seq(0,by=0.1,length.out=dim(eth0)[1])
#time_x1=seq(0,by=0.1,length.out=dim(eth1)[1])

#eth0.df = cbind(x=time_x0,eth0)
#eth1.df = cbind(x=time_x1,eth1)

#par(mfrow=c(1,2))

#with(eth0.df,plot((bytes_out_s*8)~x,type="l"))
#with(eth0.df,lines((bytes_in_s*8)~x,type="l",col="red"))

#with(eth1.df,plot((bytes_out_s*8)~x,type="l"))
#with(eth1.df,lines((bytes_in_s*8)~x,type="l",col="red"))
