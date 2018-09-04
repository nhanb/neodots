export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Activate virtualenv with the same name as current dir
function activate () {
    pyenv activate "${PWD##*/}"
}
