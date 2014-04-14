cur_wd <- getwd()
setwd("/home/romain/M1/PRES/projet/mininet/R")#path to R files
path_files <- "/home/romain/M1/PRES/projet/mininet/analysis/test"
a=list.files(path=path_files,full.names=TRUE)
source("ping_anal.R")
setwd(cur_wd)


args <- commandArgs(trailingOnly = TRUE)
#arg 1 : prefix name example: "exp001_TC_runTC0"
print(args)

print(a[7])
ping_analysis(a[7])








          
