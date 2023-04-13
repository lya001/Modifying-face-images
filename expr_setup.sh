#!/bin/bash

# Clone repo
git clone https://github.com/lya001/Facial-Expression-Modifier.git
cd Facial-Expression-Modifier

# Download pretrained model
mkdir models
cd models
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1rXWEcAsBXz8-qt5xElhW94vGRtC7IsWA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1rXWEcAsBXz8-qt5xElhW94vGRtC7IsWA" -O StarGAN_Face_1_.model-32999.index && rm -rf /tmp/cookies.txt
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Llkvv65ZkOhVo31eeQbXgMfB2TRLSZBp' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Llkvv65ZkOhVo31eeQbXgMfB2TRLSZBp" -O StarGAN_Face_1_.model-32999.data-00000-of-00001 && rm -rf /tmp/cookies.txt
cd ..

# Create folder for input and output images
mkdir -p input
mkdir -p output

# Finish
cd ..
