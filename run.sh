type=$1

################# prepare data ################
lsc ./bin/map-src.ls "$type"
lsc ./bin/amino2hydrophobicity.ls "$type"
lsc ./bin/create-feature.ls "$type"

################# machine learning ################
svm-scale -s ./output/train-scale-model ./output/train.feature > ./output/train.scale
svm-scale -r ./output/train-scale-model ./output/test.feature > ./output/test.scale

## svm
# svm-train -b 1 -c 256 -g 256 ./output/train.scale ./output/train-result
# svm-predict -b 1 ./output/test.scale ./output/train-result ./result/svm-test-result

## rvkde
# ./bin/rvkde --best --cv --classify -n 5 -v ./output/train.scale -b 1,10,.1 --ks 1,10,1 --kt 1,10,1 --f-measure > ./output/rvkde-train-result
# ./bin/rvkde --best --predict --classify -v ./output/train.scale -V ./output/test.scale -b 1 --ks 60 --kt 60 > ./result/rvkde-test-result
