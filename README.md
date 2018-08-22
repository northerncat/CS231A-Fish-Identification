# CS231A Fish Identification

This repo contains my final project for CS231A in Winter 2015. I applied and evaluated different traditional classification algorithms using a dataset of underwater fish images. See the writeup for a detailed discussion of the theoretical content on classification algorithms and evaluations.

## Setup Instructions
### Dataset
I acquired the dataset from the authors of [Hsiao *et al.* (2014)](https://www.researchgate.net/publication/259163342_Real-world_underwater_fish_recognition_and_identification_using_sparse_representation), who collected the dataset as underwater footages from southern Taiwan, and processed the video frames to extract individual fish images. There are in total 25 fish species, each with 40 colored images.

### Implementation
The user can use ``readFishImages.m`` to read in the dataset, and then split it info training, validation, test and held-out sets with ``splitFolds.m``. After that, use ``buildTrainMatrix.m`` to train using the training set, and use ``src.m`` to apply Sparse Representation Classification on test set images.