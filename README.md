# SoyNet 테스트를 위한 Docker Container 생성 방법 설명

SoyNet을 이용한 AI 모델 데모를 실행하기 위해 필요한 환경 구성을 위해
x86 (Ubuntu 18.04)인 경우와 Jetson Nano (JetPack 4.4) 용 Dockerfile을 이용한 
docker container image 생성을 하는 과정을 설명한다.
단, 본 docker container에는 SoyNet demo는 포함되어 있지 않으므로 다음의 링크를 참조하도록 한다. 
- SoyNet demo repo : https://github.com/soynet-support/demo_yolo
- SoyNet demo on Jetson Nano repo : https://github.com/soynet-support/demo_yolo_jetsonNano



### 1.Dockerfile download 및 실행 
```
$ git clone https://github.com/soynet-support/demo_docker
$ cd demo_docker

# x86 ubuntu 18.04 인 경우,
$ docker build -t trt20.03-py -f Dockerfile.x86 . 

# Jetson Nano Jetpack 4.4 인 경우, 
$ docker build -t r32.4.3 -f Dockerfile.jetsonNano . 
```

docker image 생성 여부 확인

```
$ docker images
```


### 2.docker to host display 설정

```
$ xhost +local:docker
```

*이 부분은 docker 내에서 inference 수행 결과를 시각적으로 확인하기 위함


### 3.docker container 실행
다운받은 docker image를 이용하여 진행한다.

x86 ubuntu 18.04 경우,
```
$ docker run -ti -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e USER=$USER \
  --gpus all \
  --name demo \
  trt20.03-py:demo bash
```

Jetson Nano (Jetpack 4.4) 경우,
```
$ docker run -ti -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e USER=$USER \
  --gpus all \
  --name demo \
  r32.4.3:demo bash
```
