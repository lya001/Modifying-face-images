#!/bin/bash

# GFPGAN
mkdir -p ./app/input
\cp $1 ./app/input
cd GFPGAN
mkdir -p results
python inference_gfpgan.py -i ../app/input -o ./results -v 1.3 -s 2
mv -f ./results/restored_faces/*.* ./results/restored_faces/$2
cd ..
mv -f ./GFPGAN/results/restored_faces/$2 ./app/results
rm -rf ./app/input
rm -rf ./GFPGAN/results
