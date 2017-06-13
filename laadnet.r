library(tensorflow)

test = readRDS('db/training/test_60.rds')
test_labels = readRDS('db/training/test_labels_60.rds')


#definieer sessie
sess <- tf$InteractiveSession()



#Convolutie functie
conv2d <- function(x, W) {
  return(tf$nn$conv2d(x, W, strides=c(1L, 1L, 1L, 1L), padding='SAME'))
}
#poolfunctie
max_pool_2x2 <- function(x) {
  return( tf$nn$max_pool(x,     ksize=c(1L, 2L, 2L, 1L),strides=c(1L, 2L, 2L, 1L), padding='SAME'))
}


clas = as.integer(ncol(test_labels))

hoogte = as.integer(60)
kanalen = as.integer(3)


#laad in
#laad lagen in
W_conv1_laad = readRDS("db/neuraalnet/netwerk/w_conv1.rds")
W_conv1 = tf$constant(W_conv1_laad, dtype= tf$float32, shape= dim(W_conv1_laad), name= 'W_conv1')

b_conv1_laad = readRDS('db/neuraalnet/netwerk/b_conv1.rds')
b_conv1 = tf$constant(b_conv1_laad, dtype= tf$float32, shape= shape(dim(b_conv1_laad) ), name = 'b_conv1'    )

W_conv2_laad = readRDS('db/neuraalnet/netwerk/w_conv2.rds')
W_conv2 = tf$constant(W_conv2_laad, dtype= tf$float32, shape= dim(W_conv2_laad), name = 'W_conv2')

b_conv2_laad  = readRDS('db/neuraalnet/netwerk/b_conv2.rds')
b_conv2 = tf$constant(b_conv2_laad, dtype= tf$float32, shape= shape(dim(b_conv2_laad))  , name = 'b_conv2')

W_conv3_laad = readRDS('db/neuraalnet/netwerk/w_conv3.rds')
W_conv3 = tf$constant(W_conv3_laad, dtype= tf$float32, shape= dim(W_conv3_laad), name = 'W_conv3')

b_conv3_laad  = readRDS('db/neuraalnet/netwerk/b_conv3.rds')
b_conv3 = tf$constant(b_conv3_laad, dtype= tf$float32, shape= shape(dim(b_conv3_laad))  , name = 'b_conv3')

W_fc1_laad = readRDS('db/neuraalnet/netwerk/w_fc1.rds')
W_fc1 = tf$constant(W_fc1_laad, dtype= tf$float32, shape= dim(W_fc1_laad) , name = 'W_fc1')

b_fc1_laad = readRDS('db/neuraalnet/netwerk/b_fc1.rds')
b_fc1 = tf$constant(b_fc1_laad, dtype= tf$float32, shape= shape(dim(b_fc1_laad)), name = 'b_fc1' )

W_fc2_laad = readRDS('db/neuraalnet/netwerk/w_fc2.rds' )
W_fc2 = tf$constant(W_fc2_laad, dtype= tf$float32, shape= dim(W_fc2_laad) , name = 'W_fc2')

b_fc2_laad = readRDS('db/neuraalnet/netwerk/b_fc2.rds' )
b_fc2 = tf$constant(b_fc2_laad, dtype= tf$float32, shape= shape(dim(b_fc2_laad))  , name = 'b_fc2')


#input
x <- tf$placeholder(tf$float32, shape(NULL, hoogte*hoogte*kanalen))
#target values
y_ <- tf$placeholder(tf$float32, shape(NULL, clas))


x_in = tf$reshape(x, shape(-1L,hoogte, hoogte, kanalen))







###################### HET NETWERK


# eerste convolutie laag

h_conv1 <- tf$nn$relu(conv2d(x_in, W_conv1) + b_conv1)
h_pool1 <- max_pool_2x2(h_conv1)




#tweede convolutie laag

h_conv2 <- tf$nn$relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 <- max_pool_2x2(h_conv2)

#derde convolutielaag

h_conv3 <- tf$nn$relu(conv2d(h_pool2, W_conv3) + b_conv3)


# eerste connected laag

#maak tensor vlak
h_conv3_flat <- tf$reshape(h_conv3, shape(-1L, (hoogte*hoogte)/16 *64L))
#bereken output
h_fc1 <- tf$nn$relu(tf$matmul(h_conv3_flat, W_fc1) + b_fc1)





#droupout rate eerste connected layer
keep_prob <- tf$placeholder(tf$float32)
h_fc1_drop <- tf$nn$dropout(h_fc1, keep_prob)




#tweede connected laag

y_conv <- tf$nn$softmax(tf$matmul(h_fc1_drop, W_fc2) + b_fc2)

check = tf$matmul(h_fc1_drop, W_fc2) + b_fc2
####eind Netwerk






uitkomst = tf$arg_max(y_conv, 1L)

sess$run(uitkomst, feed_dict = dict(x = test, keep_prob = 1))