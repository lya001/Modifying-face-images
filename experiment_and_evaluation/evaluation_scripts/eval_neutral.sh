#!/bin/bash

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --has_aligned --input_path ../CelebChild_labelled/neutral
cd ..

# Neutral Expression
rm -f ./Facial-Expression-Modifier/input/*
rm -f ./Facial-Expression-Modifier/output/*
\cp -f CodeFormer/results/neutral_0.5/restored_faces/* ./Facial-Expression-Modifier/input
rm -rf CodeFormer/results
cd Facial-Expression-Modifier
python inference.py
cd ..

# CodeFormer
cd CodeFormer
python inference_codeformer.py -w 0.5 --input_path ../Facial-Expression-Modifier/output
cd ..

# rename files
cd CodeFormer/results/output_0.5/restored_faces
for name in *.png
do
    newname="$(echo "$name" | rev | cut -c8- | rev)"
    mv "$name" "$newname.png"
done
cd ../../../..

# move images
\cp -f CodeFormer/results/output_0.5/restored_faces/* results/neutral
rm -rf CodeFormer/results
