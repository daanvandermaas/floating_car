
shape = readOGR('db/bron/shape')
#shape = readOGR('db\bron\shape')

saveRDS(shape, file = 'db/shape.rds')
#saveRDS(shape, file = 'db\shape.rds')