export DOTFILES="$HOME/neodots"

# Sensible™ defaults
source "$DOTFILES/bash/sensible.bash"
source "$DOTFILES/bash/xubuntu.bash"

# The only proper editor
export EDITOR=vim
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# General-purpose aliases
source "$DOTFILES/bash/aliases.bash"

# Fancy prompt
source "$DOTFILES/bash/prompt.bash"

# pyenv
if [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# added by pipsi (https://github.com/mitsuhiko/pipsi)
export PATH="/home/nhanb/.local/bin:$PATH"
