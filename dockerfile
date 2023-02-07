FROM nvidia/cuda:10.1-cudnn8-devel-ubuntu18.04
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

# Update Python to 3.7
# Remove existing Python 3.6 installation
RUN apt-get remove -y python3.6 python3.6-dev

# Download and extract Python 3.7 source code
RUN wget https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tar.xz
RUN tar xJf Python-3.7.10.tar.xz

# Build and install Python 3.7
# --enable-optimizations removed build takes too long
RUN cd Python-3.7.10 && \
    ./configure  && \
    make && \
    make install

# Make python3.7 the default python
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 1

# Install python3.7-dev version
RUN apt-get install -y python3.7-dev

# Remove downloaded source code and unnecessary dependencies
RUN rm -rf Python-3.7.10

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
RUN pip3 install --upgrade pip

# Install pip packages
RUN pip install \
torch==1.7.0 \
torchvision==0.8.0 \
torchaudio==0.7.0 \
scipy \
scikit-image \
open3d \
matplotlib \
opencv-python-headless \
tqdm \
terminaltables \
numba==0.53.0 \
mmcv-full==1.4.0 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.7.0/index.html \
mayavi \
pyqt5

# Setting Home ENV for CUDA
ENV CUDA_HOME "/usr/local/cuda-10.1"

# Installing spconv
RUN git clone -b v1.2.1 --recursive https://github.com/traveller59/spconv.git
RUN pip install -e ./spconv

# Cleaning up
RUN rm -rf \
Python-3.7.10.tar.xz \
cmake-3.13.4.tar.gz \
cmake-3.13.4 

# Setting the default shell
ENV SHELL /bin/bash