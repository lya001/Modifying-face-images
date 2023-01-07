#!/bin/bash

# Rotate-and-Render
# 1. move images to 3ddfa/example/Images
# 2. generate 3ddfa/example/file_list.txt
# 3. bash experiments/v100_test.sh

# GFPGAN
cd GFPGAN
python inference_gfpgan.py -i ../randr_results -o ../output -v 1.3 -s 2
cd ..
