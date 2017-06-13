
if(! dir.exists('db/plaatjes_beoordeeld')){
  dir.create('db/plaatjes_beoordeeld')
}

#lees filenames en bepaal het aantal
files = list.files('db/plaatjes_beoordeeld')
#unique pakken van de nummers
nummers = unique(sapply( strsplit(files, '[_.]') , function(x){
  as.numeric(x[2])
  
}))



shape = readRDS('db/shape_wgs.rds')






setwd('db/plaatjes_beoordeeld')

#welke nummers moeten we langs gaan?
nummers = setdiff(c( which(shape@data$goed == 1), which(shape@data$goed == 2) ), nummers)




###########maak cluster aan
no_cores <- detectCores() - 4
cl <- makeCluster(no_cores)

clusterCall(cl, function() { 
  library(leaflet)
  library(mapview)
  
})

clusterExport(cl=cl, list("shape", "nummers"),
              envir=environment())
##########




parSapply(cl,nummers, function(i){

  
  #lees de coordinaten en wissel ze om
  coor = shape@lines[[i]][[1]]
  x = coor[,1]
  y = coor[,2]
  coor[,1] = y
  coor[,2] = x
  
  #maak achtergrond kaar en sla op
  map = leaflet(coor) 
  map = addTiles(map)
  map = setView(map, zoom = 15, lat = x[1] , lng=y[1] )
  map = addProviderTiles(map, providers$OpenStreetMap)
  
  mapshot(map, url = NULL, file = paste0('kaart_', i, '.png'), remove_url = TRUE)
  
  
  


  #maak alleen de lijn en sla het op
  map = leaflet(coor) 
  map = setView(map, zoom = 15, lat = x[1] , lng=y[1] )
  map =   addPolylines(map)
  mapshot(map, url = NULL, file = paste0('lijn_', i, '.png'), remove_url = TRUE)
  
  
  
  
})
setwd("/home/beheerder/R/floating_car")
stopCluster(cl)