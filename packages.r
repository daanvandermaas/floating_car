library(parallel)
library(rgdal)
library(sp)
library(tmap)
library(sf)
library(pbapply)
library(rPython)
library(leaflet)
library(tensorflow)
library(animation)
library(devtools)
install_github("wch/webshot")
library(htmlwidgets)
library(webshot)
library(mapview)
## create map

## save html to png
saveWidget(map, "temp.html", selfcontained = FALSE)
webshot("temp.html", file = "Rplot.png",
        cliprect = "viewport")


m <- leaflet() %>% addTiles()
mapshot(m, file = "Rplot.png")

## 'mapview' objects (image below)
m2 <- mapview(breweries91)
mapshot(m2, file = "breweries.png")
