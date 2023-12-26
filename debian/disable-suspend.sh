#!/bin/sh
# https://wiki.debian.org/Suspend#Disable_suspend_and_hibernation
conf_file=/etc/systemd/sleep.conf.d/nosuspend.conf
if [ ! -f "$conf_file" ]; then
  sudo mkdir -p $(dirname "$conf_file")
  cat <<'EOF' | sudo tee "$conf_file" > /dev/null
[Sleep]
AllowSuspend=no
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
EOF
  sudo systemctl daemon-reload
fi
