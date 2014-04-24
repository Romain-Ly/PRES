cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- list()

args[[1]] <- c(paste(cur_wd,"/delaybas-exp-bw10/",sep=""), "exp001_TC_runbasdelay", "client", 10,50)


arg <- args[[1]]
iperf.bw10 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw10 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")


pdf("test.pdf")
with(iperf.bw10,plot((rate/1000000)~ping.bw10$avg,pch=16,ylim=c(0,200),xlab="débit par lien (Mbit/s)",ylab="débit total (Mbit/s)"))

legend("bottomright", # la position sur le graphique
       c("MPTCP n=2", "TCP"), # le texte pour chaque courbe
       col=c("black", "red"), # La couleur de chaque courbe
       pch=c(16,16),
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,3) # Le type de trait de chaque courbe
)
dev.off()








          
