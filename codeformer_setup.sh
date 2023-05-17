#!/bin/bash

# Clone repo
git clone https://github.com/sczhou/CodeFormer
cd CodeFormer

# Install dependent packages
pip install -r requirements.txt
python basicsr/setup.py develop
conda install -c conda-forge dlib

# Download pre-trained models
python scripts/download_pretrained_models.py facelib
python scripts/download_pretrained_models.py dlib
python scripts/download_pretrained_models.py CodeFormer

# finish
cd ..
