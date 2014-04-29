cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)


args <- list()


#options
begin <- 5
end <- 38
host <- "server"

args[[1]] <- c(paste(cur_wd,"/delayMultipleFlowCoupledbw10/",sep=""),"",host,begin,end)

#PING
arg <- args[[1]]
ping.0 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")
ping.1 <- ping_f(arg[1],arg[2],"172.16.1.2",2,split="y")
ping.2 <- ping_f(arg[1],arg[2],"172.16.2.2",2,split="y")
ping.3 <- ping_f(arg[1],arg[2],"172.16.3.2",2,split="y")
ping.4 <- ping_f(arg[1],arg[2],"172.16.4.2",2,split="y")

#IPERF
iperf.server <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")

#BWM
pattern = paste("'","bwm_",arg[3],"'",sep="")
z <- pipe(paste("ls -rt ",arg[1]," | grep ",pattern),"")
bwm_list <- readLines(z)
close(z)
#print(bwm_list)

bwm.len <- length(bwm_list)
eth0 <- eth1 <- eth2 <- eth3 <- eth4 <- vector(length=bwm.len)
bwm.l <-list()
interval <- end-begin
sampling <- 2#Hz

for(i in seq(1,bwm.len,by=1)) {
  file.path <- paste(arg[1],bwm_list[i],sep="")
  bwm_tp <- bwm_analysis2(file.path)
  eth0[i] <- mean(with(bwm_tp,bwm_tp[iface_name=="sv_mp1-eth0",])$bytes_in[(bwm.len-interval*sampling):(bwm.len-3*sampling)])
  eth1[i] <- mean(with(bwm_tp,bwm_tp[iface_name=="sv_mp1-eth1",])$bytes_in[(bwm.len-interval*sampling):(bwm.len-3*sampling)])
  eth2[i] <- mean(with(bwm_tp,bwm_tp[iface_name=="sv_mp1-eth2",])$bytes_in[(bwm.len-interval*sampling):(bwm.len-3*sampling)])
  eth3[i] <- mean(with(bwm_tp,bwm_tp[iface_name=="sv_mp1-eth3",])$bytes_in[(bwm.len-interval*sampling):(bwm.len-3*sampling)])
  eth4[i] <- mean(with(bwm_tp,bwm_tp[iface_name=="sv_mp1-eth4",])$bytes_in[(bwm.len-interval*sampling):(bwm.len-3*sampling)])
}

n <- 5
rcolor <- rainbow(n, s = 1, v = 1, start = 0.6, end = 0.1, alpha = 1)


mat <- matrix(c(1,2), 2)
layout(mat, c(1,1), c(4,2))
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0), las=1)
with(ping.4,plot(avg~x,
                 type="l",
                 ylim=c(0,550),col=rcolor[1]
                 )
     )
with(ping.1,lines(avg~x,
                  col=rcolor[2]))
with(ping.2,lines(avg~x,
                  col=rcolor[3]))
with(ping.3,lines(avg~x,
                  col=rcolor[4]))
with(ping.0,lines(avg~x,
                  col=rcolor[5]))

"""
mat <- matrix(c(1,2), 2)
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0), las=1)
layout(mat, c(1,1), c(4,2))
""" 
plot(eth0,col=rcolor[1])
points(eth1,col=rcolor[2])
points(eth2,col=rcolor[3])
points(eth3,col=rcolor[4])
points(eth4,col=rcolor[5])
with(iperf.server,plot((rate/1e6)~bw))

"""
with(subset(bwm_tp,iface_name=="sv_mp1-eth0"),plot(bytes_in*8/1e6,col=rcolor[1]))
with(subset(bwm_tp,iface_name=="sv_mp1-eth1"),points(bytes_in*8/1e6,col=rcolor[2]))
with(subset(bwm_tp,iface_name=="sv_mp1-eth2"),points(bytes_in*8/1e6,col=rcolor[3]))
with(subset(bwm_tp,iface_name=="sv_mp1-eth3"),points(bytes_in*8/1e6,col=rcolor[4]))
with(subset(bwm_tp,iface_name=="sv_mp1-eth4"),points(bytes_in*8/1e6,col=rcolor[5]))
"""
