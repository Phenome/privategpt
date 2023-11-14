#!/bin/bash

if command -v nvidia-smi > /dev/null
then
  CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install llama-cpp-python
fi
poetry config installer.max-workers 10
poetry install --with ui,local
poetry run python scripts/setup
PGPT_PROFILES=local make run