#lees filenames en bepaal het aantal
files = list.files('db/plaatjes_beoordeeld')

max = max(sapply( strsplit(files, '[_.]') , function(x){
  as.numeric(x[2])
  
}))

#maak directory
if(! dir.exists('db/neuraalnet')){
  dir.create('db/neuraalnet')
}



w = 200
h= 200
c=4
df = data.frame()



for(i in 1:max){
  
  a = array(dim = c(w,h,c))

  
  
  
  #lees fotos in
  im_kaart = readImage(  paste0('db/plaatjes_beoordeeld/kaart_', i, '.png') )
  im_lijn = readImage(  paste0('db/plaatjes_beoordeeld/lijn_', i, '.png') )
  
  
  
  #resize
  im_kaart = resize(im_kaart, w = w, h = h)
  #resize
  im_lijn = resize(im_lijn, w = w, h = h)
  
  
  
  #im_kaart = channel(im_kaart, "grey")
  im_lijn = channel(im_lijn, "grey")
  
  
  
  
  
  a[,,1] = imageData(im_kaart[,,1])
  a[,,2] = imageData(im_kaart[,,2])
  a[,,3] = imageData(im_kaart[,,3])
  a[,,4] = im_lijn
  
  
  a = aperm(a, c(3,2,1))
  
  
  extra = matrix( a , ncol =1)
  
  #normaliseer df[N,,,]
  ma = max(extra)
  mi = min(extra)
  
  extra<- scale( extra,center = mi , scale = ma-mi)
  
  extra = matrix(extra, nrow = 1)
  df = rbind(df, extra)

}

write_feather(df, path = 'db/neuraalnet/train.rds')

