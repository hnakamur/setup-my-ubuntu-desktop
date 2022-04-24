#!/bin/sh

# This script is copied from https://gihyo.jp/admin/serial/01/ubuntu-recipe/0710

DLFOLDER=$(mktemp -d)
DLNAME="firefox-latest.tar.bz2"

if [ -d "${HOME}/firefox" ]; then
  echo "${HOME}/firefoxフォルダーが存在しています"
  exit 1
fi

if ! wget -O "${DLFOLDER}/${DLNAME}" "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=ja"; then
  echo "Firefoxの取得に失敗しました"
  rm -r "${DLFOLDER}"
  exit 1
fi

tar xf "${DLFOLDER}/${DLNAME}" --one-top-level=firefox --directory="${HOME}"

cat << EOF > "${DLFOLDER}/firefox.desktop"
[Desktop Entry]
Version=1.0
Name=Firefox Web Browser
Name[ja]=Firefox ウェブ・ブラウザ
Comment=Browse the World Wide Web
Comment[ja]=ウェブを閲覧します
GenericName=Web Browser
GenericName[ja]=ウェブ・ブラウザ
Keywords=Internet;WWW;Browser;Web;Explorer
Keywords[ja]=Internet;WWW;Web;インターネット;ブラウザ;ウェブ;エクスプローラ
Exec=$HOME/firefox/firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=$HOME/firefox/browser/chrome/icons/default/default128.png
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;video/webm;application/x-xpinstall;
StartupNotify=true
StartupWMClass=firefox
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=Open a New Window
Name[ja]=新しいウィンドウを開く
Exec=$HOME/firefox/firefox -new-window

[Desktop Action new-private-window]
Name=Open a New Private Window
Name[ja]=新しいプライベートウィンドウを開く
Exec=$HOME/firefox/firefox -private-window
EOF

xdg-desktop-menu install --novendor "${DLFOLDER}/firefox.desktop"

rm -r "${DLFOLDER}"

echo "Firefoxのインストールが完了しました"

