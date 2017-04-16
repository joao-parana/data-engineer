#! /usr/bin/env Rscript 

remove_out_location<-function(x)
{
  #latitude m?xima: -22.691005
  x$latrj <- (-22.691005 > x$lat)
  x1<-x[x$latrj==TRUE,]
  rm(x)
  
  #latitude m?nima: -23.090163
  x1$latrj <- (-23.106380 < x1$lat)
  x2<-x1[x1$latrj==TRUE,]
  rm(x1)
  
  #longitude m?xima: -42.970757
  x2$longrj <- (-42.970757 > x2$long)
  x3<-x2[x2$longrj==TRUE,]
  rm(x2)
  
  #-43.645340
  x3$longrj <- (-43.767319 < x3$long)
  x4<-x3[x3$longrj==TRUE,]
  rm(x3)
  
  x4$latrj = NULL
  x4$longrj = NULL
  
  return(x4)
}

remove_outliers <- function(x1, from)
{
  filter <- c(1:from)
  q <- as.data.frame(lapply(x1[-filter], quantile, na.rm = TRUE))
  for (i in (from+1):ncol(x1))
  {
    h <- i - from
    IQR <- q[4,h] - q[2,h]
    q1 <- q[2,h] - 3*IQR
    q2 <- q[4,h] + 3*IQR
    cond <- x1[,i] >= q1 & x1[,i] <= q2
    x1 <- x1[cond,]
  }
  return (x1)
}

get_distance <- function(y)
{
  y <- y[order(y$cod, y$datetime), ]
  
  cod <- y$cod
  cod <- as.integer(cod)
  codx1 <- c(cod[2:length(cod)],0)
  cond <- cod != codx1
  
  t <- as.numeric(y$datetime)
  tx1 <- c(t[2:length(t)],NA)
  dt <- tx1 - t
  dt[cond | is.na(dt) | dt < 60] <- 60
  
  #lat <- y$lat
  #y$latx1 <- c(lat[2:length(lat)],NA)
  #lat = (lat-min(lat))/(max(lat)-min(lat))
  #latx1 <- c(lat[2:length(lat)],NA)
  
  #long <- y$long
  #y$longx1 <- c(long[2:length(long)],NA)
  #long = (long-min(long))/(max(long)-min(long))
  #longx1 <- c(long[2:length(long)],NA)
  
  m1<-matrix(c(y$lat,y$long),ncol=2)
  m2<-matrix(c(c(y$lat[2:length(y$lat)],NA),c(y$long[2:length(y$long)],NA)),ncol=2)
  
  y$dist <- distHaversine(m1, m2)
  
  return(y)
}

remove_dist_outliers <- function (y)
{
  i <- 1
  cond <- TRUE
  #while (cond && i < 120) {
  #while (cond && i < 10) {
  y <- get_distance(y)
  from <- length(names(y))-1
  x <- remove_outliers(y, from)
  cond <- (nrow(x) < nrow(y))
  y <- x
  i <- i+1
  #}
  print(paste("remove_dist_outliers", i))
  return (y)
}

sequence <- function (y)
{
  y <- y[order(y$cod, y$datetime), ]
  x <- c(1:nrow(y))
  
  df <- data.frame(as.integer(y$cod))
  cod <- y$cod
  #df$codx1 <- c(0,cod[1:(length(cod)-1)])
  #codx1 <- df$codx1
  #df$cond <- cod != codx1
  
  
  #cod <- as.integer(cod)
  codx1 <- c(0,cod[1:(length(cod)-1)])
  cond <- cod != codx1
  l <- as.integer(length(x)-1)
  for (i in 1:l) {
    if (cond[i] == TRUE)
      j <- 1
    x[i] <- j
    j <- j + 1
  }
  y$seq <- x
  return (y)
}

readFile <- function(dirname)
{
  filebusdt <- paste0(dirname)
  tbl <- read.table(filebusdt, header= FALSE, sep=",")
  names(tbl)[1]="datetime"
  names(tbl)[2]="cod"
  names(tbl)[3]="linha"
  names(tbl)[4]="lat"
  names(tbl)[5]="long"
  names(tbl)[6]="velocidade"
  tbl <- unique(tbl)
  return (tbl);
}

writeFile <-function(dirname, table)
{
  newfile <- paste0(dirname, "/bus_treated_data.csv")
  newfileR <- paste0(dirname, "/bus_treated_data.RData")
  save(table, file=newfileR)
  write.csv(table, file=newfile, row.names = FALSE, quote = FALSE, sep = ',')
}
#path <- commandArgs()[1]
#write('stdin')
#Reading input from STDIN
f <- file("stdin")
open(f)
data <- c()
while(length(line <- readLines(f,n=1, warn = FALSE)) > 0) {
  data <- c(data, line)
}
print(data)
#f <- readFile(data)
#v <- function(...) cat(sprintf(...), sep='', file=stderr())
#write(f)

#writeFile("/Users/bernardo/Downloads/Spark/",f)


#Reading input from STDIN, method 2
#data <- read.table(file("stdin"), header=F, fill=T, sep="\t")
 

