cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- list()

Host <- "client"
args[[1]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw100/",sep=""),"", Host, 10,50)
args[[2]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw1000/",sep=""), "", Host, 10,50)
args[[3]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw200/",sep=""), "", Host, 10,50)
args[[4]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw500/",sep=""), "", Host, 10,50)
args[[4]] <- c(paste(cur_wd,"/bw-exp3-fenetrebw500/",sep=""), "", Host, 10,50)
args[[5]] <- c(paste(cur_wd,"/bw-exp3maxq10000-fenetrebw1000/",sep=""),"", Host, 10,50)
args[[6]] <- c(paste(cur_wd,"/bw-exp3maxq1e7-fenetrebw1000/",sep=""),"", Host, 10,50)



arg <- args[[1]]
iperf.bw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[2]]
iperf.bw1000 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[3]]
iperf.bw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[4]]
iperf.bw500 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[5]]
iperf.bw1000maxq10000 <- iperf_bw(arg[1],arg[2],arg[3],arg[4],arg[5])
arg <- args[[6]]
iperf.bw1000maxq1e7 <- iperf_bw(arg[1],arg[2],arg[3],arg[4],arg[5])


n <- 6
rcolor <- rainbow(n, s = 1, v = 1, start = 0.6, end = 0.1, alpha = 1)


pdf("ws.pdf",useDingbats=FALSE)
with(iperf.bw100,plot((rate/1000000)~bw,pch=16,
                      ylim=c(0,600),
                      xlab="débit par lien (Mbit/s)",
                      ylab="débit total (Mbit/s)",
                      col=rcolor[1]))
with(iperf.bw200,points((rate/1000000)~bw,pch=16,col=rcolor[2]))
with(iperf.bw500,points((rate/1000000)~bw,pch=16,col=rcolor[3]))
with(iperf.bw1000,points((rate/1000000)~bw,pch=16,col=rcolor[4]))
with(iperf.bw1000maxq10000,points((rate/1000000)~bw,pch=16,col=rcolor[5]))
with(iperf.bw1000maxq1e7,points((rate/1000000)~bw,pch=16,col=rcolor[6]))
abline(0,1)

legend("topright", # la position sur le graphique
       c("100", "200","500","1000","1000 maxQ","1000 maxQ 1e7"), # le texte pour chaque courbe
       col=c(rcolor[1],rcolor[2],rcolor[3],rcolor[4],rcolor[5],rcolor[6]),
       pch=c(16,16)
)
dev.off()








          
