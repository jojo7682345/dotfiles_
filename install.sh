#!/usr/bin/env bash

set -e

# -- utils --

msg() {
  printf "\033[32;1m%s\033[m %s\n" "$PROMPT" "$*"
}

warn() {
  >&2 printf "\033[33;1m%s \033[mwarning: %s\n" "$PROMPT" "$*"
}

die() {
  >&2 printf "\033[31;1m%s \033[merror: %s\n" "$PROMPT" "$*"
  exit 1
}

confirm() {
  >&2 printf "\033[33;1m%s \033[mconfirm? %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    >&2 printf '%s\n' 'Exiting.'
    exit 1
  }
  echo
}

ask() {
  >&2 printf "\033[33;1m%s \033[(y/N) %s" "$PROMPT" "$CONFIRM_PROMPT"
  read -n 1 -r ans
  echo
  [[ ! "$ans" =~ ^[Yy]$ ]] && {
    return 1
  }
}

has() {
  if ! command -v "$1" &>/dev/null; then
    return 1
  fi
}

main() {
  has stow || die "stow is not installed"
  stow -t $XDG_CONFIG_HOME cfg -v
  stow --dotfiles -t $HOME home -v
}

main "$@"
