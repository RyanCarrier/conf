#!/bin/bash
echo "installing git and something else also maybe it depends ok"
if [ -f "/etc/arch-release" ]; then
		sudo pacman -S git
elif [[ "$OSTYPE" == *"linux-gnu"* ]]; then
		sudo apt install curl zsh git -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install git -y
fi

echo "getting RyanCarrier/conf"
cd ~ || { echo "fail to cd to ~" ; exit ; }
git clone https://github.com/RyanCarrier/conf.git
cd conf || { echo "fail to cd to ~" ; exit ; }
echo "starting setup.sh"
./setup.sh
