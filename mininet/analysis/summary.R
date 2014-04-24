cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)


args <- commandArgs(trailingOnly = TRUE)
#arg 1 : path : "$PWD/folder/" must end with a "/"
#arg 2 : prefix name example: "exp001_TC_runTC0"
path <- args[1]
fname <- args[2]

fname_abs <- paste(path,fname,sep="")

#ping
ping_list <- list.files(path=path,pattern=paste(fname,"_","ping",sep=""),full.names=TRUE)
#iperf
iperf_list <- list.files(path=path,pattern=paste(fname,"_","iperf",sep=""),full.names=TRUE)
#bwm-ng
bwm_list <- list.files(path=path,pattern=paste(fname,"_","bwm",sep=""),full.names=TRUE)

for(i in 1:length(ping_list)) {
  print(ping_list[i])
  print(iperf_list[i])
  print(bwm_list[i])
  print(ping_analysis(ping_list[i]))
  print(iperf_analysis(iperf_list[i]))
  print(head(bwm_analysis(bwm_list[i],"h1-eth1")))
}

#iperf








          
