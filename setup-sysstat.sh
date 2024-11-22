#!/bin/sh
install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

if ! systemctl is-active sysstat 2>/dev/null >/dev/null; then
  install_deb_packages sysstat

  sudo sed -i 's/^HISTORY=7/HISTORY=31/;s/^SADC_OPTIONS="-S DISK"/SADC_OPTIONS="-D -S XALL"/' /etc/sysstat/sysstat
  sudo sed -i 's/^ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
  sudo systemctl restart sysstat
  sudo systemctl enable sysstat

  sudo mkdir -p /etc/systemd/system/sysstat-collect.timer.d
  <<'EOF' sudo sh -c 'cat > /etc/systemd/system/sysstat-collect.timer.d/override.conf'
[Unit]
Description=Run system activity accounting tool every minute
[Timer]
OnCalendar=
OnCalendar=*:00/1
AccuracySec=0
EOF
  sudo systemctl daemon-reload
  sudo systemctl start sysstat-collect.timer
fi
