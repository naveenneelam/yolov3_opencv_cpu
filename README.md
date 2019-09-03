# yolov3-opencv-cpu
Docker file for creating yolov3 for AI image detection with opencv support and cpu version based on ubuntu OS, includes script to install labelimg also  which is used for labelling the images necessary for training in yolov3 object detection algorithm.

Docker file does the following

1. grab the ubuntu image
2. install files required for building opencv,python3 and labelimg application
3. download and compile opencv 
4. download and install yolov3 with opencv support and with cpu support only
5. download/copy sample images
6. execute the sample script
