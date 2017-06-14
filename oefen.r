
shape <- readRDS('db/shape_wgs.rds')



maxs = data.frame()
mins = data.frame()

for(i in 1:10){
  
  
  ma = c( min(shape@lines[[i]][[1]][,1])  ,  min(shape@lines[[i]][[1]][,2])) 
  mi = c(  max( shape@lines[[i]][[1]][,1]  ), max( shape@lines[[i]][[1]][,2]  )) 
  
 ma = ma +0.05
  mi = mi - 0.05
  
  maxs = rbind(maxs, ma)
  mins = rbind(mins, mi)
 
  
  
}

colnames(maxs)= c('lat', 'lon')
colnames(mins)= c('lat', 'lon')

for(i in 1:10){

map = leaflet(   rbind(maxs[i,], mins[i,])  ) 
map = addTiles(map)
map = addCircles(map)
print(map)
browser()
}



#zoek nu de wegvakken op basis van mins en maxs

#gooi alle coordinaten bij elkaar
nummers = c(1: nrow(shape@data))

coords_list = sapply(nummers, function(i){
  return( cbind(i, shape@lines[[i]][[1]]  ))
})


coords <- ldply(coords_list, data.frame)

colnames(coords) = c('nummer', 'lat', 'lon')

#vind alle nummers waarvoor coordinaten ertussen liggen
i=1

nummers = unique(coords$nummer[(coords$lat > mins$lat[i] )  &  (coords$lat < maxs$lat[i] )  & ( coords$lon > mins$lon[i]   )    & ( coords$lon < maxs$lon[i]   )])






