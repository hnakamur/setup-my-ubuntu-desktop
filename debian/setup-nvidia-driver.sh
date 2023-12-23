#!/bin/bash

if ! grep -q ' non-free ' /etc/apt/sources.list; then
  sudo sed -i 's/non-free-firmware/& contrib non-free/' /etc/apt/sources.list
fi
sudo apt update
sudo apt install nvidia-driver firmware-misc-non-free
