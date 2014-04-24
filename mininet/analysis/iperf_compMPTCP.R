cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- list()

Host <- "client"
args[[1]] <- c(paste(cur_wd,"/bw-exp-sub2/",sep=""), "exp001_TC_runbw", Host, 10,50)
args[[2]] <- c(paste(cur_wd,"/bw-exp-NoMPTCP/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[3]] <- c(paste(cur_wd,"/bw-exp-sub3/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[4]] <- c(paste(cur_wd,"/bw-exp-sub4/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[5]] <- c(paste(cur_wd,"/bw-exp-sub5/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[6]] <- c(paste(cur_wd,"/bw-exp-sub6/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)


arg <- args[[1]]
iperf.sub2 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[2]]
iperf.TCP <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[3]]
iperf.sub3 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[4]]
iperf.sub4 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[5]]
iperf.sub5 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[6]]
iperf.sub6 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])

n <- 6
rcolor <- rainbow(n, s = 1, v = 1, start = 0.6, end = 0.1, alpha = 1)

pdf("bwzoom.pdf",useDingbats=FALSE)
with(iperf.sub2,plot((rate/1000000)~bw,pch=16,
                     col=rcolor[2],
                     ylim=c(0,420),xlim=c(0,400),
                     xlab="débit par lien (Mbit/s)",
                     ylab="débit total (Mbit/s)"))
with(iperf.TCP,lines((rate/1000000)~bw,pch=16,col="black"))
with(iperf.sub3,lines((rate/1000000)~bw,pch=16,col=rcolor[3]))
with(iperf.sub4,lines((rate/1000000)~bw,pch=16,col=rcolor[4]))
with(iperf.sub5,lines((rate/1000000)~bw,pch=16,col=rcolor[5]))
with(iperf.sub6,lines((rate/1000000)~bw,pch=16,col=rcolor[6]))
abline(0,1,lty=3,lwd=1)

legend("bottomright", # la position sur le graphique
       c("TCP","MPTCP n=2","MPTCP n=3", "MPTCP n=4","MPTCP n=5","MPTCP n=6"), # le texte pour chaque courbe
       col=c("black", rcolor[2], rcolor[3], rcolor[4], rcolor[5], rcolor[6]), # La couleur de chaque courbe
       pch=c(16),
       #lwd=c(1,1), # L'épaisseur de chaque courbe
       #lty=c(1,3) # Le type de trait de chaque courbe
)
dev.off()








          
