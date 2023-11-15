#!/bin/bash
# See https://apt.llvm.org/

major_version=17

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl lsb-release

apt_key_path=/etc/apt/keyrings/llvm-snapshot.gpg.key
if [ ! -f "$apt_key_path" ]; then
  sudo mkdir -p $(dirname "$apt_key_path")
  curl -sS -o "$apt_key_path" https://apt.llvm.org/llvm-snapshot.gpg.key
fi

apt_list_path=/etc/apt/sources.list.d/llvm-${major_version}.list
if [ ! -f "$apt_list_path" ]; then
  arch=$(dpkg --print-architecture)
  codename=$(lsb_release -sc)
  cat <<EOF | sudo tee "$apt_list_path" > /dev/null
deb [arch=$arch signed-by=$apt_key_path] http://apt.llvm.org/${codename}/ llvm-toolchain-${codename}-${major_version} main
deb-src [arch=$arch signed-by=$apt_key_path] http://apt.llvm.org/${codename}/ llvm-toolchain-${codename}-${major_version} main
EOF
  sudo apt-get update
fi

install_deb_packages curl lsb-release

# LLVM
install_deb_packages libllvm-${major_version}-ocaml-dev libllvm${major_version} llvm-${major_version} llvm-${major_version}-dev llvm-${major_version}-doc llvm-${major_version}-examples llvm-${major_version}-runtime
# Clang and co
install_deb_packages clang-${major_version} clang-tools-${major_version} clang-${major_version}-doc libclang-common-${major_version}-dev libclang-${major_version}-dev libclang1-${major_version} clang-format-${major_version} python3-clang-${major_version} clangd-${major_version} clang-tidy-${major_version}
# compiler-rt
install_deb_packages libclang-rt-${major_version}-dev
# polly
install_deb_packages libpolly-${major_version}-dev
# libfuzzer
install_deb_packages libfuzzer-${major_version}-dev
# lldb
install_deb_packages lldb-${major_version}
# lld (linker)
install_deb_packages lld-${major_version}
# libc++
install_deb_packages libc++-${major_version}-dev libc++abi-${major_version}-dev
# OpenMP
install_deb_packages libomp-${major_version}-dev
# libclc
install_deb_packages libclc-${major_version}-dev
# libunwind
install_deb_packages libunwind-${major_version}-dev
# mlir
install_deb_packages libmlir-${major_version}-dev mlir-${major_version}-tools
# bolt
install_deb_packages libbolt-${major_version}-dev bolt-${major_version}
# flang
install_deb_packages flang-${major_version}
# wasm support
install_deb_packages libclang-rt-${major_version}-dev-wasm32 libclang-rt-${major_version}-dev-wasm64 libc++-${major_version}-dev-wasm32 libc++abi-${major_version}-dev-wasm32 libclang-rt-${major_version}-dev-wasm32 libclang-rt-${major_version}-dev-wasm64 
