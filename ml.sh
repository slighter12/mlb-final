## svm
# svm-train -b 1 -c 256 -g 3 ./output/train.scale ./output/train-result
# svm-predict -b 1 ./output/test.scale ./output/train-result ./result/svm-test-result

## rvkde
./bin/rvkde --cv --best --classify -n 5 -v ./output/train.scale -b 1,10,1 --ks 1,100,1 --kt 1,100,1 --f-measmure > ./output/rvkde-train-result
# ./bin/rvkde --best --predict --classify -v ./output/train.scale -V ./output/test.scale -b 1 --ks 11 --kt 23 > ./result/rvkde-test-result
