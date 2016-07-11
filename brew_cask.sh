#!/usr/bin/env bash

# Install gui apps using Homebrew Cask.

# start by installing cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# utilities
brew cask install spectacle
brew cask install flux
brew cask install istat-menus
brew cask install witch
brew cask install gpgtools
brew cask install maddthesane-perian
brew cask install dropbox
brew cask install xquartz
brew cask install keepingyouawake

# multimedia
brew cask install handbrake
brew cask install vlc
brew cask install linein
brew cask install airfoil
brew cask install mpeg-streamclip
brew cask install fission

# apps
brew cask install nvalt
brew cask install textmate
brew cask install sublime-text
brew cask install coda
brew cask install skype
brew cask install macpar-deluxe
brew cask install pacifist
brew cask install google-chrome
brew cask install phonebrowse
brew cask install bonjour-browser
brew cask install slack
brew cask install transmit
brew cask install transmission
brew cask install the-unarchiver
brew cask install choosy
brew cask install harvest
brew cask install boxer
brew cask install fluid

# quicklook plugins
brew cask install betterzipql
brew cask install qlcolorcode
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install quicknfo
brew cask install suspicious-package
brew cask install webpquicklook
brew cask install provisionql
brew cask install qlimagesize

# desktop only?
#brew cask install logitech-harmony
#brew cask install bettertouchtool
#brew cask install steam
#brew cask install backblaze
#brew cask install sabnzbd
#brew cask install plex-media-server
