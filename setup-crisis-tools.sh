#!/bin/bash

# https://www.brendangregg.com/blog/2024-03-24/linux-crisis-tools.html

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages procps util-linux sysstat iproute2 numactl tcpdump linux-tools-common linux-tools-$(uname -r) \
  bpfcc-tools bpftrace trace-cmd nicstat ethtool tiptop cpuid msr-tools perf-tools-unstable
