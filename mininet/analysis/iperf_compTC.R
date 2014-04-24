cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)

shell_arg <- commandArgs(trailingOnly = TRUE)
pref <- shell_arg[1] #output file name prefix

host <- "client"

args <- list()


args[[1]] <- c(paste(cur_wd,"/delaybas-exp-bw20/",sep=""), "", host, 10,50)
args[[2]] <- c(paste(cur_wd,"/delayTC-exp-bw20/",sep=""), "", host, 10,50)

args[[3]] <- c(paste(cur_wd,"/delaybas-exp-bw100/",sep=""), "", host, 10,50)
args[[4]] <- c(paste(cur_wd,"/delayTC-exp-bw100/",sep=""), "",host,10,50)

args[[5]] <- c(paste(cur_wd,"/delaybas-exp-bw200/",sep=""), "", host, 10,50)
args[[6]] <- c(paste(cur_wd,"/delayTC-exp-bw200/",sep=""), "", host, 10,50)



arg <- args[[1]]
iperf.bw20 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw20 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[2]]
iperf.tcbw20 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.tcbw20 <- ping_f(arg[1],arg[2],"172.16.1.2",2,split="y")

arg <- args[[3]]
iperf.bw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw100 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[4]]
iperf.tcbw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.tcbw100 <- ping_f(arg[1],arg[2],"172.16.1.2",2,split="y")


arg <- args[[5]]
iperf.bw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw200 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[6]]
iperf.tcbw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.tcbw200 <- ping_f(arg[1],arg[2],"172.16.1.2",2,split="y")


if (!is.na(pref)){
  output_name <- paste(pref,"_tc.pdf")
} else {
  output_name <- "tc.pdf"
}


W=7
H=8
pdf(output_name,
    width=W,
    height=H,
    )

n <- 6
rcolor <- rainbow(n, s = 1, v = 1, start = 0.6, end = 0.1, alpha = 1)

with(iperf.bw20,plot((rate/1000000)~ping.bw20$avg,pch=16,
                     ylim=c(0,420),
                     xlab="RTT (ms)",
                     ylab="débit total (Mbit/s)",
                     col=rcolor[1]))
with(iperf.tcbw20,points((rate/1000000)~ping.tcbw20$avg,pch=16,col=rcolor[2]))
with(iperf.bw100,points((rate/1000000)~ping.bw100$avg,pch=16,col=rcolor[3]))
with(iperf.tcbw100,points((rate/1000000)~ping.tcbw100$avg,pch=16,col=rcolor[4]))
with(iperf.bw200,points((rate/1000000)~ping.bw200$avg,pch=16,col=rcolor[5]))
with(iperf.tcbw200,points((rate/1000000)~ping.tcbw200$avg,pch=16,col=rcolor[6]))


legend("topright", # la position sur le graphique
       title="débit par lien (Mbit/s)",
       c("20","20 TC","100","100 TC","200","200 TC"),
       col=c(rcolor[1], rcolor[2], rcolor[3], rcolor[4], rcolor[5],rcolor[6]),
       pch=c(16),
       bty="n"
)
print("file_name")
print(output_name)
dev.off()








          
