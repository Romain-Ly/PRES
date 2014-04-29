library(grid)
library(lattice)
library(Hmisc)

cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)


                                        #ex Rscript bw-single.R $PWD/coupledbw-exp-sub2 exp001_TC_runMPTCPcoupled-2-bw100 server

args <- commandArgs(trailingOnly = TRUE)
#arg 1 : path : "$PWD/folder/" must end with a "/"
#arg 2 : prefix name example: "exp001_TC_runTC0"
#arg 3 : client or server
path <- args[1]
fname <- args[2]
host <- args[3]

bwm_pattern <- paste("_bwm_",host,"_all.csv",sep="")

file.path <- paste(args[1],"/",args[2],bwm_pattern,sep="")
bwm <- read.csv(file.path,sep=";",header=FALSE)
colnames(bwm) <- c("unix_timestamp","iface_name","bytes_out_s","bytes_in_s","bytes_total_s","bytes_in","bytes_out","packets_out_s","packets_in_s","packets_total_s","packets_in","packets_out","errors_out_s","errors_in_s","errors_in","errors_out")
head(bwm)


pdf("bw-single.pdf",
    width=unit(8,"cm"),
    height=unit(8,"cm"),
    useDingbats=FALSE
    )

with(bwm,xyplot((bytes_in_s/1000000*8)~(unix_timestamp-1398593500)|iface_name,
                type="l",as.table=TRUE,
                xlim=c(40,85)
                ))


dev.off()
n <- 5
rcolor <- rainbow(n, s = 1, v = 1, start = 0.2, end = 0.1, alpha = 1)






mat <- matrix(c(1,2,3,4,5), 5)
layout(mat, c(1,1,1,1,1), c(1,1,1,1,1))
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0), las=1)

xlim <- c(20,60)
ylim <- c(0,8)

with(subset(bwm,iface_name=="sv_mp1-eth0"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),type="l",
          xlim=xlim,
          ylim=ylim,
          xlab="Temps (s)",
          col=rcolor[1],
          bty="l",
          ylab=paste("débit mesuré par interface (Mbit/s)",sep="")
          )
     )
with(subset(bwm,iface_name=="sv_mp1-eth1"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),
          type="l",
          xlim=xlim,
          ylim=ylim,
          col=rcolor[2])
     )
with(subset(bwm,iface_name=="sv_mp1-eth2"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),
          type="l",
          xlim=xlim,
          ylim=ylim,
          col=rcolor[3])
     )
with(subset(bwm,iface_name=="sv_mp1-eth3"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),
          col=rcolor[4],
          xlim=xlim,
          ylim=ylim,
          type="l")
     )
with(subset(bwm,iface_name=="sv_mp1-eth4"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),
          type="l",
          xlim=xlim,
          ylim=ylim,
          col=rcolor[5])
     )
legend("bottomright", # la position sur le graphique
       c("eth0","eth1","eth2","eth3","eth4","eth5"),
       col=c(rcolor[1], rcolor[2], rcolor[3], rcolor[4], rcolor[5]),
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,1) # Le type de trait de chaque courbe
       )

dev.off()
