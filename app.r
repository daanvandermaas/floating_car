#laad packages
source('packages.r')
#lees shape in en sla op als shape.rds
source('lees_shape.r')
#reken de coordinaten om naar wsg en sla op als shape_wgs.rds
source('omrekenen_shape.r')
#teken op de kaart en label de plaatjes
source('leaflet.r')
#sla de plaatjes op als een laag voor de achtergrond en eenn laag voor de lijn
source('plaatjes_opslaan.r')
#Maak een neuraalnetwerk input van de plaatjes (toekomstig)
source('input_neuraalnet.r')
#train neuraalnetwerk en sla het op (toekomstig)
#laad neuraalnetwerk (toekomstig)


