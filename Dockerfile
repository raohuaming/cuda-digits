# Start with CUDA DIGITS dependencies
FROM kaixhin/cuda-digits-deps:8.0
MAINTAINER Huaming Rao <huaming.rao@gmail.com>

# Move into NVIDIA Caffe repo
RUN cd /root/caffe && \
# Make and move into build directory
  mkdir build && cd build && \
# CMake
  cmake .. -DCUDA_ARCH_NAME=Manual -DCUDA_ARCH_BIN="61" -DCUDA_ARCH_PTX="61" -DUSE_CUDNN=1  && \
# Make
  make -j"$(nproc)"
# Set CAFFE_HOME
ENV CAFFE_HOME /root/caffe

# Clone DIGITS repo and move into it
#RUN cd /root && git clone --depth 1 https://github.com/NVIDIA/DIGITS.git digits && cd digits && \
# pip install
#  pip install -r requirements.txt

COPY ./digits /root/digits
RUN cd /root/digits/ && pip install -r requirements.txt

# Expose server port
EXPOSE 5000
# Set working directory
WORKDIR /root/digits
# Start server
CMD ["./digits-devserver"]
