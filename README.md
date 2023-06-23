# Modifying-face-images

### Project Title: Enhancing and modifying low-quality face images for creating good quality 3D avatars

<img width="1218" alt="visualization" src="https://github.com/lya001/Modifying-face-images/assets/60819523/ba1be2c7-fe91-4db4-9f0f-2453af8287e1">

Aims to create an end-to-end framework to prepare a face image for avatar generation, which involves blind face restoration, face frontalization and facial expression manipulation. A graphical user interface was also built for a more interactive experience.

![gui_processing](https://github.com/lya001/Modifying-face-images/assets/60819523/f5d2f2a9-8978-4abd-a226-e0596fa04c2a)

## Usage
1. To set up the environment, `sh setup.sh`
2. For a graphical user interface, `python3 app/app.py`
3. For batch processing, use `inference.sh`, passing the path to the input images directory as a parameter, e.g. `sh inference.sh ./input`
