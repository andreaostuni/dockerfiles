##############################################
# Created from template salt.dockerfile.jinja
##############################################

###########################################
# Base image 
###########################################
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Install ROS2
RUN apt-get update && apt-get install -y \
    nano \
    wget \
    git \
    python3 \
    python3-pip \
    libgl1 \ 
    libglib2.0-0 \
  && rm -rf /var/lib/apt/lists/*

RUN cd $HOME && git clone https://github.com/facebookresearch/segment-anything.git && cd segment-anything && pip install -e .
RUN cd $HOME && git clone https://github.com/anuragxel/salt.git && cp -r salt/helpers/* -t segment-anything/
RUN rm -r $HOME/salt
RUN cd $HOME/segment-anything && wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth
RUN pip3 install opencv-python pycocotools matplotlib onnxruntime onnx tqdm
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
