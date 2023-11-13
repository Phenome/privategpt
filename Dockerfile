FROM ubuntu:22.04

VOLUME /workspace /root/.cache/pypoetry/virtualenvs
EXPOSE 8001
# Install dependencies
ARG DEBIAN_FRONTEND=noninteractive
# Etc/UTC
ENV TZ=America/Sao_Paulo
RUN apt update
RUN apt install -y \
    build-essential \
    git \
    vim \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev
RUN curl https://pyenv.run | bash
ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN echo $PATH
RUN eval "$(pyenv init -)"
RUN pyenv install 3.11
RUN pyenv local 3.11
RUN pip install poetry
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt update
RUN apt install -y cuda-toolkit-12-3
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH
WORKDIR /workspace
RUN git clone https://github.com/imartinez/privateGPT
WORKDIR /workspace/privateGPT
RUN poetry install --with ui,local
RUN apt clean -y
COPY run_pgpt.sh /workspace/privateGPT/run_pgpt.sh
COPY settings.yaml /workspace/privateGPT/settings.yaml
CMD ./run_pgpt.sh