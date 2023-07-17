#!/bin/sh
sudo apt-get -y install fonts-noto-cjk fonts-noto-cjk-extra

fonts_conf_path="$HOME/.config/fontconfig/fonts.conf"
mkdir -p $(dirname "$fonts_conf_path")
cat <<'EOF' > "$fonts_conf_path"
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match>
    <test name="lang" compare="contains">
      <string>en</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Sans CJK JP Regular</string>
    </edit>
  </match>
  <match>
    <test name="lang" compare="contains">
      <string>ja</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>Noto Sans CJK JP Regular</string>
    </edit>
  </match>
</fontconfig>
EOF
