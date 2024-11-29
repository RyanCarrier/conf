#!/bin/bash
sudo echo ""

PACKAGES="which zsh wget curl tar tmux vim rsync traceroute vlc htop zip unzip python-pip shellcheck vlc v4l-utils ncdu tree neofetch nmap htop nethogs iperf iperf3 ripgrep nvm zoxide fzf prettier less"
ARCH_PACKAGES="fakeroot debugedit openssh make base-devel"
YAY_PACKAGES="light imagemagick feh fd bat neovim neovide hostname ttf-dejavu-nerd ttf-jetbrains-mono-nerd ttf-noto-nerd kitty pipewire wireplumber github-cli go-task go-yq"
echo "installing $PACKAGES"
echo "Cancel if you want, waiting for 10 seconds"
for _ in {10..1}; do
	echo "."
	sleep 1
done

if [ -f "/etc/arch-release" ]; then
	sudo pacman -Syyu --noconfirm
	# shellcheck disable=2086
	sudo pacman --noconfirm -S $PACKAGES $ARCH_PACKAGES
	cd /tmp || exit
	pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	cd yay || exit
	makepkg -si
	yay -Syyu --noconfirm snapd
	sudo systemctl enable --now snapd.socket
	sudo ln -s /var/lib/snapd/snap /snap
	cd ~/conf || exit
	# shellcheck disable=2086
	yay -Syyu --noconfirm $YAY_PACKAGES
else
	sudo apt upgrade && sudo apt install -y "$PACKAGES" openssh-server snapd
fi

#oh my zsh
echo "getting oh my zsh"

sh -c "$(curl -fsSl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
chsh -s "$(which zsh)"
sudo chsh -s "$(which zsh)" root
#rust
echo "Install rust yourself lol"
echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
if [ -f "/etc/arch-release" ]; then
	sudo pacman --noconfirm -Sy go
else
	sudo apt install -y golang-go
fi
