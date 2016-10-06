#!/usr/bin/env bash

./brew.sh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Now copy the conf file
rm ~/.zshrc
ln -s `pwd`/zsh/.zshrc ~/.zshrc
mkdir ~/.zsh
ln -s `pwd`/zsh/completions ~/.zsh/

cd "$(dirname "${BASH_SOURCE}")";

for i in .*; do
  if [ $i != ".git" ]; then
    ln -s `pwd`/${i} ~/
  fi
done
