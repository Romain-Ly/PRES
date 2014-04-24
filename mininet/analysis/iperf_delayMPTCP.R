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


args[[1]] <- c(paste(cur_wd,"/delaybas-exp-bw10/",sep=""), "exp001_TC_runbasdelay", host, 10,50)
args[[2]] <- c(paste(cur_wd,"/delaybas-exp-bw20/",sep=""), "exp001_TC_runbasdelay", host, 10,50)
args[[3]] <- c(paste(cur_wd,"/delaybas-exp-bw50/",sep=""), "exp001_TC_runbasdelay", host, 10,50)
args[[4]] <- c(paste(cur_wd,"/delaybas-exp-bw100/",sep=""), "exp001_TC_runbasdelay", host, 10,50)
args[[5]] <- c(paste(cur_wd,"/delaybas-exp-bw200/",sep=""), "exp001_TC_runbasdelay", host, 10,50)


arg <- args[[1]]
iperf.bw10 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw10 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[2]]
iperf.bw20 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw20 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[3]]
iperf.bw50 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw50 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[4]]
iperf.bw100 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw100 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")

arg <- args[[5]]
iperf.bw200 <- iperf_bw( arg[1],arg[2],arg[3],arg[4],arg[5],split="y")
ping.bw200 <- ping_f(arg[1],arg[2],"172.16.0.2",2,split="y")


if (!is.na(pref)){
  output_name <- paste(pref,"_rtt.pdf")
} else {
  output_name <- "rtt.pdf"
}


W=7
H=8
pdf(output_name,
    width=W,
    height=H,
    )

n <- 5
rcolor <- rainbow(n, s = 1, v = 1, start = 0.6, end = 0.1, alpha = 1)

with(iperf.bw10,plot((rate/1000000)~ping.bw10$avg,pch=16,
                     ylim=c(0,300),
                     xlab="RTT (ms)",
                     ylab="débit total (Mbit/s)",
                     col=rcolor[1]))
with(iperf.bw20,points((rate/1000000)~ping.bw20$avg,pch=16,col=rcolor[2]))
with(iperf.bw50,points((rate/1000000)~ping.bw50$avg,pch=16,col=rcolor[3]))
with(iperf.bw100,points((rate/1000000)~ping.bw100$avg,pch=16,col=rcolor[4]))
with(iperf.bw200,points((rate/1000000)~ping.bw200$avg,pch=16,col=rcolor[5]))

legend("topright", # la position sur le graphique
       title="débit par lien (Mbit/s)",
       c("10","20","50","100","200"),
       col=c(rcolor[1], rcolor[2], rcolor[3], rcolor[4], rcolor[5]),
       pch=c(16),
       bty="n"
)
print("file_name")
print(output_name)
dev.off()








          
