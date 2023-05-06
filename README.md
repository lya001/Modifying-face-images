# Modifying-face-images

### Project Title: Enhancing and modifying low quality face images for creating good quality 3D avatars

Aims to create an end-to-end framework to prepare a face image for avatar generation, which involves blind face restoration, face frontalization and facial expression manipulation.

Demo:[demo.webm](https://user-images.githubusercontent.com/60819523/236635676-52934956-ee53-4318-937e-49fb3d3fa4ae.webm)

## Usage
1. To set up the environment, do `sh setup.sh`
2. For a Graphical User Interface, do `python3 app/app.py`
3. For command-line batch processing, do `sh inference.sh`, passing the path to images directory as a parameter, e.g. `sh inference.sh ./input`

If cannot run locally, could submit `run.sh` to the Imperial DoC GPU cluster.
