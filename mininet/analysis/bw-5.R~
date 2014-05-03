library(grid)

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
    width=unit(5,"cm"),
    height=unit(5,"cm"),
    useDingbats=FALSE
    )

with(subset(bwm,iface_name=="sv_mp1-eth0"),
     plot((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),type="l",
          xlim=c(0,50),
          ylim=c(0,10),
          xlab="Temps (s)",
          col="black",
          bty="l",
          ylab=paste("débit mesuré par interface (Mbit/s)",sep="")
          )
     )
with(subset(bwm,iface_name=="sv_mp1-eth1"),
     lines((bytes_in_s*8/1e6)~seq(0,by=0.5,length=length(bytes_in_s)),
           col="red")
     )
legend("bottomright", # la position sur le graphique
       c("eth0","eth1"),
       col=c("black", "red"),
       
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,1) # Le type de trait de chaque courbe
       )

dev.off()
