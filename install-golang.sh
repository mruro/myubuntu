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
  # Golang
  printf "${BLUE}Installing Go...${NORMAL}\n"
  wget https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz -O /tmp/golang.tgz
  tar -C ~/go -xzf /tmp/golang.tgz 
  if [ -e ~/.zshrc ]; then
      cat >> ~/.zshrc <<EOF
export GOPATH=\$HOME/git
export GOROOT=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF

      cat >> ~/.bashrc <<EOF
export GOPATH=\$HOME/git
export GOROOT=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF
  fi
}

# Check if reboot is needed
minimal
