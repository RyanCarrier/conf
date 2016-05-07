#!/bin/bash
GOLANGVERSION = "1.6.2"
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

add-apt-repository ppa:qbittorrent-team/qbittorrent-stable

apt-get update

apt-get install -y curl ubuntu-restricted-extras tar tmux thefuck vim rsync openssh-server traceroute qbittorrent vlc htop zip unzip

#Chrome
curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb
apt-get install -fy
rm google-chrome*.deb

#Go
curl -O https://storage.googleapis.com/golang/go$GOLANGVERSION.linux-amd64.tar.gz
tar -C /usr/local -xzf go*.tar.gz
rm go*.tar.gz

#Atom
curl -OL https://atom.io/download/deb
dpkg -i atom*.deb
apt-get install -fy
rm atom*.deb
apm install autocomplete-go builder-go file-icons git-plus go-config go-get go-plus go-rename gofmt gometalinter-linter gorename linter navigator-godev tester-go
apm install atom-material-syntax atom-material-syntax-dark atom-material-syntax-light atom-material-ui genesis-syntax genesis-ui one-dark-vivid-syntax
