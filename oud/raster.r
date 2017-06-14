coor = shape@lines[[3]][[1]]

coor[1,1] = as.character(coor[1,1])
coor[1,1] =  gsub(  '[.]', '',  coor[1,1])

coor_om = as.numeric(substr(coor[1,1], 1,2)) *60*60*100 + as.numeric(substr(coor[1,1], 3,4))*60*100 + as.numeric(substr(coor[1,1], 5,6))*100 + as.numeric(substr(coor[1,1], 7,8))



  
  deel_1 = coor_om %% 100
  coor_om = coor_om - deel_1
  deel_2 = coor_om %% 100 *60
  coor_om = coor_om - deel_2
