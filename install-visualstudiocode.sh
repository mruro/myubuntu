vsc() {
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
  printf "${BLUE}Installing Visual Studio Code (Microsoft)...${NORMAL}\n"
  sudo apt-get -y install git libgtk2.0-0 libgconf-2-4 libasound2 libnss3 libxtst6
  # version 1.0.0:
  wget https://az764295.vo.msecnd.net/stable/fa6d0f03813dfb9df4589c30121e9fcffa8a8ec8/vscode-amd64.deb -O /tmp/vscode.deb
  sudo dpkg -i /tmp/vscode.deb

  if [ ! -d ~/.vscode ]; then
      mkdir ~/.vscode
  fi

  if [ ! -e ~/.vscode/settings.json ]; then
      cat > ~/.vscode/settings.json <<EOF
{
    "go.buildOnSave": true,
    "go.lintOnSave": true,
    "go.vetOnSave": true,
    "go.buildTags": "",
    "go.buildFlags": [],
    "go.lintFlags": [],
    "go.vetFlags": [],
    "go.coverOnSave": false,
    "go.useCodeSnippetsOnFunctionSuggest": false,
    "go.formatOnSave": true,
    "go.formatTool": "goreturns",
    "go.goroot": "~/go",
    "go.gopath": "~/git",
    "go.gocodeAutoBuild": false
}
EOF
    fi

    if [ ! -e ~/.vscode/launch.json ]; then
      cat > ~/.vscode/launch.json <<EOF
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Launch",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${workspaceRoot}",
            "env": {},
            "args": []
        }
    ]
}
EOF
    fi

    printf "${YELLOW}Go plugin Visual Studio Code: install it with <Ctrl+Shift+P> and then 'ext install go'...${NORMAL}\n"
}

# Check if reboot is needed
vsc
