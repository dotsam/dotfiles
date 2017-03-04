#!/usr/bin/env bash

echo 'OS X System Bootstrap Script'
echo '----------------------------'
echo ''

#echo 'Enter new hostname of the machine:'
#  read hostname
#  echo "Setting new hostname to $hostname..."
#  scutil --set HostName "$hostname"
#  compname=$(sudo scutil --get HostName | tr '-' '.')
#  echo "Setting computer name to $compname"
#  scutil --set ComputerName "$compname"
#  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

# Check for Homebrew Installation
if ! which brew > /dev/null; then
     # Install Homebrew
     /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi;

# Update Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install everything inside Brewfile
brew bundle

# Remove outdated versions from the cellar.
brew cleanup

# initial copy of dotfiles
echo 'Copying dotfiles'
./bootstrap.sh

# os x defaults
echo 'Setting OS X defaults'
sh .osx

ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;