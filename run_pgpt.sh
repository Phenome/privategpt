#!/bin/bash

if command -v nvidia-smi > /dev/null; then CMAKE_ARGS='-DLLAMA_CUBLAS=on' poetry run pip install --force-reinstall --no-cache-dir llama-cpp-python; fi
poetry run python scripts/setup
PGPT_PROFILES=local make run