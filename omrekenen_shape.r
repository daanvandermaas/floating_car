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



shape = readRDS('db/shape_wgs.rds')



shape@data$id = c(1:nrow(shape@data))
shape@data$WVK_BEGDAT = as.character(shape@data$WVK_BEGDAT)
shape@data$WVK_BEGDAT  = as.POSIXct(shape@data$WVK_BEGDAT, format = '%Y/%m/%d')
shape@data$WVK_ID = as.character(shape@data$WVK_ID)



shape@data <- arrange(shape@data,desc(WVK_ID), desc(WVK_BEGDAT))




shape@data <- shape@data[!duplicated(shape@data$WVK_ID),]

  
shape@lines =   lapply( shape@data$id , function(i){
    return(shape@lines[[i]])
  })
  

saveRDS(shape, file = 'db/shape_wgs.rds')