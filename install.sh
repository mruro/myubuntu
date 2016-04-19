#!/bin/sh
# From https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/install.sh

main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Starting installation...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }

  # Check OS is Linux
  if [ "$OSTYPE" != linux-gnu ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: This script is valid for Linux only"
      exit 1
    fi
  fi

  sudo apt-get update
  sudo apt-get -y upgrade
  # sudo apt-get -y dist-upgrade
  sudo apt-get -y autoremove

  sudo apt-get -y install git emacs24-nox byobu zsh

  # git directory structure
  mkdir -p ~/git/src/github.com

  # config Byobu
  cat > ~/.byobu/.tmux.conf <<EOF
set -g mouse-select-pane on
set -g mouse-select-window on
set -g mouse-resize-pane on
set -g mouse-utf8 on
set -g default-shell /usr/bin/zsh
set -g default-command /usr/bin/zsh
EOF

  # oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  echo 'ZSH_THEME="agnoster"' >> ~/.zshrc
  
  # Powerline
  mkdir -p ~/git/src/github.com/powerline
  cd ~/git/src/github.com/powerline
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
  # botó dret, i selecciona un font adaptat a Powerline
  # per exemple: Liberation Mono for Powerline

  
}

main
