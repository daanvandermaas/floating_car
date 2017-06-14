
shape <- readRDS('db/shape_wgs.rds')

maxs = raster_rechts
mins = raster_links


#zoek nu de wegvakken op basis van mins en maxs

#gooi alle coordinaten bij elkaar
nummers = c(1: nrow(shape@data))

coords_list = sapply(nummers, function(i){
  return( cbind(i, shape@lines[[i]][[1]]  ))
})


coords <- ldply(coords_list, data.frame)

colnames(coords) = c('nummer', 'lat', 'lon')

#vind alle nummers waarvoor coordinaten ertussen liggen
for(N in 1:nrow(coords)){


nummers = unique(coords$nummer[(coords$lat > mins$lat[N] )  &  (coords$lat < maxs$lat[N] )  & ( coords$lon > mins$lon[N]   )    & ( coords$lon < maxs$lon[N]   )])

length(nummers)

if(length(nummers)>0){




wegvakken = lapply(nummers, function(i){
  print(i)
  return(shape@lines[[i]][[1]])
  
})

plot(x = c(maxs$lon[N], mins$lon[N]), y = c(maxs$lat[N], mins$lat[N]) )


for(i in 1:length(wegvakken)){
  lines(x= wegvakken[[i]][,2],  y = wegvakken[[i]][,1] )
}






}

}

























map = leaflet() 
map = addTiles(map)

for(i in 1:length(wegvakken)){
  map =   addPolylines(map, lat= wegvakken[[i]][,1] , lng = wegvakken[[i]][,2] )
}


map = addCircleMarkers(map , lat= maxs$lat[N], lng = maxs$lon[N], color = 'red')

map = addCircleMarkers(map , lat= mins$lat[N], lng = mins$lon[N], color = 'red')
print(map)
print(N)
