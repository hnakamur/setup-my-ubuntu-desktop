#!/bin/bash
set -eu

vm_name=centos7-cloud-vm

lxdbr0_ipv4_addr_with_mask=$(lxc network get lxdbr0 ipv4.address)
lxdbr0_ipv4_addr=$(echo $lxdbr0_ipv4_addr_with_mask | sed 's|/.*||')

config_file=/tmp/$vm_name-cloud-init.yml
cat > $config_file <<EOF
network:
  version: 1
  config:
    - type: physical
      name: eth0
      subnets:
        - type: dhcp
          control: auto
    - type: nameserver
      address: $lxdbr0_ipv4_addr
EOF

lxc init images:centos/7/cloud $vm_name --vm
lxc config set $vm_name cloud-init.network-config - < $config_file
lxc start $vm_name
