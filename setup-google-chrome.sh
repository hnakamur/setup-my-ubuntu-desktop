#!/bin/bash
set -eu
sudo apt install -y curl

deb_url=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
deb_path=/tmp/$(basename $deb_url)
curl -L -o ${deb_path} ${deb_url}
sudo apt install -y $deb_path
