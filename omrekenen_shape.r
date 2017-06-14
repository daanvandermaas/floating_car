no_cores <- detectCores() - 1

cl <- makeCluster(no_cores)

clusterCall(cl, function() { 
  library(rPython)
  py = python.load("omrekenen.py")
  
  })



shape = readRDS('db/shape.rds')
#shape = readRDS('db\shape.rds')



shape@lines =  parLapply(cl, coordinates(shape), function(x){
  
  
  
  x = lapply(x, function(z){
    
    
    z = apply(z, c(1), function(y){
   
   python.assign( 'coords', y)
   python.exec('wgsCoords = conv.fromRdToWgs( coords )')
      return( python.get('wgsCoords')) 
    })
    
    return(t(z))
    
  })
  
  return(x)
})





stopCluster(cl)

shape@data <- shape@data[order(shape@data$WVK_ID, -shape@data$WVK_BEGDAT), ] #sort by id and reverse of date
shape@data <- shape@data[!duplicated(shape@data$WVK_ID),]

saveRDS(shape, file = 'db/shape_wgs.rds')