#maak directory
if(! dir.exists('db/neuraalnet/netwerk')){
  dir.create('db/neuraalnet/netwerk')
}
#lees train en test in
train = read_feather('db/training/delen/deel0.fe')
train_labels = read_feather('db/training/delen/train_labels.fe')
test = read_feather('db/training/delen/test.fe')
test_labels = read_feather('db/training/delen/test_labels.fe')

#maak er matrices van

train = as.matrix(train)
train_labels = as.matrix(train_labels)
test = as.matrix(test)
test_labels = as.matrix(test_labels)


max_accuracy = 0

clas = as.integer(ncol(train_labels))



hoogte = as.integer(100)
kanalen = as.integer(3)

#place holders

#input
x <- tf$placeholder(tf$float32, shape(NULL, hoogte*hoogte*kanalen))
#target values
y_ <- tf$placeholder(tf$float32, shape(NULL, clas))

x_in = tf$reshape(x, shape(-1L,hoogte, hoogte, kanalen))


#definieer sessie
sess <- tf$InteractiveSession()


#functie voor het maken van gewichten
weight_variable <- function(shape,name) {
  initial <- tf$truncated_normal(shape, stddev=0.1)
  return(tf$Variable(initial,name))
}

#functie voor het maken van biasses
bias_variable <- function(shape, name) {
  initial <- tf$constant(0.1, shape=shape)
  return(tf$Variable(initial, name))
}



#Convolutie functie
conv2d <- function(x, W) {
  return(tf$nn$conv2d(x, W, strides=c(1L, 1L, 1L, 1L), padding='SAME'))
}
#poolfunctie
max_pool_2x2 <- function(x) {
  return( tf$nn$max_pool(x,     ksize=c(1L, 2L, 2L, 1L),strides=c(1L, 2L, 2L, 1L), padding='SAME'))
}


###################### HET NETWERK


# eerste convolutie laag

#maak gewichten en biasses
W_conv1 <- weight_variable(shape(5L, 5L, kanalen, 40L), 'W_conv1')
b_conv1 <- bias_variable(shape(40L), 'b_conv1')

#maak van de input een tensor van batchx hoogte x breedte x kanalen




h_conv1 <- tf$nn$relu(conv2d(x_in, W_conv1) + b_conv1)
h_pool1 <- max_pool_2x2(h_conv1)




#tweede convolutie laag


W_conv2 <- weight_variable(shape = shape(5L, 5L, 40L, 64L), 'W_conv2')
b_conv2 <- bias_variable(shape = shape(64L), 'b_conv2')

h_conv2 <- tf$nn$relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 <- max_pool_2x2(h_conv2)

#derde convolutielaag

W_conv3 <- weight_variable(shape = shape(5L, 5L, 64L, 64L), 'W_conv2')
b_conv3 <- bias_variable(shape = shape(64L), 'b_conv2')

h_conv3 <- tf$nn$relu(conv2d(h_pool2, W_conv3) + b_conv3)


# eerste connected laag

W_fc1 <- weight_variable(shape( (hoogte*hoogte)/16 * 64L, 1024L), 'W_fc1')
b_fc1 <- bias_variable(shape(1024L), 'b_fc1')

#maak tensor vlak
h_conv3_flat <- tf$reshape(h_conv3, shape(-1L, (hoogte*hoogte)/16 *64L))
#bereken output
h_fc1 <- tf$nn$relu(tf$matmul(h_conv3_flat, W_fc1) + b_fc1)





#droupout rate eerste connected layer
keep_prob <- tf$placeholder(tf$float32)
h_fc1_drop <- tf$nn$dropout(h_fc1, keep_prob)




#output laag

W_fc2 <- weight_variable(shape(1024L, clas), 'W_fc2')
b_fc2 <- bias_variable(shape(clas), 'b_fc2')

y_conv <- tf$nn$softmax(tf$matmul(h_fc1_drop, W_fc2) + b_fc2)




#################### einde netwerk

#foutmarge

cross_entropy <- tf$reduce_mean(-tf$reduce_sum(y_ * tf$log( tf$clip_by_value(y_conv, 1e-10,1 )), reduction_indices=1L))

#train met de Adam optimizer learning rate 1e-4 en probeerd de cross entropy te minimaliseren
lrate <- tf$placeholder(tf$float32)

train_step <- tf$train$AdamOptimizer(lrate)$minimize(cross_entropy)

#vector van goed en fout
correct_prediction <- tf$equal(tf$argmax(y_conv, 1L), tf$argmax(y_, 1L))
#bereken percentage goede antwoorden
accuracy <- tf$reduce_mean(tf$cast(correct_prediction, tf$float32))

#initialiseer de shit
sess$run(tf$global_variables_initializer())



#train 20000 keer
for (i in 1:200000) {
  #lees 50 random plaatjes in
  samp = sample( dim(train)[1] , 50 )
  #train
  
  #valideer om de 100 keer hoe het gaat
  if (i %% 100 == 0) {
    #evalueel accuraatheid
    train_accuracy <- accuracy$eval(feed_dict = dict(      x = train  , y_ = train_labels, keep_prob = 1.0))
    #print acuraatheid
    print( paste('step' , i , 'training accuracy' , train_accuracy) )
    #evalueer op de testset
    test_accuracy <- accuracy$eval(feed_dict = dict(  x = test, y_ = test_labels, keep_prob = 1.0))
    #print resultaat
    print( paste("test accuracy", test_accuracy) )
    
    
    
    
    
    if(test_accuracy > max_accuracy  ){
      
      
      
      #sla op
      saveRDS(sess$run(W_conv1), file = 'db/neuraalnet/netwerk/w_conv1.rds')
      saveRDS( sess$run(b_conv1), file = 'db/neuraalnet/netwerk/b_conv1.rds' )
      saveRDS(sess$run(W_conv2), file = 'db/neuraalnet/netwerk/w_conv2.rds')
      saveRDS(sess$run(b_conv2), file = 'db/neuraalnet/netwerk/b_conv2.rds')
      saveRDS(sess$run(W_fc1) , file = 'db/neuraalnet/netwerk/w_fc1.rds')
      saveRDS(sess$run(b_fc1), file = 'db/neuraalnet/netwerk/b_fc1.rds')
      saveRDS(sess$run(W_fc2), file =  'db/neuraalnet/netwerk/w_fc2.rds' )
      saveRDS(sess$run(b_fc2), file =  'db/neuraalnet/netwerk/b_fc2.rds' )
      saveRDS(sess$run(W_conv3), file =  'db/neuraalnet/netwerk/w_conv3.rds' )
      saveRDS(sess$run(b_conv3), file =  'db/neuraalnet/netwerk/b_conv3.rds' )
      
      
      max_accuracy = test_accuracy
      
      print('nieuw reccord')
      
      
    }
    

    
  }
  
  
  train_step$run(feed_dict = dict(x = train[samp,] , y_ = train_labels[samp,], keep_prob = 0.2, lrate = 1e-4))
  
  
  
  
}


