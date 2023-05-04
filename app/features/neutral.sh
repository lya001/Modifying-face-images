#!/bin/bash

# Facial-Expression-Modifier
rm -f ./Facial-Expression-Modifier/input/*
\cp $1 ./Facial-Expression-Modifier/input
cd Facial-Expression-Modifier
python inference.py
cd ..
mv -f Facial-Expression-Modifier/output/* Facial-Expression-Modifier/output/$2
mv -f Facial-Expression-Modifier/output/$2 ./app/results
