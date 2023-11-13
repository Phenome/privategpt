FROM ubuntu:22.04

VOLUME /workspace /root/.cache/pypoetry
EXPOSE 8001
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y git wget vim python3.11 python3-pip
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 &&\
  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2 &&\
  update-alternatives --config python3
RUN pip install poetry
WORKDIR /workspace
RUN git clone https://github.com/imartinez/privateGPT
WORKDIR /workspace/privateGPT
RUN apt clean -y
COPY run_pgpt.sh /workspace/privateGPT/run_pgpt.sh
COPY settings.yaml /workspace/privateGPT/settings.yaml
CMD ./run_pgpt.sh