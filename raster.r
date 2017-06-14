minlon <- 3.31
maxlon <- 7.18
loninc <- 0.0176875784440828
minlat <- 50.72
maxlat <- 53.47
latinc <- 0.0171830629261852
x = data.frame()
for(i in seq(minlat, maxlat, latinc)){
  for(j in seq(minlon, maxlon, loninc)){
    x = rbind(x, c(i,j))
  }
}