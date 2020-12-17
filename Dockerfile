FROM nvcr.io/nvidia/l4t-base:r32.4.3

WORKDIR /root
RUN ["/bin/bash"]

# package install 과정에서의 interactive 모들 비활성화 
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install -y -q

# cuda env 
RUN echo '/usr/local/cuda/lib64' >> /etc/ld.so.conf.d/nvidia-tegra.conf && ldconfig 

# 3rd party library for opencv build
RUN apt install -y --no-install-recommends \
        build-essential cmake git unzip pkg-config \
        libjpeg-dev libpng-dev libtiff-dev \
        libavcodec-dev libavformat-dev libswscale-dev \
        libgtk2.0-dev libcanberra-gtk* \
        python3-dev python3-numpy python3-pip \
        libxvidcore-dev libx264-dev libgtk-3-dev \
        libtbb2 libtbb-dev libdc1394-22-dev \
        libv4l-dev v4l-utils \
        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libavresample-dev libvorbis-dev libxine2-dev \
        libfaac-dev libmp3lame-dev libtheora-dev \
        libopencore-amrnb-dev libopencore-amrwb-dev \
        libopenblas-dev libatlas-base-dev libblas-dev \
        liblapack-dev libeigen3-dev gfortran \
        libhdf5-dev protobuf-compiler \
        libprotobuf-dev libgoogle-glog-dev libgflags-dev sudo 

RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.5.zip && \
    unzip opencv.zip && \
    mv opencv-3.4.5 opencv
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.5.zip && \
    unzip opencv_contrib.zip && \
    mv opencv_contrib-3.4.5 opencv_contrib 
RUN rm opencv.zip opencv_contrib.zip 

WORKDIR /opencv 
RUN mkdir build && cd build 

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN=5.3 \
        -D CUDA_ARCH_PTX="" \
        -D WITH_CUDNN=ON \
        -D WITH_CUBLAS=ON \
        -D ENABLE_FAST_MATH=ON \
        -D CUDA_FAST_MATH=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D ENABLE_NEON=ON \
        -D WITH_QT=OFF \
        -D WITH_OPENMP=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_TIFF=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        -D WITH_TBB=ON \
        -D BUILD_TBB=ON \
        -D BUILD_TESTS=OFF \
        -D WITH_EIGEN=ON \
        -D WITH_V4L=ON \
        -D WITH_LIBV4L=ON \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=TRUE \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D BUILD_EXAMPLES=OFF ..
RUN make -j4 
RUN make install && ldconfig 

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

#WORKDIR /
#RUN git clone https://github.com/soynet-support/demo_yolo

# SoyNet Yolov3, Yolov3-tiny, yolov4 용 weight 파일 다운로드 
#WORKDIR /demo_yolo/mgmt/weights
#RUN bash ./download_weights.sh 