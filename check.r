for(i in 1:nrow(train)){
  
  print(train_labels[i,])
  image(input[i,,,4])
  browser()
  image(input[i,,,2])
  browser()
  
}