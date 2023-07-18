#!/bin/sh
if ! grep '^sleep-inactive-ac-timeout=0$' /etc/gdm3/greeter.dconf-defaults; then
  sudo sed -i 's/^# sleep-inactive-ac-timeout=1200/sleep-inactive-ac-timeout=0/' /etc/gdm3/greeter.dconf-defaults
  sudo systemctl reload gdm
fi
