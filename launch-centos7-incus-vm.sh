#!/bin/bash
set -eu

vm_name=centos7-cloud-vm

incusbr0_ipv4_addr_with_mask=$(incus network get incusbr0 ipv4.address)
incusbr0_ipv4_addr=$(echo $incusbr0_ipv4_addr_with_mask | sed 's|/.*||')

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
      address: $incusbr0_ipv4_addr
EOF

incus init images:centos/7/cloud $vm_name --vm
incus config set $vm_name cloud-init.network-config - < $config_file
incus start $vm_name
