# Docker Enviroment for PointPainting

## 1. Install CUDA Driver

Drivers: <https://www.nvidia.com/download/index.aspx>

## 2. Install CUDA {on WSL2 if Windows}

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
&& curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg 
&& curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list |
sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |  tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
apt-get update
apt-get install -y nvidia-docker2

## 3. Build Dockerimage

### Build Image

docker build -t point_painting .

### Run Container from Image

sudo docker run --gpus all --name point_painting -it point_painting

### Restart Container

docker start -i point_painting
