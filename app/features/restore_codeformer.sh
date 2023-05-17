#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.7 --bg_upsampler realesrgan --face_upsample --input_path ../$1
mv -f ./results/test_img_0.7/final_results/*.* ./results/test_img_0.7/final_results/$2
cd ..
mv -f ./CodeFormer/results/test_img_0.7/final_results/$2 ./app/results
rm -rf ./CodeFormer/results
