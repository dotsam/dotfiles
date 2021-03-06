# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Load tmux early so we don't set up a shell we're not going to really use
if which tmux >/dev/null 2>&1; then
  if [[ -z "$TMUX" ]]; then
    tmux has && tmux attach || tmux new-session
  fi
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{extra,path,bash_prompt,exports,aliases,functions,extra,sd}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Update window size after every command
shopt -s checkwinsize;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Save multi-line commands as one command
shopt -s cmdhist;

# When the command contains an invalid history operation (for instance when
# using an unescaped "!" (I get that a lot in quick e-mails and commit
# messages) or a failed substitution (e.g. "^foo^bar" when there was no "foo"
# in the previous command line), do not throw away the command line, but let me
# correct it.
shopt -s histreedit;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
# * Autocorrect typos in path names when using `cd`
# * Correct spelling errors during tab-completion
for option in autocd globstar cdspell dirspell; do
  shopt -s "$option" 2> /dev/null;
done;

if which brew &> /dev/null; then
	BREWPREFIX=$(brew --prefix)
fi;

# Add tab completion for many Bash commands
if [ $BREWPREFIX ] && [ -f "$BREWPREFIX/etc/profile.d/bash_completion.sh" ]; then
  # Ensure existing Homebrew v1 completions continue to work
  export BASH_COMPLETION_COMPAT_DIR="$BREWPREFIX/etc/bash_completion.d";
  source "$BREWPREFIX/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
  complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
fi;

# OS X specific
if [[ "$OSTYPE" == darwin* ]]; then
  export EDITOR='code -w';

  # Add tab completion for `defaults read|write NSGlobalDomain`
  # You could just use `-g` instead, but I like being explicit
  complete -W "NSGlobalDomain" defaults;

  # Add `killall` tab completion for common apps
  complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

  # When completing cd and rmdir, only dirs should be possible option (default is all files on Mac).
  complete -d cd rmdir
fi

# Init rbenv if it exists
if which rbenv &> /dev/null; then eval "$(rbenv init -)"; fi

#nvm because node is just as fucked as ruby
if [ $BREWPREFIX ] && [ -f "$BREWPREFIX/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  . "$BREWPREFIX/opt/nvm/nvm.sh"
fi

[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# hcl autocomplete aliases if they exist
[ -e "$HOME/.hcl/aliases" ] && complete -W "`cat ~/.hcl/aliases`" hcl

# load acme.sh
[[ -s "$HOME/.acme.sh/acme.sh.env" ]] && source "$HOME/.acme.sh/acme.sh.env"
