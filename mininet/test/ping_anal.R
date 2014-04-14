
ping_analysis <- function(filestring){
  conn <- file(description=filestring,open="r")
  readLines(conn,n=3)
  ploss_raw <- readLines(conn,n=1)
  rtt_raw <- readLines(conn,n=1)
  ploss <- as.numeric(strsplit(ploss_raw,split=" ")[[1]][c(1,4)]) #packets sent / received
  rtt <- strsplit(rtt_raw,split=" ")[[1]]
  rtt.avg <- as.numeric(strsplit(rtt[4],split="/")[[1]]) # parse min/avg/max/mdev rtt
  rtt.ipg <- as.numeric(strsplit(rtt[9],split="/")[[1]]) # parse ipg/ewmda
  close(conn)
  result <- data.frame(name=c("min","avg","max","mdev","ipg","ewmda","pk_sent","pk_loss"),
                       value=c(rtt.avg,rtt.ipg,ploss))
  return(result)
}

  
  
  
