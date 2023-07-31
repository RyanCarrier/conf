#!/bin/bash
sudo echo ""

echo "installing vscode, chrome, kdenlive, flameshot, qb"

if [ -f "/etc/arch-release" ]; then
    yay -Sy --noconfirm visual-studio-code-bin google-chrome kdenlive flameshot qbittorrent
else
    curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome*.deb
    sudo apt-get install -fy
    rm google-chrome*.deb

    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
    sudo apt install -y kdenlive flameshot qbittorrent
fi
