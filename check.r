for(i in 1:nrow(train)){
  
  print(train_labels[i,])
  image(input[i,,,4])
  browser()
  image(input[i,,,2])
  browser()
  
}



sess$run(y_conv, feed_dict = dict(x = train, keep_prob = 1))

sess$run(correct_prediction, feed_dict = dict(x = train, keep_prob = 1, y_ = train_labels))

