#!/bin/bash
set -eu

font_dir=$HOME/.local/share/fonts
tmp_dir=/tmp
font_size=14
font_config_value="PlemolJP $font_size"
gnome_profile_name=default

install_deb_packages() {
  for pkg in "$@"; do
    if [ "$(dpkg-query -f '${Status}' -W $pkg 2>/dev/null)" != 'install ok installed' ]; then
      echo $pkg
    fi
  done | xargs -r sudo apt-get install -y
}

install_deb_packages curl unzip

if [ ! -f "$font_dir/PlemolJP-Regular.ttf" ]; then
  repo_url=https://github.com/yuru7/PlemolJP
  version=$(curl -sS -w '%{redirect_url}' -o /dev/null "$repo_url/releases/latest" | sed 's|.*/tag/||')
  download_url="$repo_url/releases/download/${version}/PlemolJP_${version}.zip"
  local_zip_path="$tmp_dir/PlemolJP_${version}.zip"
  curl -Lo "$local_zip_path" "$download_url"
  unzip "$local_zip_path" "PlemolJP_${version}/PlemolJP/*.ttf" -d "$tmp_dir"

  install -d "$font_dir"
  install $tmp_dir/PlemolJP_${version}/PlemolJP/*.ttf "$font_dir"
  fc-cache -f "$font_dir"
  rm -rf "$local_zip_path" "$tmp_dir/PlemolJP_${version}"
fi

profile_id=$(gsettings get org.gnome.Terminal.ProfilesList "$gnome_profile_name" | tr -d "'")
current_font_config_value=$(gsettings get "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/$profile_id/" font)
if [ "$current_font_config_value" != "$font_config_value" ]; then
  gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/$profile_id/" font "$font_config_value"
fi
