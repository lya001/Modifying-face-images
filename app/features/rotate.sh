#!/bin/bash

# Rotate-and-Render
# 1. copy image to 3ddfa/example/Images
rm -f ./Rotate-and-Render/3ddfa/example/Images/*
\cp $1 ./Rotate-and-Render/3ddfa/example/Images
# 2. generate 3ddfa/example/file_list.txt
cd ./Rotate-and-Render/3ddfa/example/Images
ls > ../file_list.txt
cd ../..
# 3. generate and save 3D parameters
python inference.py --img_list example/file_list.txt --img_prefix example/Images --save_dir results
cd ..
# 4. inference
bash experiments/v100_test.sh
cd ..
# 5. rename and move results to ./app/results
mv -f ./Rotate-and-Render/results/rs_model/example/orig/* ./Rotate-and-Render/results/rs_model/example/orig/$2
mv -f ./Rotate-and-Render/results/rs_model/example/orig/$2 ./app/results
rm -f ./Rotate-and-Render/3ddfa/example/Images/*
rm -f ./Rotate-and-Render/results/rs_model/example/orig/*
rm -f ./Rotate-and-Render/results/rs_model/example/aligned/*
