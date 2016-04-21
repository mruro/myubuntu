minimal() {
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
 
  ###################################
  # Docker
  printf "${BLUE}Installing Docker, docker-machine and docker-compose...${NORMAL}\n"
  sudo apt-get -y install apt-transport-https ca-certificates
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  
  if [ ! -e /etc/apt/sources.list.d/docker.list ]; then
      # 14.04 LTS
      echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /tmp/docker.list
      # 16.04 LTS
      # echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /tmp/docker.list
      sudo mv /tmp/docker.list /etc/apt/sources.list.d/docker.list
  fi

  sudo apt-get update
  # sudo apt-get -y purge lxc-docker
  sudo apt-get -y install linux-image-extra-$(uname -r)
  sudo apt-get -y install apparmor

  # This is not in docker reference doc (maybe needed on beta 16.04 LTS only)
  sudo apt-get -y install cgroupfs-mount
  # This is not in docker reference doc (maybe needed on beta 16.04 LTS only)
  sudo apt-get -y install aufs-tools

  sudo apt-get -y install apparmor
  sudo apt-get -y install docker-engine
  sudo usermod -aG docker $USER
  printf "${YELLOW}You must logout and login to use Docker without sudo (use sudo docker ... meanwhile)...${NORMAL}\n"
  
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
minimal
