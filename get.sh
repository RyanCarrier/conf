#!/bin/bash
if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
	echo "installing wget zsh and git"
	sudo apt-get install wget zsh git -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo "installing brew and git"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install git -y
fi
echo "changing default to zsh"
chsh -s "$(which zsh)"


echo "getting RyanCarrier/conf"
cd ~
git clone https://github.com/RyanCarrier/conf.git
cd conf
echo "starting setup.sh"
if [[ "$OSTYPE" == "darwin"* ]]; then
	./setup.sh
	exit 0
fi
sudo ./setup.sh
