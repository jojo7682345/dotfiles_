#!/usr/bin/env bash

stow -t $XDG_CONFIG_HOME cfg -v
stow --dotfiles -t $HOME home -v
