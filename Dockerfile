FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
MAINTAINER Air523 <jdzgfan@mail.ustc.edu.cn>

# install basic dependencies
RUN apt-get update && apt-get install -y \
    wget \
    vim \
    cmake

# install Anaconda3
RUN wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda3.sh \
    && bash ~/anaconda3.sh -b -p /home/anaconda3 \
    && rm ~/anaconda3.sh
ENV PATH /home/anaconda3/bin:$PATH
# note: forcibly use /bin/bash, may cause some problem
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install dependencies for linkevision-cpu
RUN apt-get install -y build-essential libgtk-3-dev libboost-all-dev

RUN conda create -n linkevision python=3.5 \
    && source activate linkevision \
    && pip --default-timeout=100 install -U tensorflow keras opencv-python \
    && pip install imageai --upgrade \
    && conda install pytorch torchvision cpuonly -c pytorch \
    && pip install cvlib \
    && pip install dlib \
    && conda install jupyter \
    && pip install numpy==1.16

COPY . /app

WORKDIR /app

EXPOSE 8888