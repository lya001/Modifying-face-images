#!/bin/bash

#rm -rf input
#rm -rf GFPGAN/results
# GFPGAN
mkdir -p input
cp $1 input
cd GFPGAN
mkdir -p results
python inference_gfpgan.py -i ../input -o results -v 1.3 -s 2
mv results/restored_faces/*.* results/restored_faces/result.png
cd ..
rm -f result.png
cp GFPGAN/results/restored_faces/result.png ./
rm -rf input
rm -rf GFPGAN/results
