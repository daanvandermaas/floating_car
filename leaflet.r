

shape = readRDS('db/shape_wgs.rds')
#shape = readRDS('db\shape_wgs.rds')

shape@data$goed = NA
     
for(i in 1:nrow(shape@data)){

coor = shape@lines[[i]][[1]]

x = coor[,1]
y = coor[,2]
coor[,1] = y
coor[,2] = x

map = leaflet(coor) 
map = addTiles(map)

map =   addPolylines(map)
map = setView(map, zoom = 15, lat = x[1] , lng=y[1] )
print(map)

shape@data$goed[i] = readline(prompt="goed =1 fout = 2?: ")
}

saveRDS(shape, file = 'db/shape.rds')