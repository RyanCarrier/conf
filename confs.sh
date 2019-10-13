#!/bin/bash
PWD=$(pwd)

for f in \.*
do
		if [ "$f" == ".git" ];then
				continue
		fi
		echo -n "Checking $f..."
		current="$PWD/$f"
		rl=$(readlink -f "$HOME/$f")
		if [ -f "$HOME/$f" ]; then
				if [ "$rl" == "$current" ]; then
						echo -e "\tOK!"
						continue
				else
						echo -ne "\nBacking up $f..."
						mv "$HOME/$f" "$HOME/$f.backup"
				fi
		fi
		echo -ne "\nLinking $f..."
		ln -s "$current" "$HOME/$f"
		echo -e "\tOK!"
done
echo "Configs copied!"
