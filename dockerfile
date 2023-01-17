FROM nvidia/cuda:10.1-devel-ubuntu18.04
WORKDIR /tmp

#CUDA
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all

#Generic python installations
RUN apt-get update && apt-get install -y \
python3-pip \
git 

#Upgrading to python3.7
RUN apt-get install -y software-properties-common -y 
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install -y \
build-essential libpq-dev libssl-dev openssl libffi-dev zlib1g-dev \
python3-pip python3.7-dev \
python3.7 
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2

# PIP -> if it doesnt work python -m pip install --upgrade pip
RUN pip3 install --upgrade pip

#Install pip packages
RUN pip3 install \
torch==1.7.0 \
torchvision==0.8.0 \
torchaudio==0.7.0 \
matplotlib \
tqdm \
wget \
spconv \
terminaltables \
mmcv-full==1.4.0 -f https://download.openmmlab.com/mmcv/dist/cu101/torch1.7.0/index.html


ENV CUDA_HOME "/usr/local/cuda-10.1"

#download pointPainting
RUN git clone https://github.com/Song-Jingyu/PointPainting.git

ENV SHELL /bin/bash