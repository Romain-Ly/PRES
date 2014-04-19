cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- list()

Host <- "client"
args[[1]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw100/",sep=""), "exp001_TC_runbw", Host, 10,50)
args[[2]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw1000/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[3]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw200/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)
args[[4]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw500/",sep=""), "exp001_TC_runNoMPTCPbw", Host, 10,50)



arg <- args[[1]]
iperf.bw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[2]]
iperf.bw1000 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[3]]
iperf.bw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[4]]
iperf.bw500 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])



pdf("ws.pdf",useDingbats=FALSE)
with(iperf.bw100,plot((rate/1000000)~bw,pch=16,ylim=c(0,1000),xlab="débit par lien (Mbit/s)",ylab="débit total (Mbit/s)"))
with(iperf.bw200,points((rate/1000000)~bw,pch=16,col="red"))
with(iperf.bw500,points((rate/1000000)~bw,pch=16,col="blue"))
with(iperf.bw1000,points((rate/1000000)~bw,pch=16,col="green"))
abline(0,1)

legend("bottomright", # la position sur le graphique
       c("100", "1000","200"), # le texte pour chaque courbe
       col=c("black", "red"), # La couleur de chaque courbe
       pch=c(16,16),
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,3) # Le type de trait de chaque courbe
)
dev.off()








          
