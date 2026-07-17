#!/bin/bash
set -eu
repo_url=https://github.com/neovim/neovim
version="$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest")"
version="${version##*/}"

install_dir="${HOME}/.local/opt/nvim"
bin_dir="${install_dir}/bin"
installed_version="$( ("${bin_dir}/nvim" --version 2>/dev/null || :) | head -1)"
installed_version="${installed_version##* }"
if [ "$installed_version" != "$version" ]; then
  # download and extract taraball
  case "$(uname -m)" in
  x86_64) arch=x86_64 ;;
  aarch64) arch=arm64 ;;
  *) >&2 echo 'Error: Unsupported CPU architecture'; exit 2 ;;
  esac

  tarball_url="${repo_url}/releases/download/${version}/nvim-linux-${arch}.tar.gz"
  mkdir -p "${install_dir}"
  curl -sSL "${tarball_url}" | tar zx -C "${install_dir}" --strip-components 1
fi
