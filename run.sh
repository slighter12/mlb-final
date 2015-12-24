################# prepare data ################
lsc ./bin/map-src.ls train
lsc ./bin/amino2hydrophobicity.ls train
lsc ./bin/create-feature.ls train

lsc ./bin/map-src.ls test
lsc ./bin/amino2hydrophobicity.ls test
lsc ./bin/create-feature.ls test

################# scale ################
svm-scale -s ./output/train-scale-model ./output/train.feature > ./output/train.scale
svm-scale -r ./output/train-scale-model ./output/test.feature > ./output/test.scale
