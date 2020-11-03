# If non-interactive, just add to the path then exit
[ -z "$PS1" ] && source ~/.path && return

# Otherwise we must be interactive, so load bash_profile
source ~/.bash_profile
