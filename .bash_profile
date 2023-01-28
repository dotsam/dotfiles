# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Load tmux early so we don't set up a shell we're not going to really use
if which tmux >/dev/null 2>&1; then
  if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
    tmux has && tmux attach || tmux new-session
  fi
fi

# Start fresh with path in a new shell via tmux
if [ -n "$TMUX" ] && [ -f /etc/profile ]; then
  PATH=""
  source /etc/profile
fi

# Set up envs from brew early
# TODO: Look for x86 brew too?
if which brew &> /dev/null; then
  eval "$(brew shellenv)"
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

# load rbenv
if which rbenv &> /dev/null; then eval "$(rbenv init -)"; fi

# my custom php version manager (WIP)
export PHPENV_ROOT="$HOME/.phpenv"
if [[ -d $PHPENV_ROOT ]]; then
  PATH="$PHPENV_ROOT/bin:$PATH"
  eval "$(phpenv init -)"
fi;

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Base16 Shell Colours
export BASE16_SHELL="$HOME/.config/base16-shell/"
if [ -s "$BASE16_SHELL/profile_helper.sh" ]; then
  source "$BASE16_SHELL/profile_helper.sh"
fi

# load atuin
if which atuin &> /dev/null && [[ -f ~/.local/bash-preexec.sh ]]; then
  source ~/.local/bash-preexec.sh
  eval "$(atuin init bash)"
fi;
