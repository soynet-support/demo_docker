# SoyNet 테스트를 위한 개발 환경을 위한 Docker Container 생성 방법 설명



### 1.Dockerfile download 및 실행 
```
$ git clone https://github.com/soynet-support/demo_docker
$ cd demo_docker

# x86 ubuntu 18.04 인 경우,
$ docker build -t demo -f Dockerfile . 

# Jetson Nano Jetpack 4.4 인 경우, 
$ docker build -t demo -f Dockerfile.jetsonNano . 
```

docker image 생성 여부 확인

```
$ docker images
```


### 2.docker to host display 설정


```
$ xhost +local:docker
```

*이 부분은 docker 내에서 inference 수행 결과를 시각적으로 확인하고자 함임


### 3.docker container 실행


```
$ docker run -ti -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e USER=$USER \
  --gpus all \
  --name demo \
  trt20.03-py:demo bash
```

주의) 
1.--gpus 옵션 적용해야 nvidia-smi 등 gpu 관련 기능 및 PATH 환경정보 사용 가능
