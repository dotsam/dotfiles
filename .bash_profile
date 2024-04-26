# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Base16 Shell Colours
export BASE16_SHELL="$HOME/.config/base16-shell/"
if [ -s "$BASE16_SHELL/profile_helper.sh" ]; then
  source "$BASE16_SHELL/profile_helper.sh"
fi

# Load tmux early so we don't set up a shell we're not going to really use
if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
  if which tmux >/dev/null 2>&1; then
    tmux has && tmux attach || tmux new-session
  fi
fi

# Set up envs from brew early
# TODO: Look for x86 brew too?
if which brew &> /dev/null; then
  # eval "$(brew shellenv)"
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
fi;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra,sd}; do
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

# Add tab completion for many Bash commands
if [ $HOMEBREW_PREFIX ] && [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  # Ensure existing Homebrew v1 completions continue to work
  export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_PREFIX/etc/bash_completion.d";
  source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
  __git_complete g __git_main;
fi;

# Nano syntax highlighting
if [ ! -L $HOME/.config/nano/syntax ] || [ ! -d $HOME/.config/nano/syntax ]; then
  if [ $HOMEBREW_PREFIX ] && [ -L "$HOMEBREW_PREFIX/share/nanorc" ]; then
    mkdir -p $HOME/.config/nano
    ln -s $HOMEBREW_PREFIX/share/nanorc $HOME/.config/nano/syntax
  elif [ $HOMEBREW_PREFIX ] && [ -L "$HOMEBREW_PREFIX/share/nano" ]; then
    mkdir -p $HOME/.config/nano
    ln -s $HOMEBREW_PREFIX/share/nano $HOME/.config/nano/syntax
  elif [ -d "/usr/share/nano" ]; then
    mkdir -p $HOME/.config/nano
    ln -s /usr/share/nano $HOME/.config/nano/syntax
  else
    mkdir -p $HOME/.config/nano/syntax
    touch $HOME/.config/nano/syntax/empty.nanorc
  fi
fi

# OS X specific
if [[ "$OSTYPE" == darwin* ]]; then
  export EDITOR='code';
  export VISUAL='code -w';

  # Add tab completion for `defaults read|write NSGlobalDomain`
  # You could just use `-g` instead, but I like being explicit
  complete -W "NSGlobalDomain" defaults;

  # Add `killall` tab completion for common apps
  complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

  # When completing cd and rmdir, only dirs should be possible option (default is all files on Mac).
  complete -d cd rmdir
fi

# load acme.sh
[[ -s "$HOME/.acme.sh/acme.sh.env" ]] && source "$HOME/.acme.sh/acme.sh.env"

# asdf version manager
[ $HOMEBREW_PREFIX ] && [ -L "$HOMEBREW_PREFIX/opt/asdf" ] && source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

# ble.sh
[ -s "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"

# atuin
if which atuin &> /dev/null; then
  eval "$(atuin init bash)"
fi;
