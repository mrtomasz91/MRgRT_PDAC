# MRgRT_PDAC
Analysis code for radiomic quantification of Magnetic Resonance guided Radiotherapy images
The code in this repository can be used to process images from 0.35T Magnetic Resonance guided Radiotherapy system with the aim of quantifying radiomic features and association with outcome. 
Script ProcessingFromRaw.m takes dicom images and RT structures as exported directly from the system and combines them into full image matrices and corresponding Regions of Interest
These can then be saved as .mat matrices for further processing and quantification
Script ProcessingForFeatureQuant.m reads these as well as the healthy tissue ROIs drawn offline and enables quantification of radiomic features according to the Image Biomarker Standardization Initiative guidelines
The code for quantification of the features can be obtained from https://theibsi.github.io/implementations/

For more information please email Michal Tomaszewski at em (dot) tomaszewski (at) gmail (dot) com
