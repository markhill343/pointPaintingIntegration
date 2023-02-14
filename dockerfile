FROM nvidia/cuda:11.7.0-cudnn8-devel-ubuntu20.04
WORKDIR /tmp

#CU# CUDA
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,display
ENV NVIDIA_VISIBLE_DEVICES=all

# Run dpkg without interactive dialog
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libbz2-dev \
    libdb-dev \
    libreadline-dev \
    libffi-dev \
    libgdbm-dev \
    liblzma-dev \
    libncursesw5-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-xinerama0 \ 
    libxkbcommon-x11-0 \
    libgl1 \
    libxcb-xkb1 \ 
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-render-util0 \
    libdbus-1-3 \
    zlib1g-dev \
    tk-dev \
    openssl \
    uuid-dev \
    wget \
    xz-utils \
    zlib1g-dev

# Install CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
RUN tar xzf cmake-3.13.4.tar.gz
RUN cd cmake-3.13.4 && \
    ./bootstrap && \
    make && \
    make install

# Generic python installations
RUN apt-get update && apt-get install -y \
python3-pip \
git 

# Install missing system librarys
RUN apt-get update && apt-get install -y \
libgl1-mesa-glx libboost-all-dev

# Install pip and git
RUN apt-get update && apt-get install -y \
python3-pip \
git

# Upgrade pip
RUN pip install --upgrade pip

# Install pip packages
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu117

RUN pip install \
scipy \
scikit-image \
open3d \
matplotlib \
opencv-python-headless \
tqdm \
terminaltables \
numba==0.53.0 \
spconv-cu117 \
mmcv-full==1.7.0 -f https://download.openmmlab.com/mmcv/dist/cu117/torch1.13.0/index.html \
mayavi \
pyqt5

# Setting Home ENV for CUDA
ENV CUDA_HOME "/usr/local/cuda-11.7"

# Cleaning up
RUN rm -rf \
cmake-3.13.4.tar.gz \
cmake-3.13.4 

# Setting the default shell
ENV SHELL /bin/bash

#Updating
RUN apt-get update