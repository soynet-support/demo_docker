FROM nvcr.io/nvidia/tensorrt:20.03-py3

#ARG CUDA_VERSION=10.2
#ARG OS_VERSION=18.04
#FROM nvidia/cuda:${CUDA_VERSION}-cudnn8-devel-ubuntu${OS_VERSION}
# CUDA 10.2 / cuDNN 7.6.5 / TensorRT 6.0.1 - Tesla 아키텍처 이상, nvidia-driver 440.30 이상
#FROM nvcr.io/nvidia/tensorrt:19.11-py3  
# CUDA 10.1 / cuDNN 7.6.4 / TensorRT 6.0.1 - nvidia-driver 418.xx 이상

WORKDIR /
RUN ["/bin/bash"]

# package install 과정에서의 interactive 모들 비활성화 
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y -q

# 공통 package 설치 (opencv build 및 demo 구동 목적)
RUN apt-get update && apt install -y software-properties-common 
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt install -y --no-install-recommends wget git cmake pkg-config unzip \
        build-essential libssl-dev protobuf-compiler libprotoc-dev \
			  libopenblas-dev gfortran libjpeg8-dev libxslt1-dev libfreetype6-dev sudo 

# opencv 3.4.5 download & build 
RUN wget https://soynet.io/demo/opencv_345_install.sh
RUN bash ./opencv_345_install.sh

# 테스트 용 python 환경 구성
# RUN apt install -y --no-install-recommends \
# 			python3 \
#       python3-pip \
#       python3-dev \
#       python3-wheel 
# RUN pip3 install --upgrade pip
# RUN pip3 install setuptools>=41.0.0 python3-opencv numpy 
# RUN ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip

# SoyNet download 및 환경 구성 
# RUN echo "LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/cuda/targets/x86_64-linux/lib:${LD_LIBRARY_PATH}" >> ~/.bashrc

# WORKDIR /
# RUN git clone https://github.com/soynet-support/demo_yolo

# # SoyNet Yolov3, Yolov3-tiny, yolov4 용 weight 파일 다운로드 
# WORKDIR /demo_yolo/mgmt/weights
# RUN bash ./download_weights.sh