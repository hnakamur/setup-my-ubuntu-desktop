#!/bin/bash
set -eu
sudo apt install -y curl unzip

repo_url=https://github.com/x-motemen/ghq
version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')

mkdir -p ~/.local/bin
zip_path=/tmp/ghq_linux_amd64.zip
curl -L -o ${zip_path}  ${repo_url}/releases/download/${version}/ghq_linux_amd64.zip
unzip -j ${zip_path} ghq_linux_amd64/ghq -d ~/.local/bin/
