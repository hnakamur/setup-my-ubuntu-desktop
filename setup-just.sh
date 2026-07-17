#!/bin/bash
set -eu
repo_url=https://github.com/casey/just
version="$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest")"
version="${version##*/}"

installed_version="$(just --version 2>/dev/null || :)"
installed_version="${installed_version##* }"
if [ "$installed_version" != "$version" ]; then
  # install just executable
  arch="$(uname -m)"
  tarball_url="${repo_url}/releases/download/${version}/just-${version}-${arch}-unknown-linux-musl.tar.gz"
  bin_dir="${HOME}/.local/bin"
  mkdir -p "${bin_dir}"
  curl -sSL "${tarball_url}" | tar zx -C "${bin_dir}" just

  # install bash completions file
  completions_dir="${HOME}/.local/share/bash-completion/completions"
  mkdir -p "${completions_dir}"
  "${bin_dir}/just" --completions bash > "${completions_dir}/just"
fi
