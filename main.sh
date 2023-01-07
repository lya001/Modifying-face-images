#!/bin/bash

# Rotate-and-Render
sh randr.sh $1

# GFPGAN
sh gfpgan.sh randr_results

# Finish
mv gfpgan_results output
