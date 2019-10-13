#!/bin/bash
GOLANGVERSION="1.10.1"
if [ "$(id -u)" != "0" ]; then
  if [[ "$OSTYPE" != "darwin"* ]];then
   echo "sudo this shit fam" 1>&2
   exit 1
 fi
fi

CONFS=true;
read -p "ln confs? [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) CONFS=false ;;
esac

SCRIPTS=true;
read -p "ln scripts? [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) SCRIPTS=false ;;
esac
  if [[ "$OSTYPE" != "darwin"* ]];then
XSERVER=true;
read -p "X server enabled? [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) XSERVER=false ;;
esac
fi

HW=true;
read -p "Heavy install (install everything) [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) HW=false ;;
esac

if [ "$SCRIPTS" = true ];then
		echo "Starting scripts"
  if [[ "$OSTYPE" != "darwin"* ]];then
	   sudo ./scripts.sh
  else
    ./scripts.sh
  fi
fi
#oh my zsh
echo "getting oh my zsh"

sh -c "$(curl -fsSl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"

cd /home/rcarrier/
echo "getting fonts"
#git clone https://github.com/powerline/fonts.git
#cd fonts
#sudo ./install.sh

echo "applying rcarrier patch to zsh"
cd ~/.oh-my-zsh/
cp ~/conf/.oh-my-zsh.patch ./
git apply ./.oh-my-zsh.patch
rm ./.oh-my-zsh.patch
cd ~/conf

cd conf
echo "applying confs"
if [ "$CONFS" = true ];then
	./confs.sh
fi

if [[ "$OSTYPE" == "darwin" ]];then
  ./.mac.sh
  exit 0
fi

if [ "$XSERVER" = true -a "$HW" = true ];then
	add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
fi

apt update

apt install -y wget curl tar tmux vim rsync openssh-server traceroute vlc htop zip unzip python-pip shellcheck vlc v4l-utils v4l-conf ncdu tree neofetch kazam nmap htop nethogs

if [ "$HW" = true ];then
pip install pep8
pip install autopep8

#Go
curl -O https://storage.googleapis.com/golang/go$GOLANGVERSION.linux-amd64.tar.gz
tar -C /usr/local -xzf go*.tar.gz
rm go*.tar.gz
echo "Installing vim-go"
git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
if [ "$XSERVER" = true ];then
	#qbit
	apt-get install -y qbittorrent

	#Chrome
	curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome*.deb
	apt-get install -fy
	rm google-chrome*.deb
fi
fi
