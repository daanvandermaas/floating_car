library(rgdal)
library(sp)
library(tmap)
library(sf)

shape = readOGR('db/bron/shape')

saveRDS(shape, file = 'db/shape.rds')