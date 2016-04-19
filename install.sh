#!/bin/sh
# From https://github.com/robbyrussell/oh-my-zsh/blob/master/tools/install.sh

myubuntu() {
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
 
  printf "${BLUE}Upgrading Ubuntu...${NORMAL}\n"
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get -y autoremove

  printf "${BLUE}Installing Ubuntu prepared packages...${NORMAL}\n"
  sudo apt-get -y install curl wget git zsh emacs24-nox byobu

  # git directory structure
  mkdir -p ~/git/src/github.com
  mkdir -p ~/git/src/safelayer.com

  # config Byobu
  printf "${BLUE}Installing and configuring Byobu...${NORMAL}\n"
  byobu-ctrl-a emacs

  if [ ! -d ~/.byobu ]; then
  cat > ~/.byobu/.tmux.conf <<EOF
set -g mouse-select-pane on
set -g mouse-select-window on
set -g mouse-resize-pane on
set -g mouse-utf8 on
set -g default-shell /usr/bin/zsh
set -g default-command /usr/bin/zsh
EOF
  fi

  # oh-my-zsh
  printf "${BLUE}Installing Oh-my-zsh...${NORMAL}\n"
  # echo -n "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" | sed -e "s/env zsh//" > /tmp/install-zsh.sh
  echo -n "$(curl -fsSL https://raw.githubusercontent.com/jig/oh-my-zsh/master/tools/install.sh)" | sed -e "s/env zsh//" > /tmp/install-zsh.sh
  chmod 700 /tmp/install-zsh.sh
  bash -x -c /tmp/install-zsh.sh
  sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/" ~/.zshrc
  
  # Powerline
  printf "${BLUE}Installing Powerline fonts...${NORMAL}\n"
  mkdir -p ~/git/src/github.com/powerline
  cd ~/git/src/github.com/powerline
  if [ ! -d fonts ]; then
      git clone https://github.com/powerline/fonts.git
      cd fonts
      ./install.sh
  fi

  # botó dret, i selecciona un font adaptat a Powerline
  # per exemple: Liberation Mono for Powerline

  ###################################
  # Docker
  printf "${BLUE}Installing Docker...${NORMAL}\n"
  sudo apt-get -y install apt-transport-https ca-certificates
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  
  if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
      echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /tmp/docker.list
      sudo mv /tmp/docker.list /etc/apt/sources.list.d/docker.list
  fi

  sudo apt-get update
  sudo apt-get -y purge lxc-docker
  sudo apt-get -y install linux-image-extra-$(uname -r)
  sudo apt-get -y install apparmor
  sudo apt-get -y install docker-engine
  sudo usermod -aG docker $USER
  
  # Rebota (per a que et posi efectivament al grup de docker,
  # i per que faci servir el nou kernel
  
  # Docker Compose i Machine
  printf "${BLUE}Installing docker-compose...${NORMAL}\n"
  curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
  sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  printf "${BLUE}Installing docker-machine...${NORMAL}\n"
  curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /tmp/docker-machine 
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine 
  sudo chmod +x /usr/local/bin/docker-machine
}

# Check if reboot is needed
myubuntu
