cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

#compare 
args <- commandArgs(trailingOnly = TRUE)
#arg 1 : path : "$PWD/folder/" must end with a "/"
#arg 2 : prefix name example: "exp001_TC_runTC"
#arg 3 : "client" or "server"
#arg 4 : start
#arg 5 : end
path <- args[1]
fname <- args[2]
host <- args[3]
start <- args[4]
end <- args[5]


iperf.df <- iperf_bw(path,fname,host,start,end)


pdf("toto.pdf")
with(iperf.df,plot((rate/1000000)~bw,pch=16,xlab="débit par lien (Mbit/s)",ylab="débit total (Mbit/s)"))
legend("bottomright", # la position sur le graphique
       c("MPTCP n=2", "TCP"), # le texte pour chaque courbe
       col=c("black", "red"), # La couleur de chaque courbe
       pch=c(16,16),
       lwd=c(1,1), # L'épaisseur de chaque courbe
       lty=c(1,3) # Le type de trait de chaque courbe
)
dev.off()








          
