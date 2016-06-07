# Computer Vision - Scene Recognition

My computer vision coursework submitted at the University of East Anglia.

The project classifies scenes from a subset of the SUN database in to 15 categories: Kitchen, Store, Bedroom, LivingRoom, House, Industrial, Stadium, Underwater, TallBuilding, Street, Highway, Field, Coast, Mountain, Forest.

Image features extraction techniques used:
  - Tiny Images
  - Colour Histogram
  - SIFT
  - HOG
 
Classifiers used to classify the image features:
    - K Nearest Neighbour
    - Support Vector Machine
  

### Installation

This project requires VLFeat to run. 

Download binaries at :
http://www.vlfeat.org/download.html

Then link VLFeat to the project at line 74:

```sh
74: run('{your_file_path}/vlfeat-{version}/toolbox/vl_setup');
```
