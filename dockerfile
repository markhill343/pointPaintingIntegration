FROM nvidia/cuda:10.1-cudnn8-devel-ubuntu18.04
WORKDIR /tmp

#CUDA
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

#Generic python installations
RUN apt-get update && apt-get install -y \
python3-pip \
git 

#Upgrading to python3.7
#to do: remove installation over ppa 
RUN apt-get install -y software-properties-common -y 
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y \
build-essential \
libpq-dev \
libssl-dev \
openssl \
libffi-dev \
zlib1g-dev \
python3.7-dev \
python3.7 
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

#Install missing system library
RUN apt-get update && apt-get install -y \
libgl1-mesa-glx libboost-all-dev

#Upgrade pip
RUN pip3 install --upgrade pip

#Install pip packages
RUN pip3 install \
torch==1.7.0 \
torchvision==0.8.0 \
torchaudio==0.7.0 \
scipy \
scikit-image \
open3d \
matplotlib \
opencv-python-headless \
tqdm \
wget \
vim \
terminaltables \
mmcv-full==1.4.0 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.7.0/index.html

#Setting Home ENV for CUDA
ENV CUDA_HOME "/usr/local/cuda-10.1"

#Installing CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
RUN tar xzf cmake-3.13.4.tar.gz
RUN cd cmake-3.13.4 && \
    ./bootstrap && \
    make && \
    make install

#Installing spconv
RUN git clone -b v1.2.1 --recursive https://github.com/traveller59/spconv.git
RUN pip install -e .

#Cloning pointPainting
RUN git clone https://github.com/Song-Jingyu/PointPainting.git

#Setting the default shell
ENV SHELL /bin/bash