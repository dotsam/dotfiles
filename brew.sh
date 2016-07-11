#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

#taps
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# tap services - see: https://github.com/Homebrew/homebrew-services
brew tap homebrew/services

# install current dev/vm version of php
brew install php56
brew install php56-mcrypt
brew install php56-xdebug

# sql stuff
brew install mariadb
brew install phpmyadmin
brew install sqlite

# install php mods / composer
brew install composer
brew install phpmd
brew install php-code-sniffer
brew install php-cs-fixer

# install some http benchmarking tools
brew install wrk
brew install siege
brew install vegeta

# install some network benchmarking/testing tools
brew install iperf3
brew install nuttcp
brew install mtr
brew install owamp
brew install scamper
brew install whatmask
brew install testssl

# ssh stuff
brew install ssh-copy-id
brew install stormssh

# Install other useful binaries.
brew install ack
brew install aria2
brew install git
brew install imagemagick --with-webp
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install speedtest_cli
brew install tree
brew install webkit2png
brew install zopfli
brew install nmap
brew install xz
brew install tmux
brew install ffmpeg --with-libvpx
brew install android-platform-tools
brew install grc
brew install aria2
brew install gifsicle
brew install htop-osx
brew install id3v2
brew install brightness
brew install netcat
brew install trash
brew install minicom
brew install unrar
brew install ffmpeg
brew install python

# Install Node Version Manager - because we are going to need to run multiple versions of node
brew install nvm
brew install https://raw.githubusercontent.com/lalitkapoor/nvm-auto-switch/master/homebrew/nvm-auto-switch.rb

#install rbenv and ruby build
brew install rbenv
brew install ruby-build
brew install rbenv-default-gems


# Remove outdated versions from the cellar.
brew cleanup
