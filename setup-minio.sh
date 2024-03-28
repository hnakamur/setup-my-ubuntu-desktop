#!/bin/bash
set -eu
download_exec_file() {
  dest_path="$1"
  url="$2"

  if [ ! -f "$dest_path" ]; then
    curl -sSLo "$dest_path" --create-dirs "$url"
    chmod +x "$dest_path"
  fi
}

download_exec_file ~/.local/bin/minio https://dl.min.io/server/minio/release/linux-amd64/minio
download_exec_file ~/.local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
