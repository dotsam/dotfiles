# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# TMUX
if which tmux >/dev/null 2>&1 && [[ "$SSH_CONNECTION" == "" ]]; then
    #if not inside a tmux session, and not connected via ssh, and if no session is started, start a new session
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{extra,path,bash_prompt,exports,aliases,functions,extra,sd}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Update window size after every command
shopt -s checkwinsize

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Save multi-line commands as one command
shopt -s cmdhist

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
# * Autocorrect typos in path names when using `cd`
# * Correct spelling errors during tab-completion
for option in autocd globstar cdspell dirspell; do
  shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
  source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion;  
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# OS X specific
if [[ "$OSTYPE" == darwin* ]]; then
  export EDITOR='mate -w';

  # Add tab completion for `defaults read|write NSGlobalDomain`
  # You could just use `-g` instead, but I like being explicit
  complete -W "NSGlobalDomain" defaults;

  # Add `killall` tab completion for common apps
  complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

  # When completing cd and rmdir, only dirs should be possible option (default is all files on Mac).
  complete -d cd rmdir
  
  # Add ssh agent/keychain stuff on macOS
  if ! grep -q 'UseKeychain yes$' ~/.ssh/config && ! grep -q 'AddKeysToAgent yes$' ~/.ssh/config; then
    if grep -q 'Host \*$' ~/.ssh/config; then
      sed -i '/Host \*$/a\ \ UseKeychain yes\n  AddKeysToAgent yes' ~/.ssh/config
    else
      printf "\nHost *\n  UseKeychain yes\n  AddKeysToAgent yes" >> ~/.ssh/config
    fi
  fi

else
  # Yeah, this doesn't work on OS X
  if [[ $SSH_CLIENT ]]; then
    if [[ $(netstat --numeric-ports -luet | grep $(whoami) | grep $(netstat -aent | grep $(echo $SSH_CLIENT | awk '{ print $2}') | awk '{ print substr($8,0,5)}')) ]]; then
      export EDITOR='rmate';
    fi    
  fi
fi

#nvm because node is just as fucked as ruby
if which brew &> /dev/null && [ -f "$(brew --prefix nvm)/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"
  # use nvm-auto-switcher if installed
  if [ -f "$(brew --prefix nvm-auto-switch)/nvm-auto-switch.sh" ]; then
    . "$(brew --prefix nvm-auto-switch)/nvm-auto-switch.sh"
  fi
fi

# Init rbenv if it exists
if which rbenv &> /dev/null; then eval "$(rbenv init -)"; fi

# hcl autocomplete aliases if they exist
[ -e "$HOME/.hcl/aliases" ] && complete -W "`cat ~/.hcl/aliases`" hcl
