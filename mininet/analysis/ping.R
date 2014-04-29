cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
source("iperf_anal.R")
source("ping_anal.R")
source("bw_anal.R")
setwd(cur_wd)


args <- commandArgs(trailingOnly = TRUE)
#arg 1 : path : "$PWD/folder/" must end with a "/"
#arg 2 : prefix name example: "exp001_TC_runTC0"
#arg 3 : h1 or sv_mp1..
#arg 4 : interface
#arg 5 : one of c("unix_timestamp","iface_name","bytes_out_s","bytes_in_s","bytes_total_s","bytes_in","bytes_out","packets_out_s","packets_in_s","packets_total_s","packets_in","packets_out","errors_out_s","errors_in_s","errors_in","errors_out")
path <- args[1]
fname <- args[2]
host <- args[3]
eth <- args[4]


fname_abs <- paste(path,fname,sep="")
host_grep <- paste("bwm_",host,sep="")

pattern = paste("'","bwm_",args[3],"-",args[4],"'",sep="")
#bwm

z <- pipe(paste("ls -rt ",path," | grep ",pattern),"")
bwm_list <- readLines(z)
close(z)
print(bwm_list)

n <- length(bwm_list)
bwm.l <-list()

for(i in 1:n) {
  file.path <- paste(args[1],bwm_list[i],sep="")
  bwm_tp <- bwm_analysis(file.path)
  index <- strsplit(strsplit(bwm_list[i],split="_")[[1]][3],split="w")[[1]][2]
  print(index)
  bwm.l[index]=bwm_tp[args[5]]
  #bwm.df <- cbind(bwm.df,bwm_tp[args[5]])
  #print(bwm_tp)
}

str(bwm.l)
bwm.l[[1]]


pdf("toto.pdf")
plot(bwm.l[[n]],type="l")
for (i in seq(n-1,1,-1))
lines(bwm.l[[i]],type="l",col="grey")
dev.off()





          
