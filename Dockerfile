FROM ubuntu:16.04

## Pyton installation ##
RUN apt-get update && apt-get install -y python3.5 python3-pip git

## OpenCV 3.4 Installation ##
RUN apt-get install -y build-essential cmake
RUN apt-get install -y pyqt5-dev-tools
RUN apt-get install -y nano qt5-default libvtk6-dev
RUN apt-get install -y zlib1g-dev libgtk2.0-dev pkg-config libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
RUN apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
RUN apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
RUN apt-get install -y unzip wget tesseract-ocr
RUN wget https://github.com/tzutalin/labelImg/archive/master.zip
RUN unzip master.zip
RUN rm master.zip && mv labelImg-master labelimg
RUN pip3 install -r labelimg/requirements/requirements-linux-python3.txt
RUN make labelimg/qt5py3
RUN rm labelimg/data/predefined_classes.txt && touch labelimg/data/predefined_classes.txt
RUN wget https://github.com/opencv/opencv/archive/3.4.0.zip
RUN unzip 3.4.0.zip
RUN rm 3.4.0.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/3.4.0.zip
RUN unzip 3.4.0.zip
RUN rm 3.4.0.zip
WORKDIR /opencv-3.4.0
RUN mkdir build
WORKDIR /opencv-3.4.0/build
RUN cmake -DBUILD_EXAMPLES=OFF \ -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.4.0/modules \
.. && make -j4 && make install && ldconfig 

## Downloading and compiling darknet ##
WORKDIR /
RUN apt-get install -y git && \
git clone https://github.com/pjreddie/darknet.git
WORKDIR /darknet
# Set OpenCV makefile flag
RUN sed -i '/OPENCV=0/c\OPENCV=1' Makefile
RUN make
ENV DARKNET_HOME /darknet
ENV LD_LIBRARY_PATH /darknet

## Download and compile YOLO3-4-Py ##
WORKDIR /
RUN git clone https://github.com/madhawav/YOLO3-4-Py.git
WORKDIR /YOLO3-4-Py
RUN pip3 install pkgconfig cython pillow requests pytesseract
RUN python3 setup.py build_ext --inplace && mkdir /darknet/data/vehicledata/
COPY carimages /darknet/data/vehicledata/
RUN wget https://pjreddie.com/media/files/darknet53.conv.74
COPY darknet53.conv.74 /darknet/data/vehicledata/
## Run test ##
RUN sh download_models.sh
ADD ./docker_demo.py /YOLO3-4-Py/docker_demo.py
CMD ["python3", "docker_demo.py"]
