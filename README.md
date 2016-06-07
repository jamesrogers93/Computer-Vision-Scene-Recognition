# Computer Vision - Scene Recognition

My computer vision coursework submitted at the University of East Anglia.

The project classifies scenes from a subset of the SUN database in to 15 categories: Kitchen, Store, Bedroom, LivingRoom, House, Industrial, Stadium, Underwater, TallBuilding, Street, Highway, Field, Coast, Mountain, Forest.

Image features extraction techniques used:
  - Tiny Images
  - Colour Histogram
  - Bag of SIFT + colour
  - Bag of HOG2X2
  - Spatial Pyramid Kernel SIFT + colour
  - Spatial Pyramid Kernel HOG2X2
 
Classifiers used to classify the image features:
  - K Nearest Neighbour
  - Support Vector Machine
  

### Example Result

An example result using the Spatial Pyramid Kernel HOG2X2 with the Support Vector Machine.

Accuracy: 76.5%

Confusion matrix: 

![alt text](https://raw.githubusercontent.com/jamesrogers93/computer-vision-scene-recognition/master/figures/hog-confusion-matrix.png "Spatial Pyramid Kernel HOG2X2 with SVM")
  

### Installation

This project requires VLFeat to run. 

Download binary package at:
http://www.vlfeat.org/download.html

Then link VLFeat to the project in coursework2_starter.m at line 74:

```sh
74: run('{your_file_path}/vlfeat-{version}/toolbox/vl_setup');
```
