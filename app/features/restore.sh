#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.7 --input_path ../$1
mv -f ./results/test_img_0.7/restored_faces/*.* ./results/test_img_0.7/restored_faces/$2
cd ..
cp -f ./CodeFormer/results/test_img_0.7/restored_faces/$2 ./app/results
rm -rf ./CodeFormer/results
