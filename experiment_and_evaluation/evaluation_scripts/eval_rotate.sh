#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --has_aligned --input_path ../CelebChild_labelled/rotate
cd ..

# Rotate-and-Render
# 1. copy images to 3ddfa/example/Images
rm -f Rotate-and-Render/3ddfa/example/Images/*
\cp -f CodeFormer/results/rotate_0.5/restored_faces/* Rotate-and-Render/3ddfa/example/Images
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

# rename files
cd CodeFormer/results/orig_0.5/restored_faces
for name in *.png
do
    newname="$(echo "$name" | rev | cut -c8- | rev)"
    mv "$name" "$newname.png"
done
cd ../../../..

# move images
rm -f Rotate-and-Render/results/rs_model/example/orig/*
rm -f Rotate-and-Render/results/rs_model/example/aligned/*
\cp -f CodeFormer/results/orig_0.5/restored_faces/* results/rotate
rm -rf CodeFormer/results
