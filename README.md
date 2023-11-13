# PrivateGPT Docker Image

## Introduction

This repository maintains a Docker image designed to simplify the process of setting up and running PrivateGPT in a containerized environment. It handles all environment and build steps necessary for running PrivateGPT inside a container.

## Features

Easy setup: Get PrivateGPT running with default configuration.

- Use environment variables to override the used models
  | env | description | default |
  | --- | --- | --- |
  | LLM_REPO_ID | The Huggingface repo id | TheBloke/dolphin-2.2.1-mistral-7B-GGUF |
  | LLM_MODEL_FILE | The model file name inside the repo | dolphin-2.2.1-mistral-7b.Q5_K_S.gguf |
  | EMBEDDING_MODEL | Haven't played around with changing this model, but you can try by setting this |
  | PORT | The container's listening port | 8001 |BAAI/bge-small-en-v1.5 |
  | WSL | Set to 1 if under WSL | -- |
- Or mount a `settings.yaml` to directly customize it

## Running it

Initial run takes a while, as it needs to set up all python dependencies and download the models

### Basic

```bash
  docker run -p 8001:8001 phenome/privategpt
```

### GPU Acceleration

If the continer has access to `nvidia-smi`, it'll install CUDA and use the GPU for inference.
On newer docker installs, it should be as simple as

```bash
  docker run -p 8001:8001 --gpus all phenome/privategpt
```

### Advanced

You can use some bind mounts so you can persist it when recreating the container:
It's also recommended to bind some outside of the image so it doesn't bloat your docker volume
| mount | description |
| --- | --- |
| /workspace/privateGPT/local_data | Where the embeddings database is stored |
| /workspace/privateGPT/models | Keeps the downloaded models |
| /workspace/privateGPT/settings.yaml | Custom settings file |
| /root/.cache/pypoetry | Poetry's cache. Can get huge (10GB+) |

```bash
  docker run -p 8001:8001 --gpus all -v $PWD/local_data:/workspace/privateGPT/local_data -v $PWD/models:/workspace/privateGPT/models -v $PWD/settings.yaml:/workspace/privateGPT/settings.yaml phenome/privategpt
```
