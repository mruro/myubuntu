golang() {
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

  VERSION=1.6.1

  printf "${BLUE}Installing Go...${NORMAL}\n"
  wget https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz -O /tmp/golang.tgz
  tar -C ~ -xzf /tmp/golang.tgz 

  if [ -e ~/.bashrc ]; then
      cat >> ~/.bashrc <<EOF
export GOPATH=\$HOME/git
export GOROOT=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF
  fi

  if [ -e ~/.zshrc ]; then
      cat >> ~/.zshrc <<EOF
export GOPATH=\$HOME/git
export GOROOT=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin:\$GOROOT/bin
EOF
  fi

  # Install stringer (for //go:generate -> https://blog.golang.org/generate)
  go get golang.org/x/tools/cmd/stringer

  # Install Delve Debugger
  printf "${BLUE}Installing Delve Debugger...${NORMAL}\n"
  go get github.com/derekparker/delve/cmd/dlv

  # Install GoMetaLinter
  printf "${BLUE}Installing GoMetaLinter...${NORMAL}\n"
  go get -u github.com/alecthomas/gometalinter
  gometalinter --install --update 

  # Install debugging, testing, linting tools (Meet Visual Studio Code 1.0.0 requirements)
  printf "${BLUE}Installing some Go tools...${NORMAL}\n"
  go get -u -v github.com/nsf/gocode
  go get -u -v github.com/rogpeppe/godef
  go get -u -v github.com/golang/lint/golint
  go get -u -v github.com/lukehoban/go-outline
  go get -u -v sourcegraph.com/sqs/goreturns
  go get -u -v golang.org/x/tools/cmd/gorename
  go get -u -v github.com/tpng/gopkgs
  go get -u -v github.com/newhook/go-symbols
  go get -u -v golang.org/x/tools/cmd/guru
}

# Check if reboot is needed
golang
