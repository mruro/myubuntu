#!/bin/bash

everything() {
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

  set -e

  BRANCH="master"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-distroupdate.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-basepackages.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-byobu.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-zsh.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-powerlinefonts.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-docker.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-golang.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-golangliteide.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-awscli.sh -O -)"
  bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-panoramix.sh -O -)"
  # bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-emacsconfig.sh -O -)"      # emacs for Go, Ruby, Bash
  # bash -c "$(wget https://raw.githubusercontent.com/jig/myubuntu/$BRANCH/install-visualstudiocode.sh -O -)" # Visual Studio Code
  # Atom 
  # Sublime
}

everything
