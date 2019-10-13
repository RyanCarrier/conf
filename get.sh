#!/bin/bash
if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
		echo "installing curl zsh and git"
		sudo apt install curl zsh git -y
elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo "installing brew and git"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install git -y
fi
echo "changing default to zsh"

chsh -s "$(command -v zsh)"

echo "getting RyanCarrier/conf"
cd ~ || { echo "fail to cd to ~" ; exit ; }
git clone https://github.com/RyanCarrier/conf.git
cd conf || { echo "fail to cd to ~" ; exit ; }
echo "starting setup.sh"
./setup.sh
