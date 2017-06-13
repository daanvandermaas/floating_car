#lees filenames en bepaal het aantal
files = list.files('db/plaatjes_beoordeeld')

nummers = sapply( strsplit(files, '[_.]') , function(x){
  as.numeric(x[2])
  
})

#maak directory
if(! dir.exists('db/neuraalnet')){
  dir.create('db/neuraalnet')
}



w = 100
h= 100
c=4
df = data.frame()
df_labels = data.frame()
shape = readRDS('db/shape_wgs.rds')


pbsapply( nummers, function(i){

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
  
  if(shape@data$goed[i] == 1){
    label = c(1,0)
  }else{
    label = c(0,1)
  }
  
  df_labels = rbind(df_labels,label)

})


sample = sample(nrow(df), round(0.8*nrow(df)))

train = df[sample,]
test = df[-sample,]
train_labels[sample,]
test_labels[-sample,]


write_feather(train, path = 'db/neuraalnet/train.rds')
write_feather(test, path = 'db/neuraalnet/test.rds')
write_feather(train_labels, path = 'db/neuraalnet/train_labels.rds')
write_feather(test_labels, path = 'db/neuraalnet/test_labels.rds')




