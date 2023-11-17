#!/bin/bash

if command -v nvidia-smi > /dev/null
then
  if ! command -v nvcc > /dev/null
  then
    if [[ -z "${WSL}" ]]; then
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
    else
      wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb
    fi
    dpkg -i cuda-keyring_1.1-1_all.deb
    apt update
    apt install -y cuda-toolkit-12-3
    echo 'export CUDA_HOME=/usr/local/cuda
    PATH=${CUDA_HOME}/bin:${PATH}
    LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
  fi
fi
poetry config installer.max-workers 10
poetry install --with ui,local
poetry run python scripts/setup
if command -v nvidia-smi > /dev/null
then
  CUDA_HOME=/usr/local/cuda PATH=${CUDA_HOME}/bin:${PATH} CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install --force-reinstall llama-cpp-python
fi
PGPT_PROFILES=local make run