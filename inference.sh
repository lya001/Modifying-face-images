#!/bin/bash

# GFPGAN
mkdir -p gfpgan_results1
cd GFPGAN
python inference_gfpgan.py -i ../$1 -o ../gfpgan_results1 -v 1.3 -s 2
cd ..

# Rotate-and-Render
# 1. copy images to 3ddfa/example/Images
rm -f Rotate-and-Render/3ddfa/example/Images/*
cp gfpgan_results1/restored_faces/* Rotate-and-Render/3ddfa/example/Images
# 2. generate 3ddfa/example/file_list.txt
cd Rotate-and-Render/3ddfa/example/Images
ls > ../file_list.txt
cd ../..
# 3. generate and save 3D parameters
python inference.py --img_list example/file_list.txt --img_prefix example/Images --save_dir results
cd ..
# 4. inference
bash experiments/v100_test.sh
cd ..
# 5. move results to ./randr_results
mkdir -p randr_results
mv Rotate-and-Render/results/rs_model/example/orig/* randr_results

# GFPGAN
mkdir -p gfpgan_results2
cd GFPGAN
python inference_gfpgan.py -i ../randr_results -o ../gfpgan_results2 -v 1.3 -s 2
cd ..

# Facial-Expression-Modifier
rm -f Facial-Expression-Modifier/input/*
cp gfpgan_results2/restored_faces/* Facial-Expression-Modifier/input
cd Facial-Expression-Modifier
python inference.py
cd ..
mkdir -p expr_results
mv Facial-Expression-Modifier/output/* expr_results

# GFPGAN
mkdir -p gfpgan_results3
cd GFPGAN
python inference_gfpgan.py -i ../expr_results -o ../gfpgan_results3 -v 1.3 -s 2
cd ..
mkdir -p output
cp gfpgan_results3/restored_faces/* output
