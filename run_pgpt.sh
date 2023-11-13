#!/bin/bash

if command -v nvidia-smi > /dev/null
then
  if ! command -v nvcc > /dev/null
  then
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt update
    apt install -y cuda-toolkit-12-3
    echo 'export CUDA_HOME=/usr/local/cuda
    PATH=${CUDA_HOME}/bin:${PATH}
    LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    source ~/.bashrc
  fi
  CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python
fi
poetry install --with ui,local
poetry run python scripts/setup
PGPT_PROFILES=local make run