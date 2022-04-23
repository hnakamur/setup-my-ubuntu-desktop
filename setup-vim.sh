#!/bin/bash

sudo apt install -y vim

if ! grep EDITOR ~/.profile; then
  cat >> ~/.profile <<'EOF'

EDITOR=/usr/bin/vim
EOF
fi
