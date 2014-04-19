cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- list()

args[[1]] <- c(paste(cur_wd,"/delaybas-exp-bw10/",sep=""), "exp001_TC_runbasdelay", "client", 10,50)
args[[2]] <- c(paste(cur_wd,"/delaybas-exp2-bw10/",sep=""), "exp002_TCping_runbasdelay", "client", 10,50)
args[[3]] <- c(paste(cur_wd,"/delaybas-exp2-bw50/",sep=""), "exp002_TCping_runbasdelay", "client", 10,50)
args[[4]] <- c(paste(cur_wd,"/delaybas-exp2-bw100/",sep=""), "exp002_TCping_runbasdelay", "client", 10,50)

args[[5]] <- c(paste(cur_wd,"/delaybas-exp2-bw200/",sep=""), "exp002_TCping_runbasdelay", "client", 10,50)


arg <- args[[1]]
iperf.bw10 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw10 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")
arg <- args[[2]]
iperf.2bw10 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.2bw10 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")
arg <- args[[3]]
iperf.2bw50 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
#ping.2bw50 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")
arg <- args[[4]]
iperf.2bw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.2bw100 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")
arg <- args[[5]]
iperf.2bw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw200 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")


pdf("rtt.pdf")
with(iperf.bw10,plot((rate/1000000)~ping.bw10$avg,pch=16,ylim=c(0,200),xlab="débit par lien (Mbit/s)",ylab="débit total (Mbit/s)"))
with(iperf.2bw10,points((rate/1000000)~ping.2bw10$avg,pch=16,col="red"))
#with(iperf.2bw50,points((rate/1000000)~ping.2bw50$avg,pch=16,col="blue"))
with(iperf.2bw100,points((rate/1000000)~ping.2bw100$avg,pch=16,col="green"))
with(iperf.2bw200,points((rate/1000000)~ping.2bw200$avg,pch=16,col="purple"))

legend("bottomright", # la position sur le graphique
       c("MPTCP n=2", "TCP"), # le texte pour chaque courbe
       col=c("black", "red"), # La couleur de chaque courbe
       pch=c(16,16),
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,3) # Le type de trait de chaque courbe
)
dev.off()








          
