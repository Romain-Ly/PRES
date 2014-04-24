
ping_analysis <- function(filestring){
  conn <- file(description=filestring,open="r")

  #if error output at the beginning.
  z <- pipe(paste("wc -l ",filestring),"r") 
  line <- as.numeric(strsplit(readLines(z),split=" ")[[1]][1])
  close(z)
  
  readLines(conn,n=(line-5)+3)
  ploss_raw <- readLines(conn,n=1)
  rtt_raw <- readLines(conn,n=1)
  #print(ploss_raw)
  ploss_split <- strsplit(ploss_raw,split=" ")[[1]]
  ploss <- as.numeric(ploss_split[c(1,4)]) #packets sent / received
  ping_time <- (as.numeric(strsplit(ploss_split[10],split="m")[[1]][1]))
  
  rtt <- strsplit(rtt_raw,split=" ")[[1]]
  #print(rtt)
  rtt.avg <- as.numeric(strsplit(rtt[4],split="/")[[1]]) # parse min/avg/max/mdev rtt

  ipg <- length(rtt)
  if (ipg >= 10){
    index = 9
    rtt.ipg <- as.numeric(strsplit(rtt[index],split="/")[[1]]) # parse ipg/ewmda #may be 9 if pipe 2
  } else if (ipg>7) { 
    index = 7
    rtt.ipg <- as.numeric(strsplit(rtt[index],split="/")[[1]]) # parse ipg/ewmda #may be 9 if pipe 2
  } else {
    rtt.ipg <- c(0,0)
  }
  
  #print(length(rtt))
  #print(index)

  close(conn)
#  print(rtt.ipg)
  result <- data.frame(name=c("min","avg","max","mdev","ipg","ewmda","pk_sent","pk_loss","time"),
                       value=c(rtt.avg,rtt.ipg,ploss,ping_time))
  return(result)
}

#Hostname : 172.16.0.2
#n ; nb of subflow
ping_f <- function(path,fname,host,nsub,split_char="w"){

  fname_abs <- paste(path,fname,sep="")
  pattern = paste("'","ping_",host,"'",sep="")

  z <- pipe(paste("ls -rt ",path," | grep ",pattern),"")
  ping_list <- readLines(z)
  close(z)
  
  n <- length(ping_list)
  c <- list()
  output <- data.frame(name=c("x","min","avg","max","mdev","ipg","ewmda","pk_sent","pk_loss","time"))
  for(i in 1:n) {
    file.path <- paste(path,ping_list[i],sep="")
   # print(file.path)
    ping.x <- as.numeric(strsplit(strsplit(ping_list[i],split="_")[[1]][3],split=split_char)[[1]][2])
    ping.y <- ping_analysis(file.path)$value
    output <- data.frame(output,c(ping.x,ping.y))
  }
  
  output <- data.frame(apply(t(output)[-1,],c(1,2),as.numeric))
  colnames(output) <- c("x","min","avg","max","mdev","ipg","ewmda","pk_sent","pk_loss","time")
  rownames(output) <- 1:n
  return(output)
}

