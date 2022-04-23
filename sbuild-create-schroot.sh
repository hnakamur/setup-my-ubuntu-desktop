#!/bin/bash
set -eu

# References
# https://groups.google.com/g/linux.debian.bugs.dist/c/2AstXL3gofg

if [ $# -ne 1 ]; then
  >2 cat <<EOF
Usage: $0 distribution_name
distribution_name example is jammy.
EOF
  exit 2
fi

distribution=$1
dataset=rpool/schroot/sbuild-${distribution}-amd64
sudo zfs create -p "$dataset"
sudo zfs set mountpoint=legacy "$dataset"
mk-sbuild --zfs-dataset=$dataset $distribution
sbuild-update $distribution

