#!/usr/bin/env bash

echo 'OS X System Bootstrap Script'
echo '----------------------------'
echo ''
echo 'Getting your admin password up front and maintaining it'

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo 'Enter new hostname of the machine:'
  read hostname
  echo "Setting new hostname to $hostname..."
  scutil --set HostName "$hostname"
  compname=$(sudo scutil --get HostName | tr '-' '.')
  echo "Setting computer name to $compname"
  scutil --set ComputerName "$compname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$compname"

##############################################################################################################
### XCode Command Line Tools
#      thx  https://github.com/alrra/dotfiles/blob/c2da74cc333/os/os_x/install_applications.sh#L39

if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
		echo 'Installing XCode Command Line Tools'
    xcode-select --install &> /dev/null
    # Wait until the XCode Command Line Tools are installed
    while [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; do
        sleep 5
    done
	xcode-select -p &> /dev/null
	if [ $? -eq 0 ]; then
        # Prompt user to agree to the terms of the Xcode license
        # https://github.com/alrra/dotfiles/issues/10
       sudo xcodebuild -license
   fi
fi
###
##############################################################################################################

# install homebrew
echo 'Installing Homebrew'
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install things from homebrew
echo 'Installing command line and gui apps/tools from Homebrew/Cask'
./brew.sh
./brew_cask.sh

# change to bash 4 (installed by homebrew)
echo 'Switching you to bash 4'
echo 'NOPE! Rootless on 10.11 prevents editing /etc/shells. Do it in singleuser?'
#BASHPATH=$(brew --prefix)/bin/bash
#sudo echo $BASHPATH >> /etc/shells
#chsh -s $BASHPATH # will set for current user only.
#echo $BASH_VERSION # should be 4.x not the old 3.2.X

# Type `git open` to open the GitHub page or website for a repository.
echo 'Installing git-open'
npm install -g git-open

# set up textmate symlink
echo 'Setting up TextMate mate alias'
ln -sf ~/Applications/TextMate.app/Contents/Resources/mate ~/bin/mate

# initial copy of dotfiles
echo 'Copying dotfiles'
./bootstrap.sh

# os x defaults
echo 'Setting OS X defaults'
sh .osx