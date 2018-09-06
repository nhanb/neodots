export DOTFILES="$HOME/neodots"
export PRIVATE_DOTFILES="$HOME/Dropbox/privdots"

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

# Private stuff not suitable for public eyes
if [ -d "$PRIVATE_DOTFILES" ]; then
    for PRIVFILE in $PRIVATE_DOTFILES/bash/*.bash; do
        source "$PRIVFILE"
    done
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
    source "$DOTFILES/bash/pyenv.bash"
fi

# added by pipsi (https://github.com/mitsuhiko/pipsi)
export PATH="/home/nhanb/.local/bin:$PATH"

# rust
if [ -d "$HOME/.cargo" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
