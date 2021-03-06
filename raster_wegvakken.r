if(!dir.exists('db/raster_plaatjes')){
  dir.create('db/raster_plaatjes')
}
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

####maak cluster
no_cores <- detectCores() - 1

cl <- makeCluster(no_cores)



clusterExport(cl, c('shape', 'maxs', 'mins','coords'))
#############

parSapply(cl, c(1:nrow(coords)), function(N){



nummers = unique(coords$nummer[(coords$lat > mins$lat[N] )  &  (coords$lat < maxs$lat[N] )  & ( coords$lon > mins$lon[N]   )    & ( coords$lon < maxs$lon[N]   )])

length(nummers)

if(length(nummers)>0){




wegvakken = lapply(nummers, function(i){
  return(shape@lines[[i]][[1]])
  
})

png(paste0('db/raster_plaatjes/', N, '.png'))
plot(x = c(maxs$lon[N], mins$lon[N]), y = c(maxs$lat[N], mins$lat[N]) )


for(i in 1:length(wegvakken)){
  lines(x= wegvakken[[i]][,2],  y = wegvakken[[i]][,1] )
}

dev.off()


}#eind ifstatement

})

stopCluster(cl)























#map = leaflet() 
#map = addTiles(map)

#for(i in 1:length(wegvakken)){
#  map =   addPolylines(map, lat= wegvakken[[i]][,1] , lng = wegvakken[[i]][,2] )
#}


#map = addCircleMarkers(map , lat= maxs$lat[N], lng = maxs$lon[N], color = 'red')

#map = addCircleMarkers(map , lat= mins$lat[N], lng = mins$lon[N], color = 'red')
#print(map)
#print(N)
