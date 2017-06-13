

shape = readRDS('db/shape_wgs.rds')
#shape = readRDS('db\shape_wgs.rds')

if(!('goed' %in% colnames(shape@data))){shape@data$goed = NA}
variabele_start<-Position(function(x) is.na(x),shape@data$goed)
for(i in variabele_start:nrow(shape@data)){
coor = shape@lines[[i]][[1]]

x = coor[,1]+rnorm(1,0,0.0005)
y = coor[,2]+rnorm(1,0,0.0005)
coor[,1] = y
coor[,2] = x

map = leaflet(coor) 
map = addTiles(map)

map =   addPolylines(map)
map = setView(map, zoom = 15, lat = x[1] , lng=y[1] )
print(map)

shape@data$goed[i] = readline(prompt="goed =1 fout = 2?: ")
}

saveRDS(shape, file = 'db/shape_wgs.rds')