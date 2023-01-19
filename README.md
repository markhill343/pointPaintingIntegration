# Docker Enviroment for PointPainting

## 1. Install CUDA Driver

Drivers: <https://www.nvidia.com/download/index.aspx>

## 2. Install CUDA {on WSL2 if Windows}

```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
&& curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg 
&& curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |  tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-docker2
```

## 3. Build Dockerimage

### 3.1 Build Image

```
docker build -t point_painting .
```

### 3.2 Run Container from Image

```
sudo docker run --gpus all --name point_painting -it -v /mnt/d/kitti/kitti:/tmp/PointPainting/detector/data/kitti point_painting
```

### 3.3 Restart Container

```
docker start -i point_painting
```

## 4. Using Point Painting

### 4.1 Install OpenPCDet

```
$ cd PointPainting/detector
$ python3 setup.py develop
```

### 4.2 Mount Kitti Data-Set (if not already mounted @run command)

docker run -v /mnt/d/kitti/kitti:/tmp/PointPainting/detector/data/kitti1 point_painting


### 4.3.1 Painting with DeepLabV3



```
$ cd painting
$ apt-get wget
$ sh get_deeplabv3plus_model.sh
$ pip3 install opencv-python-headless
$ python3 painting.py
```

### 4.3.2 Painting with HMA

```
$ cd painting
$ sh generate_hma_score.sh
```

### 4.4 Lidar Detector Training

```
$ cd detector

vim /tmp/PointPainting/detector/pcdet/datasets/kitti/painted_kitti_dataset.py
Line 442 = dataset_cfg = EasyDict(yaml.load(open(sys.argv[2]), Loader=yaml.SafeLoader))

## Install Cmake
wget https://github.com/Kitware/CMake/releases/download/v3.13.4/cmake-3.13.4.tar.gz
tar xzf cmake-3.13.4.tar.gz
cd cmake-3.13.4
./bootstrap
make
sudo make install

## Install spconv
git clone -b v1.2.1 --recursive https://github.com/traveller59/spconv.git
sudo apt-get install libboost-all-dev




$ python3 -m pcdet.datasets.kitti.painted_kitti_dataset create_kitti_infos tools/cfgs/dataset_configs/painted_kitti_dataset.yaml
$ cd tools
$ python train.py --cfg_file cfgs/kitti_models/pointpillar_painted.yaml
```

### 4.5 Running Inference

```
$ pip install mayavi
$ cd tools
$ python demo.py --cfg_file cfgs/kitti_models/pointpillar_painted.yaml --ckpt ${your trained ckpt} --data_path ${painted .npy file} --ext .npy
```
