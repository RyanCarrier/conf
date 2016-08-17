#!/bin/bash
GOLANGVERSION = "1.6.2"
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

if [ "$SCRIPTS" = true ];then
  if [[ "$OSTYPE" != "darwin"* ]];then
	   sudo ./scripts.sh
  else
    ./scripts.sh
  fi
fi
#oh my zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone git@github.com:powerline/fonts.git
cd fonts
sudo ./install
cd ..

if [ "$CONFS" = true ];then
	./confs.sh
fi

if [[ "$OSTYPE" != "darwin"* ]];then
  ./mac.sh
  exit 0
fi

if [ "$XSERVER" = true ];then
	add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
fi

apt-get update

apt-get install -y curl tar tmux vim rsync openssh-server traceroute vlc htop zip unzip python-pip shellcheck

pip install pep8
pip install autopep8

#Go
curl -O https://storage.googleapis.com/golang/go$GOLANGVERSION.linux-amd64.tar.gz
tar -C /usr/local -xzf go*.tar.gz
rm go*.tar.gz
if [ "$XSERVER" = true -a  ];then
	#qbit
	apt-get install -y qbittorrent

	#Chrome
	curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome*.deb
	apt-get install -fy
	rm google-chrome*.deb

	#Atom
	curl -OL https://atom.io/download/deb
	dpkg -i atom*.deb
	apt-get install -fy
	rm atom*.deb
	#Atom Packages
	apm install autocomplete-go builder-go file-icons git-plus go-config go-get go-plus go-rename gofmt gometalinter-linter gorename linter navigator-godev tester-go atom-beautify python-yapf autocomplete-python
	#Atom Themes
	apm install atom-material-syntax atom-material-syntax-dark atom-material-syntax-light atom-material-ui genesis-syntax genesis-ui one-dark-vivid-syntax
fi
