#!/bin/bash

# CodeFormer
mkdir -p ./app/input
\cp $1 ./app/input
cd CodeFormer
mkdir -p aligned_input
python scripts/crop_align_face.py -i ../app/input -o aligned_input
python inference_colorization.py --input_path aligned_input
mv -f ./results/aligned_input/*.* ./results/aligned_input/$2
cd ..
mv -f ./CodeFormer/results/aligned_input/$2 ./app/results
rm -rf ./app/input
rm -rf ./CodeFormer/aligned_input
rm -rf ./CodeFormer/results
