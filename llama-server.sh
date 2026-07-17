#!/bin/sh
exec llama-server --models-dir "$HOME"/.cache/huggingface/hub --models-max 1 --models-autoload --host 0.0.0.0 --port 18000
