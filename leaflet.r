

shape = readRDS('db/shape_wgs.rds')
#shape = readRDS('db\shape_wgs.rds')

if('goed'% in % colnames){shape@data$goed = NA}
     
for(i in 1:nrow(shape@data)){
if(is.na(shape@data$goed)){
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
}

saveRDS(shape, file = 'db/shape_wgs.rds')