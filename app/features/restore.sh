#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --input_path ../$1
mv -f ./results/test_img_0.5/restored_faces/*.* ./results/test_img_0.5/restored_faces/$2
cd ..
cp -f ./CodeFormer/results/test_img_0.5/restored_faces/$2 ./app/results
rm -rf ./CodeFormer/results
