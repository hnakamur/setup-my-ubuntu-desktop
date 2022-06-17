#!/bin/bash
# See https://discuss.linuxcontainers.org/t/lxd-and-docker-firewall-redux-how-to-deal-with-forward-policy-set-to-drop/9953/7
sudo iptables -I FORWARD -o lxdbr0 -m comment --comment "generated for LXD network lxdbr0" -j ACCEPT
sudo iptables -I FORWARD 2 -i lxdbr0 -m comment --comment "generated for LXD network lxdbr0" -j ACCEPT
