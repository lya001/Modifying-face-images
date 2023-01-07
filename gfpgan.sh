#!/bin/bash

# Clone repo
git clone https://github.com/lya001/GFPGAN.git
cd GFPGAN

# Install dependent packages
pip install basicsr
pip install facexlib
pip install -r requirements.txt
python setup.py develop
pip install realesrgan

# Download pre-trained model
wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P experiments/pretrained_models

# Inference
python inference_gfpgan.py -i $1 -o ../gfpgan_results -v 1.3 -s 2

# cleanup
cd ..
