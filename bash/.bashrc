# shellcheck source=/dev/null

export DOTFILES="$HOME/neodots"
export PRIVATE_DOTFILES="$HOME/Sync/Syncbox/privdots"

# Sensible™ defaults
source "$DOTFILES/bash/sensible.bash"
source "$DOTFILES/bash/xubuntu.bash"

export SSH_ASKPASS="ksshaskpass"

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
    for PRIVFILE in "$PRIVATE_DOTFILES"/bash/*.bash; do
        source "$PRIVFILE"
    done
fi

# Downloaded single-executable programs
if [ -d "$HOME/binaries" ]; then
    export PATH="$HOME/binaries:$PATH"
fi

# ruby gems
if [ -d "$HOME/.gem/ruby/2.5.0/bin" ]; then
    export PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"
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

# nim
if [ -d "$HOME/.nimble" ]; then
    export PATH="$HOME/.nimble/bin:$PATH"
fi

# ruby
if [ -d "$HOME/.gem/ruby/2.6.0/bin" ]; then
    export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
fi

# When using Arch Linux OS-provided `npm` package, the following allows me to
# use `npm install -g` as a user-wide installation instead of trashing
# /usr/lib/node_modules like a neanderthal.
export PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
