#!/bin/bash
set -eu
sudo apt install -y curl

repo_url=https://github.com/gohugoio/hugo
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||' | sed 's|^v||')
mkdir -p ~/.local/bin
curl -L ${repo_url}/releases/download/v${version}/hugo_${version}_Linux-64bit.tar.gz | tar -C ~/.local/bin/ -zxf - hugo
