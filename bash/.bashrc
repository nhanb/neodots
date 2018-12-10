# shellcheck source=/dev/null

export DOTFILES="$HOME/neodots"
export PRIVATE_DOTFILES="$HOME/Dropbox/privdots"

# Sensible™ defaults
source "$DOTFILES/bash/sensible.bash"
source "$DOTFILES/bash/xubuntu.bash"

# The only proper editor
export EDITOR=nvim
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"
alias vim=nvim
alias vi=nvim


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

# kitty terminal
if [ -d "$HOME/.local/kitty.app" ]; then
    export PATH="$HOME/.local/kitty.app/bin:$PATH"
fi

# proper python package manager
if [ -d "$HOME/.poetry" ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
