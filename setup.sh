#!/bin/bash
GOLANGVERSION="1.10.1"
sudo echo ""

CONFS=true;
read -rp "ln confs? [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) CONFS=false ;;
esac

SCRIPTS=true;
read -rp "ln scripts? [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) SCRIPTS=false ;;
esac

HW=true;
read -rp "Heavy install (install go, rust) [Y/N] (default Y):" yn
case $yn in
		[Nn]* ) HW=false ;;
esac

XSERVER=true;
read -rp "X server enabled(install vscode, qbittorrent, flameshot, kdenlive and chrome)? [Y/N] (default Y):" yn
case $yn in
	[Nn]* ) XSERVER=false ;;
esac

if [ "$SCRIPTS" = true ];then
	echo "Starting scripts"
	sudo ./scripts.sh
fi
PACKAGES="zsh wget curl tar tmux vim rsync openssh-server traceroute vlc htop zip unzip python-pip shellcheck vlc v4l-utils ncdu tree neofetch nmap htop nethogs snapd iperf"
echo "installing $PACKAGES"

if [ -f "/etc/arch-release" ]; then
		sudo pacman -Syu
		sudo pacman --noconfirm -S "$PACKAGES"
else
		sudo apt upgrade && sudo apt install -y "$PACKAGES"
fi

#oh my zsh
echo "getting oh my zsh"

sh -c "$(curl -fsSl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
chsh -s "$(which zsh)"
sudo chsh -s "$(which zsh)" root

echo "applying rcarrier patch to zsh"
cd ~/.oh-my-zsh/ || { echo "no .oh-my-zsh folder"; exit ; }
cp ~/conf/.oh-my-zsh.patch ./
git apply ./.oh-my-zsh.patch
rm ./.oh-my-zsh.patch
cd ~/conf || { echo "fail to cd to conf"; exit ; }

echo "applying confs"
if [ "$CONFS" = true ];then
		./confs.sh
fi

if [[ "$OSTYPE" == "darwin" ]];then
		./.mac.sh
		exit 0
fi

if [ "$HW" = true ];then
		#Go
		echo "installing go"
		curl -O https://storage.googleapis.com/golang/go$GOLANGVERSION.linux-amd64.tar.gz
		sudo tar -C /usr/local -xzf go*.tar.gz
		rm go*.tar.gz
		echo "Installing vim-go"
		git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
		echo "Installing rust"
		curl https://sh.rustup.rs -sSf | sh

		if [ "$XSERVER" = true ];then
				sudo snap install code --classic
				#Chrome
				if [ -f "/etc/arch-release" ]; then
						cd /tmp/ || { echo "fail to cd to chrome"; exit ; }
						git clone https://aur.archlinux.org/google-chrome.git
						cd google-chrome || { echo "fail to cd to chrome"; exit ; }
						sudo makepkg -s --noconfirm
						sudo pacman --noconfirm -U google-chrome*.xz
						cd ~ || { echo "fail to cd ~"; exit ; }

						sudo pacman --noconfirm -Sy kdenlive flameshot qbittorrent
				else
					curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
					sudo dpkg -i google-chrome*.deb
					sudo apt-get install -fy
					rm google-chrome*.deb

					sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
					sudo apt install -y kdenlive flameshot qbittorrent
				fi
		fi
fi
