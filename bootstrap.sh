#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

for i in .*; do
  if [ $i != ".git" ]; then
    ln -s `pwd`/${i} ~/
  fi
done
