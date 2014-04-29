
iperf_analysis <- function(filestring){
  conn <- file(description=filestring,open="r")
  iperf <- readLines(conn)
  result <- data.frame(vector(length=9))
  for (i in 1:length(iperf)){
  #dirty way to remove lines
    test <- suppressWarnings(as.numeric(substring(iperf[i],1,13)))
    if (!is.na(test)){
      row.split <- strsplit(iperf[i],split=",")[[1]]
      row.bool <- suppressWarnings(is.na(as.numeric(row.split)))
      row <- vector(length=length(row.split))
      for (i in seq(1,length(row))){
        if (!row.bool[i]){
          row[i] <- as.numeric(row.split[i])
        }
      }
      #rownames(row) <- seq(1,length(row)-1)
      result <- cbind(result,row)
    }
}
  dim.res <- dim(result)
#  print(dim.res)
  result <- as.data.frame(t(result[,2:dim.res[2]]))
  colnames(result) <- c("timestamp","ip.src","port.src","ip.dest","port.dest","chaitpas","interval","transfer","rate")
  rownames(result) <- seq(1,dim.res[2]-1)
  close(conn)

  return(result)
}

    
iperf_bw <- function(path,fname,host,start,end,split_char="w"){
  fname_abs <- paste(path,fname,sep="")#Attention fname non utilisé

  print(path)
  pattern = paste("'","iperf_",host,"'",sep="")
  print(pattern)
  
  z <- pipe(paste("ls -rt ",path," | grep ",pattern),"")
                                        #z <- pipe(paste("ls -rt",""))
  iperf_list <- readLines(z)
  close(z)

  n <- length(iperf_list)
  iperf.y <- vector(length=n)
  iperf.x <- vector(length=n)

  for(i in 1:length(iperf_list)) {
    file.path <- paste(path,iperf_list[i],sep="")
    iperf.x[i] <- as.numeric(strsplit(strsplit(iperf_list[i],split="_")[[1]][3],split=split_char)[[1]][2])
    print(iperf.x[i])
    iperf_tp <- iperf_analysis(file.path)[start:end,]
    iperf.y[i] <- mean(iperf_tp$rate)
#    iperf.df <- data.frame(bw=iperf.x,rate=iperf.y)  
  }
  iperf.df <- data.frame(bw=iperf.x,rate=iperf.y)
  return(iperf.df)
}
  
