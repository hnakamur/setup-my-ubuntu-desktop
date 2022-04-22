#!/bin/bash
sudo sed -i -e '/^XKBOPTIONS=/s/""/"ctrl:swapcaps"/' /etc/default/keyboard
