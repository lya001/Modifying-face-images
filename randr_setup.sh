#!/bin/bash

# Clone repo
git clone https://github.com/lya001/Rotate-and-Render.git
cd Rotate-and-Render

# Install dependent packages
pip install -r requirements.txt
git clone https://github.com/lya001/neural_renderer.git
pip install -e neural_renderer

# Solve mesh_core_cython error
cd 3ddfa/utils/cython
python setup.py build_ext -i
cd ../..

# Download checkpoint and model
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1v31SOrGYueeDi2SxOAUuKWqnglEP0xwA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1v31SOrGYueeDi2SxOAUuKWqnglEP0xwA" -O ckpt_and_bfm.zip && rm -rf /tmp/cookies.txt
unzip ckpt_and_bfm.zip
cd ..

mkdir -p checkpoints
cd checkpoints
mkdir -p rs_model
cd rs_model
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Vdlpwghjo4a9rOdn2iJEVlPd0EJegAex' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Vdlpwghjo4a9rOdn2iJEVlPd0EJegAex" -O latest_net_G.pth && rm -rf /tmp/cookies.txt
cd ../../..

# Finish
cd ..
