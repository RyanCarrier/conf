#!/bin/bash
PWD=$(pwd)

if [ "$(id -u)" != "0" ]; then
		echo "Can't rm -rf /* without root"
		exit 1
fi
cd scripts || { echo "fail to cd in scripts"; exit ; }
echo "Adding scripts"
for f in *;do
		echo -ne "Linking $f... "
		if ln -s "$PWD/$f" "/usr/local/bin/$f"
		then
				echo -e "\tOK!"
		fi
done
cd "$PWD" || { echo "fail to cd to $PWD"; exit ; }
