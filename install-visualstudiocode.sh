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
  # Visual Studio Code (Microsoft)
  printf "${BLUE}Installing Go...${NORMAL}\n"
  sudo apt-get -y install git
  wget https://az764295.vo.msecnd.net/stable/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/vscode-amd64.deb -O /tmp/vscode.deb
  sudo dpkg -i /tmp/vscode.deb
}

# Check if reboot is needed
minimal
