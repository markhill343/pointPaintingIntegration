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
$ sudo docker build -t point_painting_rtx3070ti_cu11.7_final .
```

### 3.2 Run Container from Image

```
pip install rocker
```

```
$ sudo rocker --nvidia --x11 --env NVIDIA_DRIVER_CAPABILITIES=all --volume ~/Documents/thesis/pointPaintingIntegration/PointPainting:/tmp/PointPainting -- point_painting_rtx3070ti_cu11.7_final
```

```
$ sudo rocker --nvidia --x11 --env NVIDIA_DRIVER_CAPABILITIES=all --volume /mnt/d/git/pointPaintingIntegration/PointPainting:/tmp/PointPainting -- point_painting_rtx3070ti_cu11.7_final
```

### 3.3 Restart Container

```
$ sudo docker start -i point_painting_rtx3070ti_cu11.7_final
```

## 4. Using Point Painting

### 4.1 Install OpenPCDet

```
$ cd PointPainting/detector
$ python3 setup.py develop
```

### 4.2.1 Painting with DeepLabV3

```
$ cd painting
$ sh get_deeplabv3plus_model.sh
$ python3 painting.py
```

### 4.2.2 Painting with HMA

```
$ cd painting
$ sh generate_hma_score.sh
```

### 4.3 Lidar Detector Training

```
$ cd detector
$ python3 -m pcdet.datasets.kitti.painted_kitti_dataset create_kitti_infos tools/cfgs/dataset_configs/painted_kitti_dataset.yaml
$ cd tools
$ python3 train.py --cfg_file cfgs/kitti_models/pointpillar_painted.yaml
```

### 4.4 Running Inference

```
$ cd tools
$ python3 demo.py --cfg_file cfgs/kitti_models/pointpillar_painted.yaml --ckpt /tmp/PointPainting/detector/output/kitti_models/pointpillar_painted/default/ckpt/checkpoint_epoch_80.pth --data_path /tmp/PointPainting/detector/data/kitti/training/painted_lidar/ --ext .npy
```