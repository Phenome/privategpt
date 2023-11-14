FROM nvidia/cuda:11.2.2-devel-ubuntu20.04

VOLUME /workspace /root/.cache/pypoetry
EXPOSE 8001
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
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
WORKDIR /workspace
RUN git clone https://github.com/imartinez/privateGPT
WORKDIR /workspace/privateGPT
RUN apt clean -y
COPY settings.yaml /workspace/privateGPT/settings.yaml
COPY --chmod=0755 run_pgpt.sh /workspace/privateGPT/run_pgpt.sh
CMD ./run_pgpt.sh