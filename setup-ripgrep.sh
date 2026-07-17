#!/bin/bash
set -eu -o pipefail

repo_url=https://github.com/BurntSushi/ripgrep
version="$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest")"
version="${version##*/}"

bin_dir="${HOME}/.local/bin"
installed_version="$( ("${bin_dir}/rg" --version 2>/dev/null || :) | head -1)"
installed_version="${installed_version#* }"
installed_version="${installed_version%% *}"
if [ "$installed_version" != "$version" ]; then
  # install executable
  arch="$(uname -m)"
  tarball_url="${repo_url}/releases/download/${version}/ripgrep-${version}-${arch}-unknown-linux-musl.tar.gz"
  mkdir -p "${bin_dir}"
  curl -sSL "${tarball_url}" | tar zx -C "${bin_dir}" --strip-components 1 ripgrep-${version}-${arch}-unknown-linux-musl/rg

  # install bash completions file
  completions_dir="${HOME}/.local/share/bash-completion/completions"
  mkdir -p "${completions_dir}"
  "${bin_dir}/rg" --generate=complete-bash > "${completions_dir}/rg"
fi
