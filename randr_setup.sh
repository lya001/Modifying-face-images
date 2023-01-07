#!/bin/bash

# Clone repo
https://github.com/lya001/Rotate-and-Render.git
cd Rotate-and-Render

# Install dependent packages
pip install -r requirements.txt
git clone https://github.com/lya001/neural_renderer.git
pip install neural_renderer

# Download checkpoint and model
wget https://drive.google.com/file/d/1v31SOrGYueeDi2SxOAUuKWqnglEP0xwA/view?usp=sharing -P 3ddfa/
unzip ckpt_and_bfm.zip
wget https://drive.google.com/file/d/1Vdlpwghjo4a9rOdn2iJEVlPd0EJegAex/view?usp=sharing -P checkpoints/rs_model/

# cleanup
cd ..
