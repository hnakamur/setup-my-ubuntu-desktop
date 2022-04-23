#!/bin/bash
set -eu
sudo sed -i -e 's/^# deb-src/deb-src/' /etc/apt/sources.list
