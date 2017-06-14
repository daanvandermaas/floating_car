minlon <- 3.31
maxlon <- 7.18
loninc <- 0.0176875784440828

minlat <- 50.72
maxlat <- 53.47
latinc <- 0.0176830629261852

step=c(latinc/2+0.000898311,loninc/2+0.000930925)

raster = data.frame( 'lat' = seq(minlat, maxlat, latinc) , 'freq' =  length(  seq(minlon, maxlon, loninc))  , stringsAsFactors = FALSE)
raster =expandRows(raster,  'freq')
raster$lon = seq(minlon, maxlon, loninc)

raster_links <- raster-step
raster_rechts <- raster+step



map = leaflet() 
map = addTiles(map)

map =   addCircles(map, lat = raster_links$lat, lng = raster_links$lon)
map =   addCircles(map, lat = raster_rechts$lat, lng = raster_rechts$lon)
print(map)
