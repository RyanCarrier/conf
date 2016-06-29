#!/bin/bash
PWD=$(pwd)

if [ "$(id -u)" != "0" ]; then
 echo "Can't rm -rf /* without root"
 exit 1
fi
cd scripts
echo "Adding scripts"
for f in $(ls);do
  echo -ne "Linking $f... "
  ln -s $PWD/$f /usr/local/bin/$f
  if [ $? -eq 0 ];then
    echo -e "\tOK!"
  fi
done
cd $PWD
