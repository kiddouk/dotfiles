#!/usr/bin/env bash

if [ ! -e /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install each tap and packages
cat ${HOME}/.dotfiles/brew-formula.lst | grep "^[^#]" | xargs -L1 brew

# Switch to using brew-installed zsh as default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
fi;

