#!/bin/bash
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	sudo apt-get install wget zsh git -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install git -y
fi
chsh -s $(which zsh)


cd ~
git clone https://github.com/RyanCarrier/conf.git
cd conf
if [[ "$OSTYPE" == "darwin"* ]]; then
	./init.sh
	exit 0
fi
sudo ./init.sh
