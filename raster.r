minlon <- 3.31
maxlon <- 7.18
loninc <- 0.0176875784440828

minlat <- 50.72
maxlat <- 53.47
latinc <- 0.0171830629261852


raster = data.frame( 'lat' = seq(minlat, maxlat, latinc) , 'freq' =  length(  seq(minlon, maxlon, loninc))  , stringsAsFactors = FALSE)
raster =expandRows(raster,  'freq')
raster$lon = seq(minlon, maxlon, loninc)





map = leaflet() 
map = addTiles(map)

map =   addCircles(map, lat = raster$lat, lng = raster$lon)

print(map)
