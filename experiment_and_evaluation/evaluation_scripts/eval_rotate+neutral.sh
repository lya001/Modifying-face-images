#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --has_aligned --input_path ../CelebChild_labelled/rotate+neutral
cd ..

# Rotate-and-Render
# 1. copy images to 3ddfa/example/Images
rm -f Rotate-and-Render/3ddfa/example/Images/*
\cp -f CodeFormer/results/rotate+neutral_0.5/restored_faces/* Rotate-and-Render/3ddfa/example/Images
rm -rf CodeFormer/results
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
# 5. rename files
cd Rotate-and-Render/results/rs_model/example/orig
for name in yaw_0.0_*
do
    newname="$(echo "$name" | cut -c9-)"
    mv "$name" "$newname"
done
cd ../../../../..

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --input_path ../Rotate-and-Render/results/rs_model/example/orig
cd ..
rm -f Rotate-and-Render/3ddfa/example/Images/*
rm -f Rotate-and-Render/results/rs_model/example/orig/*
rm -f Rotate-and-Render/results/rs_model/example/aligned/*

# Neutral Expression
rm -f ./Facial-Expression-Modifier/input/*
rm -f ./Facial-Expression-Modifier/output/*
\cp -f CodeFormer/results/orig_0.5/restored_faces/* ./Facial-Expression-Modifier/input
rm -rf CodeFormer/results
cd Facial-Expression-Modifier
python inference.py
cd ..

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --input_path ../Facial-Expression-Modifier/output
cd ..
rm -f ./Facial-Expression-Modifier/input/*
rm -f ./Facial-Expression-Modifier/output/*

## rename files
cd CodeFormer/results/output_0.5/restored_faces
for name in *.png
do
    newname="$(echo "$name" | rev | cut -c11- | rev)"
    mv "$name" "$newname.png"
done
cd ../../../..

# move images
\cp -f CodeFormer/results/output_0.5/restored_faces/* results/rotate+neutral
rm -rf CodeFormer/results
