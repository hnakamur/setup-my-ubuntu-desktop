#!/bin/bash
set -eu -o pipefail
repo_url=https://github.com/jdx/mise
version="$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest")"
version="${version##*/}"
version="${version#v}"

bin_dir="${HOME}/.local/bin"
installed_version="$( ("${bin_dir}/mise" version --json 2>/dev/null || :) | jq -r .version)"
installed_version="${installed_version%%* }"
echo installed_version=$installed_version version=$version
if [ "$installed_version" != "$version" ]; then
  # install just executable
  case "$(uname -m)" in
  x86_64) arch=x64 ;;
  aarch64) arch=arm64 ;;
  *) >&2 echo 'Error: Unsupported CPU architecture'; exit 2 ;;
  esac
  executable_url="${repo_url}/releases/download/v${version}/mise-v${version}-linux-${arch}-musl"
  curl -sSLo "${bin_dir}/mise" --create-dirs "${executable_url}"
  chmod +x "${bin_dir}/mise"

  # add config to $HOME/.bashrc
  config_line="eval \"\$(${bin_dir}/mise activate bash)\""
  if ! grep -q -F "${config_line}" "${HOME}/.bashrc"; then
    echo "${config_line}" >> "${HOME}/.bashrc"
    echo Please logout and re-login to enable mise.
    echo Then you can install LTS version of node with "mise use --global node@lts"
  fi
fi
