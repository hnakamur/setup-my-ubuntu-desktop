#!/bin/bash
set -eu

# https://discuss.linuxcontainers.org/t/how-to-update-user-network-config-and-re-run-cloud-init-to-apply-the-new-config/6204/2

vm_name=centos7-cloud-vm
lxc config set $vm_name cloud-init.network-config - < centos7-cloud-init-config.yml
lxc exec $vm_name -- cloud-init clean
lxc config set $vm_name volatile.apply_template create
lxc restart $vm_name
