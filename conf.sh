#!/bin/bash
files=($(ls -A | grep '^\.'))
PWD=$(pwd)

for f in ${files[@]}
do
  if [ "$f" == ".git" ];then
    continue
  fi
  echo -n "Checking $f..."
  current="$PWD/$f"
  rl=$(readlink -f ~/$f)
  if [ -f ~/$f ]; then
    if [ $rl == $current ]; then
      echo -e "\tOK!"
      continue
    else
      echo -ne "\nBacking up $f..."
      mv ~/$f ~/$f.backup
    fi
  fi
  echo -ne "\nLinking $f..."
  ln -s $current ~/$f
  echo -e "\tOK!"
done
echo "Configs copied!"
